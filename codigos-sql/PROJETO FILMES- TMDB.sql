
-- Importando tabelas contendo dados brutos
CREATE TABLE tmdb_movies(

budget TEXT,--fato
genres TEXT,--genero
homepage TEXT,--filme
id TEXT,--ambos
keywords TEXT,
original_language TEXT,
original_title TEXT,
overview TEXT,
popularity TEXT,
production_companies TEXT,
production_countries TEXT,
release_date TEXT,
revenue TEXT,
runtime TEXT,
spoken_languages TEXT,
status TEXT,
tagline TEXT,
title TEXT,
vote_average TEXT,
vote_count TEXT

) 

CREATE TABLE tmdb_credits(
movie_id text,
title text
,"cast" text,
crew TEXT

)
-- criando views( tabelas dimensao e fato)

-- genero
CREATE VIEW dim_genresmv as

SELECT DISTINCT
	json_array_elements(genres::json) ->> 'id' as genre_id,
	json_array_elements(genres::json) ->> 'name' as genre_name
FROM tmdb_movies

-- tabela ponte
CREATE VIEW bridge_table as

SELECT 
	id,
	json_array_elements(genres::json) ->> 'id' as genre_id	
FROM tmdb_movies 

--diretor
CREATE VIEW dim_director as 

WITH cc AS(
SELECT 
	movie_id,
	json_array_elements(crew::json) ->> 'department' as department,
	json_array_elements(crew::json) ->> 'name' as name_crew,
	json_array_elements(crew::json) ->> 'job' as job
FROM tmdb_credits)

SELECT * 
	FROM cc 
WHERE department in ('Directing') and job = 'Director'

--TABELA FATO
CREATE VIEW fact_director as
SELECT 
	budget,
	id as movie_id,
	original_title,
	popularity,
	release_date ::date,
	revenue,
	vote_average,
	vote_count,
	(revenue ::float-budget::float) as profit
		
FROM tmdb_movies
WHERE release_date is not null

