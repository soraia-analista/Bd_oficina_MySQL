SHOW DATABASES;
-- criação do banco de dados oficina_mecanica
CREATE DATABASE IF NOT EXISTS  oficina_mecanica;
USE oficina_mecanica;

-- 01 - Criação da TABELA clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    whatsapp VARCHAR(14),
    endereco VARCHAR (245)
);

-- 02 - Criação da TABELA veiculos
CREATE TABLE veiculos (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    modelo VARCHAR(50),
    marca VARCHAR(50),
    ano INT,
    id_cliente INT,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);


-- 03 - Criação da TABELA Fornecedores
CREATE TABLE fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_fantasia VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) UNIQUE,
    contato VARCHAR(50),
    whatsapp VARCHAR(14)
);

-- 04 - Criação da TABELA Peças 
CREATE TABLE pecas (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome_peca VARCHAR(100) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT DEFAULT 0,
    valor_custo DECIMAL(10,2),
    valor_venda DECIMAL(10,2),
    id_fornecedor INT,
    CONSTRAINT fk_peca_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id_fornecedor)
);

-- 05 - Criação da TABELA Catálogo de Serviços
CREATE TABLE catalogo_servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    tipo_servico VARCHAR(245) NOT NULL,
    valor_mao_de_obra DECIMAL(10,2) NOT NULL
);

ALTER TABLE catalogo_servicos 
RENAME COLUMN descricao TO tipo_servico;


-- 06 - Criação da TABELA Ordem de Serviço (OS)
CREATE TABLE ordem_servico (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    data_emissao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aberta', 'Em Execução', 'Concluída', 'Cancelada','Baixa no Sistema') DEFAULT 'Aberta',
    valor_total_pecas DECIMAL(10,2) DEFAULT 0.00,
    valor_total_servicos DECIMAL(10,2) DEFAULT 0.00,
    valor_geral_os DECIMAL(10,2) DEFAULT 0.00,
    id_veiculo INT,
    CONSTRAINT fk_os_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculos(id_veiculo)
);

-- 07 - Criação da TABELA itens_os_pecas
CREATE TABLE itens_os_pecas (
    id_item_peca INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT NOT NULL,
    id_peca INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario_no_momento DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) AS (quantidade * valor_unitario_no_momento),
    CONSTRAINT fk_item_os FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    CONSTRAINT fk_item_peca FOREIGN KEY (id_peca) REFERENCES pecas(id_peca)
);

-- 08 - Criação da TABELA itens_os_servicos
CREATE TABLE itens_os_servicos (
    id_item_servico INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT,
    id_servico INT,
    quantidade INT DEFAULT 1,
    valor_servico_momento DECIMAL(10,2),
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    FOREIGN KEY (id_servico) REFERENCES catalogo_servicos(id_servico)
);
-- 09 - Criação da TABELA Formas de Pagamento
CREATE TABLE formas_pagamento (
    id_forma INT AUTO_INCREMENT PRIMARY KEY,
    descricao ENUM('Cartão-Crédito','Cartão-Débito', 'Dinheiro','Pix', 'Boleto') NOT NULL
    
);

-- 10 - Criação da TABELA Controle de Pagamentos
CREATE TABLE pagamentos_os (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT,
    id_forma INT,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pagamento ENUM('Pendente', 'Pago', 'Atrasado', 'Cancelado') DEFAULT 'Pendente',
    CONSTRAINT fk_pagto_os FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    CONSTRAINT fk_pagto_forma FOREIGN KEY (id_forma) REFERENCES formas_pagamento(id_forma)
);

-- Inserção de dados nas tabelas, começando pelas de base (pais)

