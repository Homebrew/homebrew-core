class AzureCli < Formula
  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://codeload.github.com/Azure/azure-cli/legacy.tar.gz/bd417ea165f8f1f528a10fbc6d33c81fd7fa5f17"
  version "2.0.56"
  sha256 "76a062201017371d31795264b99f281f20153fe87d98e8f8a887f019584b1f04"
  head "https://github.com/Azure/azure-cli.git"

  bottle do
    cellar :any
    sha256 "3c10f757b0339ed8276566c753660b0a1cd41e6d6897464e7302d48b3251b17c" => :mojave
    sha256 "545d55c737d750655d658efc5ad760df95b909e6f7695cad0bbd69f08c29c4ad" => :high_sierra
    sha256 "08bf3409b506d01b42dac9e3ae9e11d56527de8a54946d39b6983f567929e626" => :sierra
  end

  depends_on "openssl"
  depends_on "python"

  resource "adal" do
    url "https://files.pythonhosted.org/packages/82/43/a1e4b7368eec9653660ee91f023af36056028cea97e3550f85866a0c3f2f/adal-1.2.1.tar.gz"
    sha256 "b6edd095be66561382bdaa59d40b04490e93149fb3b7fa44c1fa5504eed5b8b9"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/29/14/8ac135ec7cc9db3f768e2d032776718c6b23f74e63543f0974b4873500b2/antlr4-python3-runtime-4.7.2.tar.gz"
    sha256 "168cdcec8fb9152e84a87ca6fd261b3d54c8f6358f42ab3b813b14a7193bb50b"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/f0/93/f60d7519c28b9e05b075ce89027df27849c7a50fe0371d4da2c38389570a/applicationinsights-0.11.7.tar.gz"
    sha256 "c4712ede8eeca57e611b7fd4b3b6c345745a4a002a08145ab45f92d31d900040"
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
    url "https://files.pythonhosted.org/packages/68/eb/e9e0bd808cc77f651053adf6d54c36a54a39558faae5290b2ccafbe811e1/azure-batch-5.1.0.zip"
    sha256 "21687ea71a14decc57499795075ff70090f67d46f3b1e31cd3415a138ee955e8"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/0d/4b/a65b1a766b1687158d12df65392fe99730f4c46a038c438cd845c51d0bd3/azure-common-1.1.17.zip"
    sha256 "e7cd5a8ee2ec0639454c1bd0f1ea5f609d83977376abfd304527ec7343fef1be"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/7b/43/6ebe1b59732ec50255a32ac1da6c8f254767e079836b8c273aceb5ed7a6f/azure-datalake-store-0.0.39.tar.gz"
    sha256 "fd1ca3384808ac806470c26c98bc2346c1784d5b281fac4ea468ba018269ee3a"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/4a/78/cf441cf25279f2005a9b88fcdbb56f42b6362d2916e74970883165122a49/azure-graphrbac-0.53.0.zip"
    sha256 "970c11f2cfa42c3e52d9768a92295cb0812dfbaa35401a2c5d1f5cbf6a42ae6f"
  end

  resource "azure-keyvault" do
    url "https://files.pythonhosted.org/packages/8e/47/b71d7ab466189d0663a8aa216e4cc67eb16d5dfc7d69b62a9140dd8d1a20/azure-keyvault-1.1.0.zip"
    sha256 "37a8e5f376eb5a304fcd066d414b5d93b987e68f9212b0c41efa37d429aadd49"
  end

  resource "azure-mgmt-advisor" do
    url "https://files.pythonhosted.org/packages/f2/fb/bca29d83a2062c7d977742189195d669fd5983017fddb464c90f07adaac0/azure-mgmt-advisor-2.0.1.zip"
    sha256 "1929d6d5ba49d055fdc806e981b93cf75ea42ba35f78222aaf42d8dcf29d4ef3"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https://files.pythonhosted.org/packages/83/ad/27c3e2c618c08ea451a80d6a0dc5b73b8c8c2392706909f297c37389766f/azure-mgmt-applicationinsights-0.1.1.zip"
    sha256 "f10229eb9e3e9d0ad20188b8d14d67055e86f3815b43b75eedf96b654bee2a9b"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/3e/8f/ccb1117884ffd81862ed03359c90aace89e9d2faa8bb50e35e7fb85154c3/azure-mgmt-authorization-0.50.0.zip"
    sha256 "535de12ff4f628b62b939ae17cc6186226d7783bf02f242cdd3512ee03a6a40e"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/8b/c3/ffd878e309a2e3905f9f4aa453344abad1e41caca33d495501c05074458c/azure-mgmt-batch-5.0.1.zip"
    sha256 "6e375ecdd5966ee9ee45b29c90a806388c27ceacc2cbd6dd406ff311b5d7da72"
  end

  resource "azure-mgmt-batchai" do
    url "https://files.pythonhosted.org/packages/fa/7f/0a9e5aa22ea91db0771c267c4815396516177702a4a4eea389eed7af47dd/azure-mgmt-batchai-2.0.0.zip"
    sha256 "f1870b0f97d5001cdb66208e5a236c9717a0ed18b34dbfdb238a828f3ca2a683"
  end

  resource "azure-mgmt-billing" do
    url "https://files.pythonhosted.org/packages/24/35/3b9da47363a300203c324b572a1ae3c096dc031905d582d5a27bd59a8d4e/azure-mgmt-billing-0.2.0.zip"
    sha256 "85f73bb3808a7d0d2543307e8f41e5b90a170ad6eeedd54fe7fcaac61b5b22d2"
  end

  resource "azure-mgmt-botservice" do
    url "https://files.pythonhosted.org/packages/1d/e5/8c46af4aa8f5ba7d726e1ac2cecb40f0d2c37ef62830e50a818671ed2f1a/azure-mgmt-botservice-0.1.0.zip"
    sha256 "592ea3828858841d470109b7eebd68627ead16a9cde1db8114ecaf3b76b56084"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/3f/2a/2c5450add0e93067270b24a39444c1bfb1a18ee705c5735cf38f5900f270/azure-mgmt-cdn-3.0.0.zip"
    sha256 "069774eb4b59b76ff9bd01708be0c8f9254ed40237b48368c3bb173f298755dd"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/e0/34/def32a5bc74b565bc55ccfc9fd3a5ee3a8ccd36e6a98d6578167d7bbc65d/azure-mgmt-cognitiveservices-3.0.0.zip"
    sha256 "c3247f2786b996a5f328ebdaf65d31507571979e004de7a5ed0ff280f95d80b4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/7d/93/4ee56c226f5fc8d63b2e85ec771d92d23d8c509c4560fe6aa0125e1235d8/azure-mgmt-compute-4.4.0.zip"
    sha256 "356219a354140ea26e6b4f4be4f855f1ffaf63af60de24cd2ca335b4ece9db00"
  end

  resource "azure-mgmt-consumption" do
    url "https://files.pythonhosted.org/packages/8c/f0/e2d94b246e2dce71eff8d362836a1979f02b4185f5403a13e4fb26c07ccb/azure-mgmt-consumption-2.0.0.zip"
    sha256 "9a85a89f30f224d261749be20b4616a0eb8948586f7f0f20573b8ea32f265189"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/71/73/2f3124f8a8c8390fd7e6eda3da5c9799888054fddfceacaafb73c8db5d49/azure-mgmt-containerinstance-1.4.0.zip"
    sha256 "274a9def808407fafe123aa8e9bc1c838a48af2de56419598db7a8b8901086e3"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/0b/27/e9241a82417de90f25fd35c188576cd1fe2206c0e7f2d1a5cb463de64ead/azure-mgmt-containerregistry-2.6.0.zip"
    sha256 "4d31588ca5c5258b4a595e3de400994c7f6fff3b84faccf9b8a0ff6b583eba63"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/a5/ff/6a6f62aa8b1863df488df7ef7d809fe7caf3f6ae07763d159f747b99f999/azure-mgmt-containerservice-4.4.0.zip"
    sha256 "150fa5437726a97428ab107e4de155c950f8065834f43aa2dff5924d20d4b42c"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/58/0d/10329926e63c68fbf8f2040e2bf1b2a8ec3546b2b1cf34d3162f20519c48/azure-mgmt-cosmosdb-0.5.2.zip"
    sha256 "1a7fefbd45262a7384a013fa4c29ea030365b08ead5e08a7148d2a32276cb2c3"
  end

  resource "azure-mgmt-datalake-analytics" do
    url "https://files.pythonhosted.org/packages/a7/58/48e0ca69aa4b515992b743d37abfcb348d48d457bc878895be8e1913b740/azure-mgmt-datalake-analytics-0.2.0.zip"
    sha256 "2deb008be2583d7ed9573e6876f708f94b2971e6e25bc8f1c0f96d3f49900270"
  end

  resource "azure-mgmt-datalake-nspkg" do
    url "https://files.pythonhosted.org/packages/8e/0c/7b705f7c4a41bfeb0b6f3557f227c71aa3fa71555ed76ae934aa7db4b13e/azure-mgmt-datalake-nspkg-3.0.1.zip"
    sha256 "deb192ba422f8b3ec272ce4e88736796f216f28ea5b03f28331d784b7a3f4880"
  end

  resource "azure-mgmt-datalake-store" do
    url "https://files.pythonhosted.org/packages/00/13/037f0128bdfcd47253f69a3b4ca6a7ff7b673b35832bc48f7c74df24a9be/azure-mgmt-datalake-store-0.5.0.zip"
    sha256 "9376d35495661d19f8acc5604f67b0bc59493b1835bbc480f9a1952f90017a4c"
  end

  resource "azure-mgmt-datamigration" do
    url "https://files.pythonhosted.org/packages/69/0c/d876ab1ff8786deaf5bbf3b10c6823ae92c1d1ff576e262f4a6c681ffd39/azure-mgmt-datamigration-0.1.0.zip"
    sha256 "e754928992743f54d999800a5e0679ee3e91d804d23a25f12c2e6f2f86cd05df"
  end

  resource "azure-mgmt-devtestlabs" do
    url "https://files.pythonhosted.org/packages/1d/67/b3fad6c04240edf278d2afa71129b8a86f43803ee681c518beac5729e58b/azure-mgmt-devtestlabs-2.2.0.zip"
    sha256 "d416a6d0883b0d33a63c524db6455ee90a01a72a9d8757653e446bf4d3f69796"
  end

  resource "azure-mgmt-dns" do
    url "https://files.pythonhosted.org/packages/a2/0d/a36c123a1c978d39a1da747b9e8179f37441176d2a5276124d6d3312b2c4/azure-mgmt-dns-2.1.0.zip"
    sha256 "3730b1b3f545a5aa43c0fff07418b362a789eb7d81286e2bed90ffef88bfa5d0"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/9d/f0/2bd32def97d73f9fbf5b7d0cd81bac686dfca7524f06fc2b5070ec761706/azure-mgmt-eventgrid-2.0.0.zip"
    sha256 "9a1da1085d39163b13dee14215b02f18eab93ede10ffe83dc6030ecf2163d2f1"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/bb/ad/a6f807a52d6c52e1e44e6f8ca877860970b6593bbfd3286802c322453e65/azure-mgmt-eventhub-2.2.0.zip"
    sha256 "b5407e529b9daeefbb9393c8f7401f44a21ecfeede6e03cf08456149c1d3533e"
  end

  resource "azure-mgmt-hdinsight" do
    url "https://files.pythonhosted.org/packages/54/9f/35dea82b7b42dfe8c6b051dcab84652419c03ebb7830ec887a660ff6f14a/azure-mgmt-hdinsight-0.2.0.zip"
    sha256 "0004260de83d9a31e8bfce627dfc942186dea3e604ba387727130930f84a3fb5"
  end

  resource "azure-mgmt-iotcentral" do
    url "https://files.pythonhosted.org/packages/cb/8b/878d6d5658cc224861f56d220834aeca794cc60c59e77bad643aa88c8ab7/azure-mgmt-iotcentral-1.0.0.zip"
    sha256 "9aac88ed1f993965015f4e9986931fc08798e09d7b864928681a7cebff053de8"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/80/ce/0b68e937f83e2c49a3c83a74a321e34df05124982c937df05e84891ee3d7/azure-mgmt-iothub-0.7.0.zip"
    sha256 "a0055fa6ec7a8d6dc9458605878d04d229f57f248096e54bc82dbe4c16d17634"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https://files.pythonhosted.org/packages/7a/9e/179a404d2b3d999cf2dbdbec51c849e92625706e8eff6bd6d02df3ad2ab7/azure-mgmt-iothubprovisioningservices-0.2.0.zip"
    sha256 "8c37acfd1c33aba845f2e0302ef7266cad31cba503cc990a48684659acb7b91d"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/ee/51/49aa83bc983020d69807ce5458d70009bff211e9f6e4f6bb081755e82af8/azure-mgmt-keyvault-1.1.0.zip"
    sha256 "05a15327a922441d2ba32add50a35c7f1b9225727cbdd3eeb98bc656e4684099"
  end

  resource "azure-mgmt-loganalytics" do
    url "https://files.pythonhosted.org/packages/93/e2/6b47cc232357b05d0c8c788d6bbece67428ea997ba29d50e5cd90c1bd104/azure-mgmt-loganalytics-0.2.0.zip"
    sha256 "c7315ff0ee4d618fb38dca68548ef4023a7a20ce00efe27eb2105a5426237d86"
  end

  resource "azure-mgmt-managementgroups" do
    url "https://files.pythonhosted.org/packages/3e/fd/0601266fd246b84a8f6882822b6cbccee18b85d5405dab1b85db82ba2606/azure-mgmt-managementgroups-0.1.0.zip"
    sha256 "ff62d982edda634a36160cb1d15a367a9572a5acb419e5e7ad371e8c83bd47c7"
  end

  resource "azure-mgmt-maps" do
    url "https://files.pythonhosted.org/packages/58/99/735fc6f274d2f2a493071b4bc3e6ec2bc3d0d6caf1425eb903647785532c/azure-mgmt-maps-0.1.0.zip"
    sha256 "c120e210bb61768da29de24d28b82f8d42ae24e52396eb6569b499709e22f006"
  end

  resource "azure-mgmt-marketplaceordering" do
    url "https://files.pythonhosted.org/packages/30/16/e381dd68bfc281f110a94733abdce0626b9c38647ea17f89adc937c61f49/azure-mgmt-marketplaceordering-0.1.0.zip"
    sha256 "6da12425cbab0cc62f246e7266b4d67aff6bdd031ecbe50c7542c2f2b2440ad4"
  end

  resource "azure-mgmt-media" do
    url "https://files.pythonhosted.org/packages/0c/a9/93951a36f2347f00f3323986aeb48588f55c179f7e710434a10ae9a635d0/azure-mgmt-media-1.0.1.zip"
    sha256 "e582851032a98613e16c36cabba8903e755f7622bd24bdf114b32064799f3059"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/c6/e7/7a05e95d742605c08b38864693e82d0424bb66dd5870b5e2edfc0f71fd0c/azure-mgmt-monitor-0.5.2.zip"
    sha256 "f1a58d483e3292ba4f7bbf3104573130c9265d6c9262e26b60cbfa950b5601e4"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/da/6f/60f92469f93e2820949f967b8c722fe0c04f03e4cc9a6332ffaf5e9f405b/azure-mgmt-msi-0.2.0.zip"
    sha256 "8622bc9a164169a0113728ebe7fd43a88189708ce6e10d4507247d6907987167"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/9f/af/3ef12f79fd0552d078751145b75b26c6eea6bd744278ce49be40c1547f45/azure-mgmt-network-2.4.0.zip"
    sha256 "37c11c131ec55bf13216d62b058786491c8dd5700ffe19fec68b4557b87408a6"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/c4/d4/a9a140ee15abd8b0a542c0d31b7212acf173582c10323b09380c79a1178b/azure-mgmt-nspkg-3.0.2.zip"
    sha256 "8b2287f671529505b296005e6de9150b074344c2c7d1c805b3f053d081d58c52"
  end

  resource "azure-mgmt-policyinsights" do
    url "https://files.pythonhosted.org/packages/72/f8/ead482ae756cc04b61f96ffa29d4a6dca736dddc5407697cdc98cde17015/azure-mgmt-policyinsights-0.1.0.zip"
    sha256 "ff94cb12d6e01bf1470c2a6af4ce6960669ab4209106153879ff97addc569ce1"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/4b/7c/eec30fec9740dcdaa6650141b968ce914b13dc73a17805d290eb361c978a/azure-mgmt-rdbms-1.5.0.zip"
    sha256 "3b6a194e6b82aa9fa187d1060ff3f19ad7218317b9ae30d9b64c3113ac8dfd7c"
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
    url "https://files.pythonhosted.org/packages/be/18/3f350eb5ddba594b1775b5f3a0cc60f53357feaf3986b7cd2da5400d2802/azure-mgmt-redis-5.0.0.zip"
    sha256 "374a267b83ec4e71077b8afad537863fb93816c96407595cdd02973235356ded"
  end

  resource "azure-mgmt-relay" do
    url "https://files.pythonhosted.org/packages/df/76/f4673094df467c1198dfd944f8a800a25d0ed7f4bbd7c73e9e2605874576/azure-mgmt-relay-0.1.0.zip"
    sha256 "d9f987cf2998b8a354f331b2a71082c049193f1e1cd345812e14b9b821365acb"
  end

  resource "azure-mgmt-reservations" do
    url "https://files.pythonhosted.org/packages/44/56/5ef2dec169039dbc390ae4f6d91e930d5a790a289d2ae0832235889a2fed/azure-mgmt-reservations-0.3.1.zip"
    sha256 "b25dac18466204643d9450b1cb0163161254c0f7ea76136af9c6589e89c8de49"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/05/10/063973e5b4eb4c1ff65ac89c1ec04796c213c9957b38d59814b93201969d/azure-mgmt-resource-2.1.0.zip"
    sha256 "aef8573066026db04ed3e7c5e727904e42f6462b6421c2e8a3646e4c4f8128be"
  end

  resource "azure-mgmt-search" do
    url "https://files.pythonhosted.org/packages/d3/ac/45dc77a33fa08f09f27a28a42321780d41830f22b554951836bca8665a5e/azure-mgmt-search-2.0.0.zip"
    sha256 "0ec5de861bd786bcb8691322feed6e6caa8d2f0806a50dc0ca5d640591926893"
  end

  resource "azure-mgmt-servicebus" do
    url "https://files.pythonhosted.org/packages/a2/ec/029e1d4e6aea0eb1aac53a80083de9bf96ba724c46af36ee39e834f84fee/azure-mgmt-servicebus-0.5.3.zip"
    sha256 "7d1e8c3dc05ffdfe496ae643290ce4de93a3bf814ffda69121223e3d7da12408"
  end

  resource "azure-mgmt-servicefabric" do
    url "https://files.pythonhosted.org/packages/13/cd/996d5887c207c175eb1be0936b994db3382d0e2998e58baaf5255e53ddc2/azure-mgmt-servicefabric-0.2.0.zip"
    sha256 "b2bf2279b8ff8450c35e78e226231655021482fdbda27db09975ebfc983398ad"
  end

  resource "azure-mgmt-signalr" do
    url "https://files.pythonhosted.org/packages/b7/ee/cb621d6d744d15bda56b4026cee078bfc14c47aa5b770b68f46b89b74e98/azure-mgmt-signalr-0.1.1.zip"
    sha256 "8a6266a59a5c69102e274806ccad3ac74b06fd2c226e16426bbe248fc2174903"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/ec/a0/4ecdb08ba6646d79766d86e87d22571a8045f490d417635dc1505b6633c7/azure-mgmt-sql-0.11.0.zip"
    sha256 "a6b6d49fdbd440a1685dcd98bb92f98b6ecd450603733f8a3873ab2dc6c81607"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/2d/6f/8674980b305dcdc25e1513a820efc6ae1ff7ceec68e3b60647a6fa317213/azure-mgmt-storage-3.1.1.zip"
    sha256 "22a779cae5e09712b7d62ef9bc3d8907a5666893a8a113b6d9348e933170236f"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/14/98/6fb3bc67bb862b7bac2ea43108aa1648f72c8fa63de22ab1e58278224c43/azure-mgmt-trafficmanager-0.51.0.zip"
    sha256 "fc8ae77022cfe52fda4379a2f31e0b857574d536e41291a7b569b5c0f4104186"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/60/42/0880efbfe860fd6756c4e2d42ad40ac921c4a7a94230dec1648967e8e839/azure-mgmt-web-0.40.0.zip"
    sha256 "13b3bd17591000586894d0904531ada65a40eab87d25fc181d1dfeca8da9f4b1"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/b6/fd/be45075a77d26e32a2687c301e566989fbe3c8c0da27f5b87b4b073726cb/azure-multiapi-storage-0.2.2.tar.gz"
    sha256 "2f46a08fa73f857ed37d7f2d43ce50d382ab69dd4e502662ea7be30166f7a1e8"
  end

  resource "azure-nspkg" do
    url "https://files.pythonhosted.org/packages/39/31/b24f494eca22e0389ac2e81b1b734453f187b69c95f039aa202f6f798b84/azure-nspkg-3.0.2.zip"
    sha256 "e7d3cea6af63e667d87ba1ca4f8cd7cb4dfca678e4c55fc1cedb320760e39dd0"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/41/0d/a9d63c97b59c9853a9a491809c3c2d06e766bbfb72366549939ee9b7e554/azure-storage-blob-1.3.1.tar.gz"
    sha256 "8cab5420ba6646ead09fdb497646f735b12645cba8efed96a86f7b370e175ade"
  end

  resource "azure-storage-common" do
    url "https://files.pythonhosted.org/packages/6b/d5/b0bac239f0b6396ce6f56a04ed5e3a8e4a0fe59669459f4cf4fe9df4f259/azure-storage-common-1.4.0.tar.gz"
    sha256 "7ab607f9b8fd27b817482194b1e7d43484c65dcf2605aae21ad8706c6891934d"
  end

  resource "azure-storage-nspkg" do
    url "https://files.pythonhosted.org/packages/ce/70/86db196352768b4da1bbc101de967f8eb98fdfca9fd8f46b9eca148fdded/azure-storage-nspkg-3.1.0.tar.gz"
    sha256 "6f3bbe8652d5f542767d8433e7f96b8df7f518774055ac7c92ed7ca85f653811"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/ce/3a/3d540b9f5ee8d92ce757eebacf167b9deedb8e30aedec69a2a072b2399bb/bcrypt-3.1.6.tar.gz"
    sha256 "44636759d222baa62806bbceb20e96f75a015a6381690d1bc2eda91c01ec02ea"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
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
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f3/39/d3904df7c56f8654691c4ae1bdb270c1c9220d6da79bd3b1fbad91afd0e1/cryptography-2.4.2.tar.gz"
    sha256 "05a6052c6a9f17ff78ba78f8e6eb1d777d25db3b763343a1ae89a7a8670386dd"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "Fabric" do
    url "https://files.pythonhosted.org/packages/cf/3c/19f930f9e74c417e2c617055ceb2be6aee439ac68e07b7d3b3119a417191/fabric-2.4.0.tar.gz"
    sha256 "93684ceaac92e0b78faae551297e29c48370cede12ff0f853cdebf67d4b87068"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/fc/62/327ccaf2bbc726b8612708c3324d8bb8a157418cfba1cf710fc3adf714cf/humanfriendly-4.17.tar.gz"
    sha256 "1d3a1c157602801c62dfdb321760229df2e0d4f14412a0f41b13ad3f930a936a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/ef/80/cef14194e2dd62582cc0a4f5f2db78fb00de3ba5d1bc0e50897b398ea984/invoke-1.2.0.tar.gz"
    sha256 "dc492f8f17a0746e92081aec3f86ae0b4750bf41607ea2ad87e5a7b5705121b7"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"
    sha256 "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/16/1d/74adf3b164a8d19a60d0fcf706a751ffa2a1eaa8e5bbb1b6705c92a05263/jeepney-0.4.tar.gz"
    sha256 "6089412a5de162c04747f0220f6b2223b8ba660acd041e52a76426ca550e3c70"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/b2/aa/71f2e7990a33a23dfcb3a96b87a9b3029664553f3dae4ec08a6f536183ea/keyring-17.1.1.tar.gz"
    sha256 "8f683fa6c8886da58b28c7d8e3819b1a4bf193741888e33a6e00944b673a22cf"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/03/a0/80b482d0c9374e30f01d15dcf3343c5d0bf43b6ed63d8bafe959bc84137c/knack-0.5.1.tar.gz"
    sha256 "2c3a7604260cd58e094ddb506c2d5d85cd378bce03692b1fdc1d13143271c898"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/71/4f/408da7e619c348782762d88f96d664086a97f6f2f70804367f3ca5e7d589/msrest-0.6.4.tar.gz"
    sha256 "5dadd54bec98d52cd9f43fb095015c346135b8cafaa35f24c7309cc25d3ad266"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/cd/ce/1381822930cb2e90e889e43831428982577acb9caec5244bcce1c9c542f9/msrestazure-0.4.34.tar.gz"
    sha256 "4fc94a03ecd5b094ab904d929cc5be7a6a80262eab93948260cfe9081a9e6de4"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/ec/90/882f43232719f2ebfbdbe8b7c57fc9642a25b3df30cb70a3701ea22622de/oauthlib-3.0.1.tar.gz"
    sha256 "0ce32c5d989a1827e3f1148f98b9085ed2370fc939bf524c9c851d8714797298"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/a4/57/86681372e7a8d642718cadeef38ead1c24c4a1af21ae852642bf974e37c7/paramiko-2.4.2.tar.gz"
    sha256 "a8975a7df3560c9f1e2b43dc54ebd40fd00a7017392ca5445ce7df409f900fcb"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/33/07/6e68a96ff240a0e7bb1f6e21093532386a98a82d56512e1e3da6d125f7aa/pbr-5.1.1.tar.gz"
    sha256 "f59d71442f9ece3dffc17bc36575768e1ee9967756e6b6535f0ee1f0054c3d68"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/01/e1/badb92f4bbd7c8c892d943a0136dcacf123cfbc835535368c74b707bc8dd/portalocker-1.2.1.tar.gz"
    sha256 "3f2a56d3d90e2ac5659ee744336e6953c0050bb61fccb97090a03de5c2a4db9f"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"
    sha256 "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz"
    sha256 "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pydocumentdb" do
    url "https://files.pythonhosted.org/packages/cf/53/310ef5bd836e54f8a8c3d4da8c9a8c9b21c6bb362665e018eb27c41a1518/pydocumentdb-2.3.3.tar.gz"
    sha256 "77c8da2b50920442da42f13b2cb9ff0a4062a982b26d9381ba30b12bcc1b97b9"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/64/69/413708eaf3a64a6abb8972644e0f20891a55e621c6759e2c3f3891e05d63/Pygments-2.3.1.tar.gz"
    sha256 "5ffada19f6203563680669ee7f53b64dabbeb100eb51b61996085e99c03b284a"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/2f/38/ff37a24c0243c5f45f5798bd120c0f873eeed073994133c084e1cf13b95c/PyJWT-1.7.1.tar.gz"
    sha256 "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
    sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc/pyOpenSSL-19.0.0.tar.gz"
    sha256 "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"
    sha256 "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/af/be/6c59e30e208a5f28da85751b93ec7b97e4612268bb054d0dff396e758a90/pytz-2018.9.tar.gz"
    sha256 "d5f05e487007e29e03409f9398d074e158d920d36eb82eaf66fb1136b0c5374c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a8/c6/a8d1555e795dbd0375c3c93b576ca13bbf139db51ea604afa19a2c35fc03/PyYAML-4.2b4.tar.gz"
    sha256 "3c17fb92c8ba2f525e4b5f7941d850e7a48c3a59b32d331e2502a3cdc6648e76"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/de/a2/f55312dfe2f7a344d0d4044fdfae12ac8a24169dc668bd55f72b27090c32/requests-oauthlib-1.2.0.tar.gz"
    sha256 "bd6533330e8748e94bf0b214775fed487d309b8b8fe823dc45641ebcd9a32f57"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/a6/7d/735579c8cd4f903cd3002be68581dfe8d48c7498b4e6e7a874065d2af1a5/scp-0.13.0.tar.gz"
    sha256 "cfcc275c249ae59480f88fa55c4bd7795ce8b48d3a9b8fd635d82958084b4124"
  end

  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/a6/89/df343dbc2957a317127e7ff2983230dc5336273be34f2e1911519d85aeb5/SecretStorage-3.1.1.tar.gz"
    sha256 "20c797ae48a4419f66f8d28fc221623f11fc45b6828f96bdb1ad9990acb59f92"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "sshtunnel" do
    url "https://files.pythonhosted.org/packages/bf/8d/385c7e7c90e17934b3102ad2902e224c27a7173a6a57ef4805dcef8043b1/sshtunnel-0.1.4.tar.gz"
    sha256 "f29ae41a1bd3afa64e9a31029bece2966e4be9a9641e8262372741e691c40d76"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/12/c2/11d6845db5edf1295bc08b2f488cf5937806586afe42936c3f34c097ebdc/tabulate-0.8.2.tar.gz"
    sha256 "e4ca13f26d0a6be2a2915428dc21e732f1e44dad7f76d7030b2ef1ec251cf7f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  resource "vsts-cd-manager" do
    url "https://files.pythonhosted.org/packages/fc/cd/29c798a92d5f7a718711e4beace03612c93ad7ec2121aea606d8abae38ee/vsts-cd-manager-1.0.2.tar.gz"
    sha256 "0bb09059cd553e1c206e92ef324cb0dcf92334846d646c44c684f6256b86447b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/35/d4/14e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249b/websocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
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
      buildpath/"src/azure-cli-telemetry",
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
