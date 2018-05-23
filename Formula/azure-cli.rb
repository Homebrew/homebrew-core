class AzureCli < Formula
  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://azurecliprod.blob.core.windows.net/releases/azure-cli-2.0.33.tar.gz"
  sha256 "0362d119b07e40afcdef0e1a587772628abfe57558124562bd3de2497bddf26e"
  head "https://github.com/Azure/azure-cli.git"

  bottle do
    cellar :any
    sha256 "dc21584931079a846975930f4759892fa87ba9ccc7968e5f734b923def4dc342" => :high_sierra
    sha256 "d1457d9401047a4ea096662065a6642d7d5cec624dc686e536c4c620252ec456" => :sierra
    sha256 "9346e12d134def385b605c02ec49c3593a7767fe8bf8692efbbff0d49b9ab0cf" => :el_capitan
  end

  depends_on "openssl"
  depends_on "python"

  resource "adal" do
    url "https://files.pythonhosted.org/packages/94/9e/260454da9b20e53530f8bbd42acdaf8d31b8e5ab0d4ee927ae160e5361a2/adal-0.6.0.tar.gz"
    sha256 "e9cb6da6d1cdaf222d519337894ed8fc35ed702554da94819a21d0f5a8b6ce40"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/7d/ce/2950ffac9097729c5abf0c035ece4a03bb24bcfebad42bc03915c4bfb6e0/applicationinsights-0.11.3.tar.gz"
    sha256 "9093ee9f16219731453a8bd7a7db622cfb16b57edbf0ebe75aaee63ec5dde2da"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/21/9741e5e5e63245a8cdafb32ffc738bff6e7ef6253b65953e77933e56ce88/argcomplete-1.9.4.tar.gz"
    sha256 "06c8a54ffaa6bfc9006314498742ec8843601206a3b94212f82657673662ecf1"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/89/45/b79192d40f82588823ff46bd27941e419758ab6628ec3d7d06ddee1434ec/azure-batch-4.1.3.zip"
    sha256 "cd71c7ebb5beab174b6225bbf79ae18d6db0c8d63227a7e514da0a75f138364c"
  end

  resource "azure-batch-extensions" do
    url "https://files.pythonhosted.org/packages/09/b1/86c949cb304d98e10e09a0bf0730e8e81b24b47f1b1df4cad81a6d4119af/azure-batch-extensions-1.1.2.tar.gz"
    sha256 "3595c99a9725ac860e9e1bcca64a4747305b57335dd827d15e7d7c015748c9ac"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/92/7d/fdbcfe60d76c07a1f55733ceb18b71087ef7f5cae7dc4b46e36e85636f0b/azure-common-1.1.11.zip"
    sha256 "a60e37117684a168022af2c5e537448ad878d4ad8e45f147512eae2102f856af"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/72/d6/ebd004c01ae97b2df7e02aa11c6db639e95d2dd429ae93b9c0f25859145e/azure-datalake-store-0.0.19.tar.gz"
    sha256 "d79995b69828c047dcc7d1ee26bd84d2c7364f15e07948a76d02842c29a7142f"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/c1/4c/3904f9c7b4470df6a2e49c2d1c6f314a337f34dccbadcdcb892d12493c52/azure-graphrbac-0.40.0.zip"
    sha256 "f94b97bdcf774878fe2f8b8c46a5d6550a4ed891350ed0730c1561a24d488ee2"
  end

  resource "azure-keyvault" do
    url "https://files.pythonhosted.org/packages/10/92/24d4371d566f447e2b4ecebb9c360ca52e80f0a3381504974b0e37d865e7/azure-keyvault-0.3.7.zip"
    sha256 "549fafb04e1a3af1fdc94ccde05d59180d637ff6485784f716e7ddb30e6dd0ff"
  end

  resource "azure-mgmt-advisor" do
    url "https://files.pythonhosted.org/packages/f0/67/5de0f7f8f71f2adbed66f981fcd77c0db5ed8801be87dc00799f3296f686/azure-mgmt-advisor-1.0.1.zip"
    sha256 "8fdcb41f760a216e6b835eaec11dba61822777b386139d83eee31f0ff63b05da"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/3b/a1/6bacd65add8c3855d8a893b8b5525e3cb492579c720d7e7cc36472abe2ae/azure-mgmt-authorization-0.40.0.zip"
    sha256 "1d758630ed0701f1cc76060d12bc5ec0be83f586d7bfccdaf860a8f1cecf8397"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/de/27/910b77c194c1e88f7e50dbb1132ed8afd834636bb5e2daf65c33caded215/azure-mgmt-batch-4.1.0.zip"
    sha256 "2e69f407dc8a94d87316ee6a82b6f3c1d6997b84e337042c3c4ed6450adcd359"
  end

  resource "azure-mgmt-batchai" do
    url "https://files.pythonhosted.org/packages/9a/ba/d5c53e06fa9777196e2324253c9e616e2a5d07438f7f66fd2218cf68df5d/azure-mgmt-batchai-1.0.0.zip"
    sha256 "7da355af31dcacc87f60d9efd47f97a285133d103a0b697fad43cd4981453684"
  end

  resource "azure-mgmt-billing" do
    url "https://files.pythonhosted.org/packages/24/35/3b9da47363a300203c324b572a1ae3c096dc031905d582d5a27bd59a8d4e/azure-mgmt-billing-0.2.0.zip"
    sha256 "85f73bb3808a7d0d2543307e8f41e5b90a170ad6eeedd54fe7fcaac61b5b22d2"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/ac/7a/97a3de0d0d565b911f58cee57de7240be60743f2b59094e49ba9f4d79cdc/azure-mgmt-cdn-1.0.0.zip"
    sha256 "084d2c6032601aef59bf26c1f17fc0e3b5273dafb256af550d0f069c99ac58f6"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/2d/98/998cc11d25751c3fc93078040c9f725641d34d3424dd9cada2b7edf585e4/azure-mgmt-cognitiveservices-1.0.0.zip"
    sha256 "9a124d5c8827c2af3eeb1e3829e116d0ae582d27eb0e49d6a250489b7be11582"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/d4/d7/112b7f58491efeac53878cc59f7e917ca4b55b634494813fba5cf3f07c56/azure-mgmt-compute-4.0.0rc2.zip"
    sha256 "d15d546595df30a2e7f073445b2143a89a8e42910635afdac6dc00937ad15d1b"
  end

  resource "azure-mgmt-consumption" do
    url "https://files.pythonhosted.org/packages/8c/f0/e2d94b246e2dce71eff8d362836a1979f02b4185f5403a13e4fb26c07ccb/azure-mgmt-consumption-2.0.0.zip"
    sha256 "9a85a89f30f224d261749be20b4616a0eb8948586f7f0f20573b8ea32f265189"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/be/48/0868895a10d5074229e2ecc4296a609f8b57da78c7a2859f586c16293969/azure-mgmt-containerinstance-0.4.0.zip"
    sha256 "226985c19801a780384aebf88001c0736b496e9aae154c5ead5b0c6f3ce819b8"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/7a/b5/8c88a5e948d7bfb61717712a4384b297287886e17a15db1f7a52b3c3a1a8/azure-mgmt-containerregistry-2.0.0.zip"
    sha256 "340f71652111747578bc1a2f44c035f7147dc5fe1f23271f02107a7451cb92f2"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/1b/7e/0aad556bbe57fb8b57f0c2ad6a6936f209ef5aeb73029d21cb4db05a2dbb/azure-mgmt-containerservice-3.0.1.zip"
    sha256 "cabf729e503a47c76d31033928c9769ba5a6f1dbf73afa42436adb7226ce4e76"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/37/62/52fb2ed1f3ef41a82351b72c0c74a10a509c915aa751ac0249d01e63a85b/azure-mgmt-cosmosdb-0.4.0.zip"
    sha256 "4e93ac74e78b1452eb846453e6c6c1cc97f9f7f29f24f328d33d660cf84f5f0a"
  end

  resource "azure-mgmt-datalake-analytics" do
    url "https://files.pythonhosted.org/packages/a7/58/48e0ca69aa4b515992b743d37abfcb348d48d457bc878895be8e1913b740/azure-mgmt-datalake-analytics-0.2.0.zip"
    sha256 "2deb008be2583d7ed9573e6876f708f94b2971e6e25bc8f1c0f96d3f49900270"
  end

  resource "azure-mgmt-datalake-nspkg" do
    url "https://files.pythonhosted.org/packages/f7/eb/3b330ffd3a925db473175c3a28244bdf87c4736ce16a55be7a7535c6bfa5/azure-mgmt-datalake-nspkg-2.0.0.zip"
    sha256 "28b8774a1aba3e11c431f9c6cc984fde31a0ecbb89270924f392504f4260ca37"
  end

  resource "azure-mgmt-datalake-store" do
    url "https://files.pythonhosted.org/packages/b6/b2/bc411daf0e5cd1d2c62390b9e73559a53ffb8fb7f0253f35430e74eab17c/azure-mgmt-datalake-store-0.2.0.zip"
    sha256 "20ddcbe98e00834b12d40c2f0a96d5c8145e83d0c70ea1428235d2c2abb01bd4"
  end

  resource "azure-mgmt-datamigration" do
    url "https://files.pythonhosted.org/packages/69/0c/d876ab1ff8786deaf5bbf3b10c6823ae92c1d1ff576e262f4a6c681ffd39/azure-mgmt-datamigration-0.1.0.zip"
    sha256 "e754928992743f54d999800a5e0679ee3e91d804d23a25f12c2e6f2f86cd05df"
  end

  resource "azure-mgmt-devtestlabs" do
    url "https://files.pythonhosted.org/packages/66/9e/7c8e4b5a09548af7ea8a37add50a0d9e4fd0f69a97b0870c889c684677cf/azure-mgmt-devtestlabs-2.0.0.zip"
    sha256 "3c17adbea354f681a899974a20db340c5197572ccce5aa1d01d1c1c629c8a0b5"
  end

  resource "azure-mgmt-dns" do
    url "https://files.pythonhosted.org/packages/d9/6d/e4cd216c029146ba9a07a3a76c3df55f1968d5ec079673449977987604c5/azure-mgmt-dns-2.0.0rc1.zip"
    sha256 "24bd98c334ff7923a606cd6e15d0af965dde62e7f3c5601379eeb889f2259f93"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/a8/b5/a3e49faa5bd5618294d411bbd11ed1ae9eb886c65b78cdcb9bea360a53e4/azure-mgmt-eventgrid-0.4.0.zip"
    sha256 "cf22195fe453627e20d81695a14e3c7b9329790763b65243be55d66964c789ac"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/7f/07/94a08651d8afa5f9174a80b3198d1fc3e0f2baf522bcf9fc4596cbfdd1e4/azure-mgmt-eventhub-1.2.0.zip"
    sha256 "30a316ccd7a91fbf397a3df2648ae7dfa218566177f85ed65450a13698f77215"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/33/46/1283ee4c6dda32bd92018adcbdf521595a6ca80fa7e203064a2eb284d56d/azure-mgmt-iothub-0.4.0.zip"
    sha256 "65ff5bf8cc6096ab468ba444d64b501366218af15f937f0ce14173fadbc1653d"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https://files.pythonhosted.org/packages/9c/a8/1ddbe8bda18673a76ad35862651242ab2dfb0dadaf770135dad8dba50f56/azure-mgmt-iothubprovisioningservices-0.1.0.zip"
    sha256 "afc226a76477e9f881979cd5376533a0fdc276b3e9540c3620ada65ef0187bd2"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/e0/c2/6c572800601330c343f993b93432f06ff2abdc35ee40ef42f81ee3a00ec2/azure-mgmt-keyvault-0.40.0.zip"
    sha256 "fb7facbcdc9157f7fb83abb41032f257a6013a02205d7c0327b56779ca20fd30"
  end

  resource "azure-mgmt-marketplaceordering" do
    url "https://files.pythonhosted.org/packages/30/16/e381dd68bfc281f110a94733abdce0626b9c38647ea17f89adc937c61f49/azure-mgmt-marketplaceordering-0.1.0.zip"
    sha256 "6da12425cbab0cc62f246e7266b4d67aff6bdd031ecbe50c7542c2f2b2440ad4"
  end

  resource "azure-mgmt-media" do
    url "https://files.pythonhosted.org/packages/97/ac/f3fb4c8a5565a0b7b8dfd27a9d3bccea351019680a8c5dd118a9e5146eda/azure-mgmt-media-1.0.0rc1.zip"
    sha256 "389ebf1cfa3c3a0678ddc13157b567a1c0995fd508d10d9a3abfca2e87684395"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/13/68/306653b4fe734599699cd70ca65d142aaf95375643a855a0d2256638a623/azure-mgmt-monitor-0.5.0.zip"
    sha256 "81e68c908fe08632eb20745fefcf444a44344fa53001fbce6fcecee9ca45ff65"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/2b/75/d48876229987f592358b3d4475877797fda939d9d04bbbbc13edf141fa52/azure-mgmt-msi-0.1.0.zip"
    sha256 "53eed7bc8453b764b4d568320eed032328da5b606185c216f3e93c75fa328858"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/94/a9/bf8ae648f37561c3195a7c2fc8d7eecea4b22e90460465b73b45fad5eec9/azure-mgmt-network-2.0.0rc2.zip"
    sha256 "56922cd31a80bd2568aeed7839a0207d9550feb54897bbb9a2a967fed9390abd"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/fe/66/66eb0d5ead69b7371649466fa160a166de0d1ddafc4a1d7a172858a8abc9/azure-mgmt-nspkg-2.0.0.zip"
    sha256 "e36488d4f5d7d668ef5cc3e6e86f081448fd60c9bf4e051d06ff7cfc5a653e6f"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/db/a3/c96824cd33e3036fee74aee1ec9a5e6c7802a364246b16fc14a000070111/azure-mgmt-rdbms-1.1.0.zip"
    sha256 "451c35fadd7018db9a40ed9164d1efb69a139ffdadd54fd95dd12308cd259eba"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https://files.pythonhosted.org/packages/a3/e9/476dbfc13000f7eda49b18a0c109827841b5381ce15acb651b5b4dec248e/azure-mgmt-recoveryservices-0.1.0.zip"
    sha256 "bf875b8fbfe2459f4c729c363ec6721b8d33bd7fe74bcd0a8ce27f0fcdae5aef"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/9f/fb/731b07c573c660780e660d883cb1d1a6d09c1b4ebd5348383eae854a4024/azure-mgmt-recoveryservicesbackup-0.1.1.zip"
    sha256 "a09a514f5c7877406bdf777007683f036f5444f878cf595a15e541e7ba5c1c66"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/c6/e5/4e63b267b483deeca8e41eaa0b5f8ccff03a2196ad86e80f5fe7af78dec7/azure-mgmt-redis-4.1.0.zip"
    sha256 "7ef447e2fae80853672ef276af6867976e8315e8893beb7f3fb11697fb1fb4a8"
  end

  resource "azure-mgmt-reservations" do
    url "https://files.pythonhosted.org/packages/76/32/5d7c2d8e4f71679301562cef1ae4e18536d601741c5b4789a275659ed101/azure-mgmt-reservations-0.1.0.zip"
    sha256 "73645c247b9fb2cc39d4cdab85405e55df2e8eab5a478514be0825e253660b9d"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/b2/39/e9c47857ff0271f337fa88ffa7e0c9914f32583bdfd5e1af3d39c0729eb7/azure-mgmt-resource-1.2.1.zip"
    sha256 "03b353f6971fdb0615c5f19150ca3b030e9b26ba76ac39df795b9046d88f8bc1"
  end

  resource "azure-mgmt-servicebus" do
    url "https://files.pythonhosted.org/packages/bc/30/46b609e02a79c1a464e83a0e3b1c6e1184df69ca374d8c9322bff28703e1/azure-mgmt-servicebus-0.4.0.zip"
    sha256 "d678ec3220270dede73863db22506307638d51001c1fd97de07b0ca77210371a"
  end

  resource "azure-mgmt-servicefabric" do
    url "https://files.pythonhosted.org/packages/e6/79/597d3e5fe6ee4ac44a42918e83a99734d25f38f0f3ef48b854bbac0a34a3/azure-mgmt-servicefabric-0.1.0.zip"
    sha256 "9f7789bdc221fcf81608cc5a3e64f1d59d41c453ff1567cb81197b19a2cd6373"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/97/85/a5453e3fb5f5d267441d004ae2b02723b7beaa0612f683f90f3902e2620c/azure-mgmt-sql-0.9.0.zip"
    sha256 "103191ac8c14891792b57376ec2bec077e0e54679e66b9cee9f0fe87e2a0aaa7"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/bb/8c/e276e122ba7881446c500e20ae8832a7eb67c71fc01d2508a15100080601/azure-mgmt-storage-1.5.0.zip"
    sha256 "b1fc3a293051dee35dffe12d618f925581d6536c94ca5c05b69461ce941125a1"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/68/4f/c8b62406174c8355b2c1fb62720152c0bb8046dd62bb1029fcf8c8d049d2/azure-mgmt-trafficmanager-0.40.0.zip"
    sha256 "32cd1f5fd8d902cba5dd68f5876eadf5f98f5bef8b33319b20e6b547e7c21d68"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/44/d6/08ba5653702e67d401291128fc30aa6cff05fb82299832899c2ce63ca6cd/azure-mgmt-web-0.35.0.zip"
    sha256 "8ea0794eef22a257773c13269b94855ab79d36c342ad15a98135403c9785cc0a"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/45/18/bdb83bd8211dbf913dac70ce952cdf23d5dd42460284bd902ec8dd537e07/azure-multiapi-storage-0.2.0.tar.gz"
    sha256 "97c7b322471e96d869dd8006ecb0678b9bd3da2f6a234ee1fbc07b67ea3782c0"
  end

  resource "azure-nspkg" do
    url "https://files.pythonhosted.org/packages/06/a2/77820fa07ec4657d6456b67edfa78856b4789ada42d1bb8e8485df19824e/azure-nspkg-2.0.0.zip"
    sha256 "fe19ee5d8c66ee8ef62557fc7310f59cffb7230f0a94701eef79f6e3191fdc7b"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/4c/fe/1fc268311cb48db9d9cfcc82e516938785288cac41ec9f1b0a79d7a49e8e/azure-storage-blob-1.1.0.tar.gz"
    sha256 "4fdcdc20e36d0f97a58bdffe1b26fc2b8b983c59ff8625e961c188c925891c66"
  end

  resource "azure-storage-common" do
    url "https://files.pythonhosted.org/packages/ba/c4/fcce69546f9d15eba3c139aa7314370391e96218b25db161b95f803c63f1/azure-storage-common-1.1.0.tar.gz"
    sha256 "8c67a4b0ad9ef16c4da3ca050ac7ad2117818797365d7e3bb4f371bdb78040cf"
  end

  resource "azure-storage-nspkg" do
    url "https://files.pythonhosted.org/packages/bc/2c/5e3a8c535779ef6e7b2d556676e49768c17dd29066f41587080f23aea485/azure-storage-nspkg-3.0.0.tar.gz"
    sha256 "855315c038c0e695868025127e1b3057a1f984af9ccfbaeac4fbfd6c5dd3b466"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/f3/ec/bb6b384b5134fd881b91b6aa3a88ccddaad0103857760711a5ab8c799358/bcrypt-3.1.4.tar.gz"
    sha256 "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/8a/17/2f49d6b94908ff21031f2daaac498170e64983ddcc34d8d1becd2c45b03b/humanfriendly-4.12.1.tar.gz"
    sha256 "937b4d2c99d29007023ebcab23579429541bfb3357a97e5df38fc5d851a112a3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/18/17/7dbc70bc13dc9c8ba8c9b25fbc8b75dffb6bc7e56c3d7cecd87e6b563e5f/jeepney-0.3.1.tar.gz"
    sha256 "a6f2aa72e61660248d4d524dfccb6405f17c693b69af5d60dd7f2bab807d907e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/d8/07/e862b57168e088f3ba880fba2471f05f78c19e75b1632be0143d116e7fa3/keyring-12.2.1.tar.gz"
    sha256 "4498eaa2e32fc69a8b36749116b670c379d36a1a9ad4ab107df1e19c8a120ffe"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/87/9d/1ac7e61b373e94ae96c28fc8e80976c24ce2f5d11c5d22330eed0a874dc9/knack-0.3.3.tar.gz"
    sha256 "dd2d3c4756975d6bdbbc65a25c067245350eec81547dac93a5c96a80a9f949f0"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/9b/49/ed5c9ea20f83707f4f67fbc664082d6d9a356b44f5f64ec5a5c7e0fdb365/msrest-0.4.29.tar.gz"
    sha256 "ce0a558173b7c7bff87dc66e24331382c81a89367ea52c52bbb934de6064cb45"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/63/96/c1d9225f8cdcb024a00d9ebeebb2422dd8150032d3c402449f1d1618ce4a/msrestazure-0.4.31.tar.gz"
    sha256 "699f83cd19a098e41b723dbd9c4765ea0886ea15508f63e2709623883e4f754d"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/df/5f/3f4aae7b28db87ddef18afed3b71921e531ca288dc604eb981e9ec9f8853/oauthlib-2.1.0.tar.gz"
    sha256 "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/29/65/83181630befb17cd1370a6abb9a87957947a43c2332216e5975353f61d64/paramiko-2.4.1.tar.gz"
    sha256 "33e36775a6c71790ba7692a73f948b329cf9295a72b0102144b031114bd2a4f3"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/a7/d7/eeb3cc66469e21843748e9b8f196eefd42fc81ea43191715e8ec54fee4df/pbr-4.0.3.tar.gz"
    sha256 "6874feb22334a1e9a515193cba797664e940b763440c88115009ec323a7f2df5"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"
    sha256 "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/eb/3d/b7d0fdf4a882e26674c68c20f40682491377c4db1439870f5b6f862f76ed/pyasn1-0.4.2.tar.gz"
    sha256 "d258b0a71994f7770599835249cece1caef3c70def868c4915e6e5ca49b67d15"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pydocumentdb" do
    url "https://files.pythonhosted.org/packages/10/96/3ab2ccc35f97262bcba6d6c93789515094262da7494c09f4d78faeaaf849/pydocumentdb-2.3.2.tar.gz"
    sha256 "6704e16b7eb69b5fa8da7636d1926d9952aa43acf2fabdb1ed0a128987139eee"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/3b/fc/2a479754113cee6824129f2f39dba555c939114ef5410bfa4cfdbbed6e8e/PyJWT-1.6.3.tar.gz"
    sha256 "c365c2c92063bdc609a9ef328958a910e249ffcad953895914b87e645412cf81"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f/PyNaCl-1.2.1.tar.gz"
    sha256 "e0d38fa0a75f65f556fb912f2c6790d1fa29b7dd27a1d9cc5591b281321eaaa9"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/9b/7c/ee600b2a9304d260d96044ab5c5e57aa489755b92bbeb4c0803f9504f480/pyOpenSSL-18.0.0.tar.gz"
    sha256 "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/36/bf/2dd8050c17166f731fc081e091aacd3044723cbc6f0fccabd6742d8dbb42/scp-0.11.0.tar.gz"
    sha256 "ea095dd1d0e131874bc9930c3965bce3d1d70be5adb2a30d811fcaea4708a9ee"
  end

  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/65/02/1f0d2a7b1221bc9a15f8b8d4de2c8ad8272c4d0af76cbdc72e2cf51d42e0/SecretStorage-3.0.1.tar.gz"
    sha256 "819087ca89c0d6c5711692f41fb26f786af9dcc5bb89d567722a66edfbb2a689"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "sshtunnel" do
    url "https://files.pythonhosted.org/packages/9b/24/0eccfd7f0321184ef9d535d465ed02ba66e657089f97f307e7376bb97b6b/sshtunnel-0.1.3.tar.gz"
    sha256 "9673b26d91e8a5569e2513fc657c26b2574ccf222d1026612ba630438bceebb0"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/12/c2/11d6845db5edf1295bc08b2f488cf5937806586afe42936c3f34c097ebdc/tabulate-0.8.2.tar.gz"
    sha256 "e4ca13f26d0a6be2a2915428dc21e732f1e44dad7f76d7030b2ef1ec251cf7f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "vsts-cd-manager" do
    url "https://files.pythonhosted.org/packages/64/c8/c7311dde3d89d2f5e37f40f707447ef378c00a2dd359ce1bd119a152286f/vsts-cd-manager-1.0.1.tar.gz"
    sha256 "a7e05a476a441d18122a3b66d4d6d6d3142f18dea75065edffc0b258cb2b0c9d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/c9/bb/8d3dd9063cfe0cd5d03fe6a1f74ddd948f384e9c1eff0eb978f3976a7d27/websocket_client-0.47.0.tar.gz"
    sha256 "a453dc4dfa6e0db3d8fd7738a308a88effe6240c59f3226eb93e8f020c216149"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fa/b4/f9886517624a4dcb81a1d766f68034344b7565db69f13d52697222daeb72/wheel-0.30.0.tar.gz"
    sha256 "9515fe0a94e823fd90b08d22de45d7bde57c90edce705b22f5e1ecf7e1b653c8"
  end

  resource "Whoosh" do
    url "https://files.pythonhosted.org/packages/25/2b/6beed2107b148edc1321da0d489afc4617b9ed317ef7b72d4993cad9b684/Whoosh-2.7.4.tar.gz"
    sha256 "7ca5633dbfa9e0e0fa400d3151a8a0c4bec53bd2ecedc0a67705b17565c31a83"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/57/17/a6acddc5f5993ea6eaf792b2e6c3be55e3e11f3b85206c818572585f61e1/xmltodict-0.11.0.tar.gz"
    sha256 "8f8d7d40aa28d83f4109a7e8aa86e67a4df202d9538be40c0cb1d70da527b0df"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    site_packages = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"
    ENV.prepend "CFLAGS", "-I#{Formula["openssl"].opt_include}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include}"

    # Get the CLI components we'll install
    components = [
      buildpath/"src/azure-cli",
      buildpath/"src/azure-cli-core",
      buildpath/"src/azure-cli-nspkg",
      buildpath/"src/azure-cli-command_modules-nspkg",
    ]
    components += Pathname.glob(buildpath/"src/command_modules/azure-cli-*/")

    # Install dependencies
    # note: Even if in 'resources', don't include 'futures' as not needed for Python3
    # and causes import errors. See https://github.com/agronholm/pythonfutures/issues/41
    deps = resources.map(&:name).to_set - ["futures"]
    deps.each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    # Install CLI
    components.each do |item|
      cd item do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    # This replaces the `import pkg_resources` namespace imports from upstream
    # with empty string as the import is slow and not needed in this environment.
    File.open(site_packages/"azure/__init__.py", "w") {}
    File.open(site_packages/"azure/cli/__init__.py", "w") {}
    File.open(site_packages/"azure/cli/command_modules/__init__.py", "w") {}
    File.open(site_packages/"azure/mgmt/__init__.py", "w") {}

    (bin/"az").write <<~EOS
      #!/usr/bin/env bash
      export PYTHONPATH="#{ENV["PYTHONPATH"]}"
      if command -v python#{xy} >/dev/null 2>&1; then
        python#{xy} -m azure.cli \"$@\"
      else
        python3 -m azure.cli \"$@\"
      fi
    EOS

    bash_completion.install "az.completion" => "az"
  end

  test do
    json_text = shell_output("#{bin}/az cloud show --name AzureCloud")
    azure_cloud = JSON.parse(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["endpoints"]["management"], "https://management.core.windows.net/"
    assert_equal azure_cloud["endpoints"]["resourceManager"], "https://management.azure.com/"
  end
end