INSERT INTO clientes (nome, sobrenome, cpf_cnpj, whatsapp, endereco) 
VALUES
    ('Abraão Custódio', 'Silveira', '951.026.753-17', '(37)98745-1236','Avenida das Nações, 157 Centro Itaúna MG'),
    ('Alex ', 'Alvares Mattos', '157.128.536-42', '(38) 2128-1449','Rua Acacias, 10 Imperial Milho Verde MG'),
    ('Xisto ', 'Carborador', '22.100.121/0001-58', '(11)97845-6211','Rua Djalma Fonseca, 615 Zona Norte São Paulo SP'),
    ('Flávia Cristina', 'Lisboa', '541.651.897-26', '(13)4878-2647','Maria Malaquias, 61 Palmares Cotia SP'),
    ('Vilma Aparecida', 'Oliveira Campos', '874.698.231-44', '(31)92548-6231','Avenida Yolanda Teixeira, 1817 sobreloja Aparecida Belo Horizonte MG'),
    ('Marcelo  ', 'Dias', '987.514.321-88', '(11)7899-4515','Rua Armênia, 417 Ibirapuera São Paulo SP'),
    ('Olavo', 'Ferreira Lanternagem', '57.823.130/0001-01', '(11)98001-4578','Ari Barroso, 107 Cubatão SP'),
    ('Rubens ', 'Villas Boas', '125.123.654-78', '(11)98647-1401','Ataúlfo Alves, 401 Vila Formosa São Paulo SP'),
    ('Vitor Hugo ', 'Andradas', '654.231.457-61', '(21)98178-4583','Rua Manoel Bandeira, 975 Savassi Rio de Janeiro RJ'),
    ('Patrícia', 'Souza Marques', '878.364.487-99', '(21)978456211','Rua Eustáquio Negrão, 100 Cabana RJ');
    
desc clientes;
select * from clientes;

INSERT INTO veiculos (id_veiculo, placa, modelo, marca, ano, id_cliente) 
VALUES 
	(1, 'ZPX-3748', 'Onix', 'Chevrolet', 2022, 1),
	(2, 'REG-5678', 'HB20', 'Hyundai', 2021, 2),
	(3, 'KUT-9012', 'Corolla', 'Toyota', 2023, 3),
	(4, 'JKL-3456', 'Civic', 'Honda', 2019, 4),
	(5, 'PUM-7890', 'Compass', 'Jeep', 2020, 5),
	(6, 'INF-1122', 'Gol', 'Volkswagen', 2015, 6),
	(7, 'ZTY-3344', 'Renegade', 'Jeep', 2022, 7),
	(8, 'OBA-5566', 'Mobi', 'Fiat', 2021, 8),
	(9, 'NHO-7788', 'CG 160 Titan', 'Honda', 2023, 9),
	(10, 'BCD-9900', 'Hilux', 'Toyota', 2018, 10);
desc veiculos;
select * from veiculos;

INSERT INTO fornecedores (nome_fantasia, cnpj, contato, whatsapp) 
VALUES 
	('Auto Peças Braster', '12.524.674/0001-01', 'Armando  Borgues', '(11)98765-4321'),
	('Distribuidora Vale do Sereno', '23.456.789/0001-02', 'Mariana Costa', '(31)99876-5432'),
	('Mecânica & Cia', '7.567.890/0001-03', 'Eunice Vianna', '(23)97654-3210'),
	('Shopping dos Pneus', '45.678.901/0001-04', 'Duarte Limeira', '(71)98888-7777'),
	('Logística Express', '56.789.012/0001-05', 'João Pereira', '(19 91234-5678'),
	('Stop Car Fornecedora', '67.890.123/0001-06', 'Caio Souza', '(27)92345-6789'),
	('Peças & Motores', '78.901.234/0001-07', 'Sérgio Ramos', '(51)93456-7890'),
	('Global Lanternagem', '89.012.345/0001-08', 'Aline Vieira', '(62)94567-8901'),
	('Foco Distribuição', '90.123.456/0001-09', 'Viviane Lula Rocha', '(85)95678-9012'),
	('Brasil Faróis', '01.234.567/0001-10', 'Cláudia Reis', '(98)96789-0123');
desc fornecedores;
select * from fornecedores;


INSERT INTO pecas (nome_peca, categoria, valor_unitario, quantidade_estoque, valor_custo, valor_venda, id_fornecedor) 
VALUES 
	('Kit Embreagem LUK', 'Transmissão', 850.00, 5, 600.00, 850.00, 1),
	('Pastilha de Freio Cerâmica', 'Freios', 120.00, 15, 75.00, 120.00, 3),
	('Filtro de Óleo Fram', 'Motor', 45.00, 30, 22.00, 45.00, 2),
	('Amortecedor Dianteiro Cofap', 'Suspensão', 380.00, 8, 260.00, 380.00, 7),
	('Kit Relação (Coroa/Pinhão/Corrente)', 'Moto - Transmissão', 180.00, 12, 110.00, 180.00, 10),
	('Bateria Moura 60Ah', 'Elétrica', 490.00, 10, 340.00, 490.00, 8),
	('Vela de Ignição Iridium', 'Moto - Motor', 65.00, 20, 35.00, 65.00, 9),
	('Pneu 175/70 R14 Pirelli', 'Pneus', 320.00, 4, 210.00, 320.00, 4),
	('Bomba de Combustível Bosch', 'Injeção', 280.00, 6, 175.00, 280.00, 5),
	('Óleo Semisintético 10W40 (Litro)', 'Lubrificantes', 42.00, 50, 25.00, 42.00, 6);
desc pecas;
select * from pecas;

INSERT INTO catalogo_servicos (tipo_servico, categoria, valor_mao_de_obra) 
VALUES 
	('Troca de Óleo e Filtro', 'Óleo', 1000.00),
	('Instalação de Acessórios', 'Diversos', 1000.00),
	('Filtro de Óleo Fram', 'Motor', 250.00),
	('Limpeza carburador', 'Modelos Antigos', 600.00),
	('Retífica de Motor', 'Motor', 5000.00),
	('Substituição da Correia Dentada', 'Elétrica', 800.00),
	('Recarga de Gás do Ar-Condicionado', 'Elétrica', 1800.00),
	('Troca Freios', 'Freios', 500.00),
	('Diagnóstico via Scanner', 'Injeção Eletrônica', 1000.00),
	('Lanternagem e Pintura', 'Acabamento', 2000.00);
desc catalogo_servicos;
select * from catalogo_servicos;

INSERT INTO ordem_servico (status, valor_total_pecas, valor_total_servicos, valor_geral_os, id_veiculo) 
VALUES 
    ('Em Execução', 450.00, 150.00, 600.00, 2),
    ('Aberta', 500.00, 800.00, 1300.00, 1),
    ('Concluída', 600.00, 2000.00, 2600.00, 10),
    ('Baixa no Sistema', 1500.00, 5000.00, 6500.00, 9),
    (DEFAULT, 850.00, 2000.00, 2850.00, 4), 
    (DEFAULT, 1000.00, 890.00, 1890.00, 3),
    (DEFAULT, 910.00, 500.00, 1410.00, 5),
    (DEFAULT, 1500.00, 3000.00, 4500.00, 6),
    (DEFAULT, 1500.00, 3000.00, 4500.00, 8),
    (DEFAULT, 1500.00, 1500.00, 3000.00, 7);

desc ordem_servico;
select * from ordem_servico;

INSERT INTO formas_pagamento (descricao) 
VALUES 
	('Cartão-Crédito'),
	('Cartão-Débito'),
	('Dinheiro'),
	('Pix'),
	('Boleto');
    
desc formas_pagamento;
select * from formas_pagamento;

INSERT INTO itens_os_pecas (id_os, id_peca, quantidade, valor_unitario_no_momento) 
VALUES 
    (1, 10, 4, 45.00),
    (1, 2, 1, 120.00), 
    (7, 3, 1, 500.00),
    (7, 1, 2, 200.00),
    (4, 2, 1, 100.00),
    (2, 7, 1, 899.00),
    (2, 5, 2, 100.00),
    (2, 9, 1, 600.00),
    (2, 10, 3, 500.00),
    (2, 6, 1, 399.00);
    
desc itens_os_pecas;
select * from itens_os_pecas;

INSERT INTO itens_os_servicos (id_os, id_servico, quantidade, valor_servico_momento) 
VALUES 
    (8, 10, 2, 45.00),
    (8, 6, 1, 100.00),
    (10, 5, 1, 200.00),
    (2, 1, 1, 400.00),
    (3, 2, 1, 200.00),
    (4, 2, 1, 100.00),
    (6, 7, 1, 100.00),
    (5, 9, 1, 200.00),
    (1, 8, 1, 200.00),
    (7, 4, 1, 300.00);
    
    
 desc itens_os_servicos;
select * from itens_os_servicos;
ALTER TABLE itens_os_servicos 
RENAME COLUMN valor_momento_servico TO valor_servico_momento;   

INSERT INTO pagamentos_os (id_os, id_forma, valor_pago, status_pagamento) 
VALUES 
    (1, 4, 600.00, 'Pago'),
    (1, 4, 500.00, 'Pendente'),
    (3, 4, 200.00, 'Pago'),
    (8, 1, 400.00, 'Pago'),
    (10, 2, 200.00, 'Pago'),
    (7, 3, 100.00, 'Pendente'),
    (6, 3, 1890.00, 'Pago'),
    (5, 3, 200.00, default),
    (4, 3, 200.00, default),
    (2, 4, 300.00, default);

desc pagamentos_os;  
select * from pagamentos_os;  

-- queries para recuperação de dados das tabelas do banco de dados


-- queries para recuperar o nome do cliente e o respectivo veículo cadastrado (modelo e placa)
SELECT Clientes.nome, Veiculos.modelo, Veiculos.placa
FROM Clientes
INNER JOIN Veiculos ON Clientes.id_cliente = Veiculos.id_cliente;


-- queries para recuperar o id do cliente, nome, veículo dele, data de emissão da ordem de serviço o status e o valor total de cada OS. 
SELECT os.id_os, c.nome AS cliente, v.modelo AS veículo, os.data_emissao, os.status, os.valor_geral_os
FROM ordem_servico os
JOIN veiculos v ON os.id_veiculo = v.id_veiculo
JOIN clientes c ON v.id_cliente = c.id_cliente;


-- querie para consultar o faturamento mensal em relação ao status das OS, utilizando uma função do date_format para convertar a data em mês e ano para facilitar a consulta.
SELECT 
    DATE_FORMAT(pos.data_pagamento, '%m/%Y') AS mes_referencia,
    SUM(CASE WHEN pos.status_pagamento = 'Pago' THEN pos.valor_pago ELSE 0 END) AS total_recebido,
    SUM(CASE WHEN pos.status_pagamento = 'Pendente' THEN pos.valor_pago ELSE 0 END) AS total_a_receber
FROM pagamentos_os pos
GROUP BY mes_referencia
HAVING total_a_receber > 0;

-- querie para avaliarmos o lucro real, ou seja ela soma todas as os ja concluidas e agrupa todas as peças utilizadas numa mesma os através da função group by e subtrai do número de peças que sairam do estoque e 
SELECT 
    os.id_os,  os.valor_geral_os AS faturamento_total,
    SUM(itp.quantidade * p.valor_custo) AS custo_total_pecas,
    (os.valor_geral_os - SUM(itp.quantidade * p.valor_custo)) AS lucro_bruto_os
FROM ordem_servico os
JOIN itens_os_pecas itp ON os.id_os = itp.id_os
JOIN pecas p ON itp.id_peca = p.id_peca
WHERE os.status = 'Concluída'
GROUP BY os.id_os;


-- Recuperando a listagem dos clientes que são cadastrados na oficina mas que no momento não possuem nenhum veículo com os aberta. 
-- No exemplo abaixo todos os clientes possuem um veículo que se encontra na oficina para execução de algum tipo de serviço.
-- usamos o comando left join que pega toda a listagem dos clientes e caso algum não tenha uma os aberta, a querie retorna vazia (NULL).
SELECT 
    c.nome AS Nome_Cliente,  v.modelo AS Carro, v.placa AS Placa
FROM clientes c
LEFT JOIN veiculos v ON c.id_cliente = v.id_cliente
WHERE v.id_veiculo IS NULL;


-- esta querie serve para gerenciamento do estoque, verifica quais peças estão paradas no estoque, que não estão tendo saída em uma os.
SELECT 
    p.nome_peca, 
    p.quantidade_estoque,
    p.valor_venda
FROM pecas p
LEFT JOIN itens_os_pecas itp ON p.id_peca = itp.id_peca
WHERE itp.id_item_peca IS NULL;



-- nesta querie vamos recuperar quais clientes possuem veículos fabricados após o ano de 2020.
SELECT 
    c.nome AS Cliente, v.modelo AS Carro, SUM(p_os.valor_pago) AS Total_Pago_Oficina
FROM clientes c
JOIN veiculos v ON c.id_cliente = v.id_cliente
JOIN ordem_servico os ON v.id_veiculo = os.id_veiculo
JOIN pagamentos_os p_os ON os.id_os = p_os.id_os
WHERE v.id_veiculo IN (

        SELECT id_veiculo FROM veiculos WHERE ano > 2020
)
GROUP BY c.id_cliente, v.id_veiculo
HAVING Total_Pago_Oficina > 0;


    
 

