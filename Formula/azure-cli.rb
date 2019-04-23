class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://codeload.github.com/Azure/azure-cli/legacy.tar.gz/3bf3b3256e4678c8dceb7245279e67f05bbfa360"
  version "2.0.63"
  sha256 "0c0d06ac18eb69caf9aefc13c0b49a37305c260825ae203f4dc99ca932b73395"
  head "https://github.com/Azure/azure-cli.git"

  bottle do
    cellar :any
    sha256 "601803b04f7f8cf91456d863c0a7022713ffcf4dcfc659badc2e3caccfda8d91" => :mojave
    sha256 "bc365cd391be91d91f9f365a4277633d96a0659534ab59c84135feda57ef68e8" => :high_sierra
    sha256 "72b3bf580bbf2dc758365ce9ac91c8df230d556bfccc219ecf463bdcab845295" => :sierra
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
    url "https://files.pythonhosted.org/packages/63/6b/d0b2a9938eadbb0d49087f68b518d25fc36f45e98944a0ee4703dab80bfc/argcomplete-1.9.5.tar.gz"
    sha256 "94423d1a56cdec2ef47699e02c9a48cf8827b9c4465b836c0cefb30afe85e59a"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/8a/21/5e49dc8aebaa749f093cc0709dbc0713b1eab7771a1da7c71f2b470b761e/azure-batch-6.0.0.zip"
    sha256 "38a1a20a25a04c26f5bbe65f47e0c456d87ec4b6109bad2c97e10de9f48ecb38"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/49/5d/3d5955e4843093a11c2bae4372ca867e759586483852091752b54acccb25/azure-common-1.1.18.zip"
    sha256 "5fd62ae10b1add97d3c69af970328ec3bd869184396bcf6bfa9c7bc94d688424"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/7b/43/6ebe1b59732ec50255a32ac1da6c8f254767e079836b8c273aceb5ed7a6f/azure-datalake-store-0.0.39.tar.gz"
    sha256 "fd1ca3384808ac806470c26c98bc2346c1784d5b281fac4ea468ba018269ee3a"
  end

  resource "azure-functions-devops-build" do
    url "https://files.pythonhosted.org/packages/93/44/67b14ffacf562d6056b668facf3a3b1c24a8117bccdc99d9a732e3617f3f/azure-functions-devops-build-0.0.21.tar.gz"
    sha256 "0b822ef12cb0b21890d21edb31d92bb88eb2055c604b62e71835b5d3dddce39a"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/3e/4e/4598ea52efc2654b0c865243bd60625d4ffa4df874e7e5dcb76a9a4ddbbc/azure-graphrbac-0.60.0.zip"
    sha256 "d0bb62d8bf8e196b903f3971ba4afa448e4fe14e8394ebfcdd941d84d62ecafe"
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
    url "https://files.pythonhosted.org/packages/3a/00/809a696c6823662e0c7a62895c95288467d4627949f42a20d119b0a0e573/azure-mgmt-batch-6.0.0.zip"
    sha256 "dc929d2a0a65804c28a75dc00bb84ba581f805582a09238f4e7faacb15f8a2a3"
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
    url "https://files.pythonhosted.org/packages/a4/0f/203e44ea1aab1368b73bd70438945ee5e3493405db38a74d74bb1420b498/azure-mgmt-cdn-3.1.0.zip"
    sha256 "0cdbe0914aec544884ef681e31950efa548d9bec6d6dc354e00c3dbdab9e76e3"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/e0/34/def32a5bc74b565bc55ccfc9fd3a5ee3a8ccd36e6a98d6578167d7bbc65d/azure-mgmt-cognitiveservices-3.0.0.zip"
    sha256 "c3247f2786b996a5f328ebdaf65d31507571979e004de7a5ed0ff280f95d80b4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/48/dc/45c4f610d63b0427833da68dbd0145a4814596fbf18915a06b3346c3be0e/azure-mgmt-compute-4.6.1.zip"
    sha256 "10f281a530818c4e418f728b44e2705ac0467893f22f8a21ad5e6446fcf4317e"
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
    url "https://files.pythonhosted.org/packages/7e/67/5055b305ebf9ed0d89431a685dadf97423f1260a292e8f9330961d4ec93a/azure-mgmt-containerregistry-2.7.0.zip"
    sha256 "eef8a747ffb43abeb034419a81091fe3fed24ea6a2beab58f3b6933bb0cf0310"
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
    url "https://files.pythonhosted.org/packages/f4/c6/6b273e3b7bc17c13ef85c0ebc6bf7bbd8289a46892ee5bef1f0859aff11d/azure-mgmt-datalake-analytics-0.2.1.zip"
    sha256 "4c7960d094f5847d9a456c18b8a3c8e60c428e3080a3905f1c943d81ba6351a4"
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

  resource "azure-mgmt-deploymentmanager" do
    url "https://files.pythonhosted.org/packages/53/4a/2cb6f4dbd4f1510249ce5a93dfd78ba258fb562528f24d9621bf49f379cb/azure-mgmt-deploymentmanager-0.1.0.zip"
    sha256 "398a6d38b658c4a790e1a6884921eb98a22a10d906340bb8c9fb3207d709703f"
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
    url "https://files.pythonhosted.org/packages/8e/df/10e4b11415240b24e2df3ef21d0b3ed7809e174afae623349004090c89d5/azure-mgmt-eventhub-2.3.0.zip"
    sha256 "b5dcc1301bc31acc8a1c2166d632e0bebdc1704c98c7d89571b3188e98a3d50f"
  end

  resource "azure-mgmt-hdinsight" do
    url "https://files.pythonhosted.org/packages/f1/98/4bd0c3cddb04a08bbe436b78c4ee14c5471e43067648380a3c6484a3aa37/azure-mgmt-hdinsight-0.2.1.zip"
    sha256 "e86acc86539afe768a07405fa818ee9566db22b1c1e84514180aaca06bd37ec2"
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

  resource "azure-mgmt-kusto" do
    url "https://files.pythonhosted.org/packages/0d/79/887c8f71d7ebd87e4f2359f6726a0a881f1c9369167bf075bf22ba39751c/azure-mgmt-kusto-0.3.0.zip"
    sha256 "9eb8b7781fd4410ee9e207cd0c3983baf9e58414b5b4a18849d09856e36bacde"
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
    url "https://files.pythonhosted.org/packages/77/41/b410828ce54066c2686d4c76da8178741d7a6638d9f07dd75f208e27a0ee/azure-mgmt-media-1.1.1.zip"
    sha256 "5d0c6b3a0f882dde8ae3d42467f03ea6c4e3f62613936087d54c67e6f504939b"
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
    url "https://files.pythonhosted.org/packages/74/82/6f22879e76f5fb87b9930d963a8c62ad01783be32ea734be0107f29d3cb7/azure-mgmt-network-2.6.0.zip"
    sha256 "0166646703389374736cbe045ffb874e08796407ea0b1b5d441143b054a47e09"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/c4/d4/a9a140ee15abd8b0a542c0d31b7212acf173582c10323b09380c79a1178b/azure-mgmt-nspkg-3.0.2.zip"
    sha256 "8b2287f671529505b296005e6de9150b074344c2c7d1c805b3f053d081d58c52"
  end

  resource "azure-mgmt-policyinsights" do
    url "https://files.pythonhosted.org/packages/e1/06/c77e98757cd8366a4d7c93c061b3e50fde05b02cbdac779459b9df249f70/azure-mgmt-policyinsights-0.2.0.zip"
    sha256 "d0d6d50c72cfaa058b93780e84a744c1f0db7f35702dd43a90be890de9289dc1"
  end

  resource "azure-mgmt-privatedns" do
    url "https://files.pythonhosted.org/packages/1b/88/bd382d401e58b87df086f0218af94e7defd78f7cb300427eee3d25a9d7a1/azure-mgmt-privatedns-0.1.0.zip"
    sha256 "d29cfd8cec806e06673d9382d3f5766fc65d9a9de75b424705094a34a7db8d23"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/86/b1/fc6f064ee33705d0a5c2b531a4b811f81042f4382ff0c66312aa716e01f6/azure-mgmt-rdbms-1.7.1.zip"
    sha256 "07ac12e7fc0be5fb351d2605aac372435d15c244d3f4b7b5c5c95e0eee5074c5"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https://files.pythonhosted.org/packages/28/6a/238b3625ba929c199c5c9c83a4e59005597122e799e3e206a089fc76078a/azure-mgmt-recoveryservices-0.1.1.zip"
    sha256 "a84b6df4d2a6e07e43d1de856e8153d5e1178b92dd0c588487c67f7099a75a22"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/17/66/afbea8d3e1535f63ea548765e61fa8c8655faf10523e144a8b2ff201ba50/azure-mgmt-recoveryservicesbackup-0.1.2.zip"
    sha256 "6a089e98ac3f1d3593a14daff116fafbcc78e2d8f65eac0ad4efb8eeaa156db1"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/d0/d2/5f42ae10ee738da5cfaffa082fdd1ef07e1ccd546d72953f87f15f878e57/azure-mgmt-redis-6.0.0.zip"
    sha256 "db999e104edeee3a13a8ceb1881e15196fe03a02635e0e20855eb52c1e2ecca1"
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

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/30/14/191a5a9887eacb94eb314a6b4124e9b4d563c8736061edea8bb32ca158fb/azure-mgmt-security-0.1.0.zip"
    sha256 "1d42ced0690d10ebe5f83bf20be835e1a424d81463e59857cc402f218e3164b1"
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
    url "https://files.pythonhosted.org/packages/98/94/e448ea6c23049842824417e138c9f5d57af230e4ff7fda84dc669b157504/azure-mgmt-sql-0.12.0.zip"
    sha256 "8399702e9d1836f3b040ce0c93d8dc089767d66edb9224a3b8a6c9ab7e8ff01f"
  end

  resource "azure-mgmt-sqlvirtualmachine" do
    url "https://files.pythonhosted.org/packages/51/fe/998f95fa15409b1691b44fc9550779c9decadc8615d56b030df5622e023d/azure-mgmt-sqlvirtualmachine-0.2.0.zip"
    sha256 "9c386bc33437f63e54c34911fb38c9caf02b998eb2ad7551b59757e18f02af81"
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
    url "https://files.pythonhosted.org/packages/82/1d/0a2992e9c00d6b8a88fd7e21e35a4caef086172e3bdcea0abcf990db9dfc/azure-mgmt-web-0.41.0.zip"
    sha256 "5f170f25c72119ff4b4e2f39d46ce21bdb2f399f786ea24eedc15c12cfba3054"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/98/e5/a0387cb84cf4726bbed347124d9bab2be6e181804b889dee35f8f65223b9/azure-multiapi-storage-0.2.3.tar.gz"
    sha256 "ab3dbf0c422e53161b5ba0b2e8be5f4a144d15a5c082cfa1f2ef6b7e83b7a414"
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
    url "https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz"
    sha256 "b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/64/7c/27367b38e6cc3e1f49f193deb761fe75cda9f95da37b67b422e62281fcac/cffi-1.12.2.tar.gz"
    sha256 "e113878a446c6228669144ae8a56e268c91b7f1fafae927adc4879d9849e0ea7"
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

  resource "Fabric" do
    url "https://files.pythonhosted.org/packages/cf/3c/19f930f9e74c417e2c617055ceb2be6aee439ac68e07b7d3b3119a417191/fabric-2.4.0.tar.gz"
    sha256 "93684ceaac92e0b78faae551297e29c48370cede12ff0f853cdebf67d4b87068"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/26/71/e7daf57e819a70228568ff5395fdbc4de81b63067b93167e07825fcf0bcf/humanfriendly-4.18.tar.gz"
    sha256 "33ee8ceb63f1db61cce8b5c800c531e1a61023ac5488ccde2ba574a85be00a85"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/ef/80/cef14194e2dd62582cc0a4f5f2db78fb00de3ba5d1bc0e50897b398ea984/invoke-1.2.0.tar.gz"
    sha256 "dc492f8f17a0746e92081aec3f86ae0b4750bf41607ea2ad87e5a7b5705121b7"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/93/ea/d884a06f8c7f9b7afbc8138b762e80479fb17aedbbe2b06515a12de9378d/Jinja2-2.10.1.tar.gz"
    sha256 "065c4f02ebe7f7cf559e49ee5a95fb800a9e4528727aec6f24402a5374c65013"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/2c/30/f0162d3d83e398c7a3b70c91eef61d409dea205fb4dc2b47d335f429de32/jmespath-0.9.4.tar.gz"
    sha256 "bde2aef6f44302dfb30320115b17d030798de8c4110e28d5cf6cf91a7a31074c"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/b0/a0/0e161aaae24fd95258db01d3491202519c9b1b5a4c748ac163e078b9817f/keyring-19.0.1.tar.gz"
    sha256 "44e5a4e1ad1070c7cd46959a0d6c2a99588b66a6dad6fd685463b486c04855ea"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/76/3d/4a6a243441a9a479b3056ef4215b3bddb0d7827f12b19c72472211256231/knack-0.5.4.tar.gz"
    sha256 "0bf55d4e37864058fd5501210840436d4cf13c831d94d68152646673ec201640"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/0b/ec/437da5296f540830eb7fe0d0d06e4f3f4d97b82ef369b637dec76bf20f3e/msrest-0.6.6.tar.gz"
    sha256 "947e9155fb55bda98340e99c15e4115a268ff69aee0007aaa54b7bf05018029b"
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
    url "https://files.pythonhosted.org/packages/97/76/c151aa4a3054ce63bb6bbd32f3541e4ae068534ed8b74ee2687f6773b013/pbr-5.1.3.tar.gz"
    sha256 "8c361cc353d988e4f5b998555c88098b9d5964c2e11acf7b0d21925a66bb5824"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/01/e1/badb92f4bbd7c8c892d943a0136dcacf123cfbc835535368c74b707bc8dd/portalocker-1.2.1.tar.gz"
    sha256 "3f2a56d3d90e2ac5659ee744336e6953c0050bb61fccb97090a03de5c2a4db9f"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/f1/03/bb36771dc9fa7553ac4bdc639a9ecdf6fda0ff4176faf940d97e3c16e41d/prompt_toolkit-1.0.16.tar.gz"
    sha256 "c1cedd626e08b8ee830ee65897de754113ff3f3035880030c08b01674d85c5b4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2f/b8/11ec5006d2ec2998cb68349b8d1317c24c284cf918ecd6729739388e4c56/psutil-5.6.1.tar.gz"
    sha256 "fa0a570e0a30b9dd618bffbece590ae15726b47f9f1eaf7518dfb35f4d7dcd21"
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

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/2d/0f/4eda562dffd085945d57c2d9a5da745cfb5228c02bc90f2c74bbac746243/pyperclip-1.7.0.tar.gz"
    sha256 "979325468ccf682104d5dcaf753f869868100631301d3e72f47babdea5700d1c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/df/d5/3e3ff673e8f3096921b3f1b79ce04b832e0100b4741573154b72b756a681/pytz-2019.1.tar.gz"
    sha256 "d747dd3d23d77ef44c6a3526e274af6efeb0a6f1afd5a69ba4d5be4098c8e141"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9f/2c/9417b5c774792634834e730932745bc09a7d36754ca00acf1ccd1ac2594d/PyYAML-5.1.tar.gz"
    sha256 "436bc774ecf7c103814098159fbb84c2715d25980175292c648f2da143909f95"
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
    url "https://files.pythonhosted.org/packages/05/e0/ac4169e773e12a08d941ca3c006cb8c91bee9d6d80328a15af850b5e7480/scp-0.13.2.tar.gz"
    sha256 "ef9d6e67c0331485d3db146bf9ee9baff8a48f3eb0e6c08276a8584b13bf34b3"
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
    url "https://files.pythonhosted.org/packages/c2/fd/202954b3f0eb896c53b7b6f07390851b1fd2ca84aa95880d7ae4f434c4ac/tabulate-0.8.3.tar.gz"
    sha256 "8af07a39377cee1103a5c8b3330a421c2d99b9141e9cc5ddd2e3263fea416943"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fd/fa/b21f4f03176463a6cccdb612a5ff71b927e5224e83483012747c12fc5d62/urllib3-1.24.2.tar.gz"
    sha256 "9a247273df709c4fedb38c711e44292304f73f39ab01beda9f6b9fc375669ac3"
  end

  resource "vsts" do
    url "https://files.pythonhosted.org/packages/ce/fa/4405cdb2a6b0476a94b24254cdfb1df7ff43138a91ccc79cd6fc877177af/vsts-0.1.25.tar.gz"
    sha256 "da179160121f5b38be061dbff29cd2b60d5d029b2207102454d77a7114e64f97"
  end

  resource "vsts-cd-manager" do
    url "https://files.pythonhosted.org/packages/fc/cd/29c798a92d5f7a718711e4beace03612c93ad7ec2121aea606d8abae38ee/vsts-cd-manager-1.0.2.tar.gz"
    sha256 "0bb09059cd553e1c206e92ef324cb0dcf92334846d646c44c684f6256b86447b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/c5/01/8c9c7de6c46f88e70b5a3276c791a2be82ae83d8e0d0cc030525ee2866fd/websocket_client-0.56.0.tar.gz"
    sha256 "1fd5520878b68b84b5748bb30e592b10d0a91529d5383f74f4964e72b297fd3a"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fa/b4/f9886517624a4dcb81a1d766f68034344b7565db69f13d52697222daeb72/wheel-0.30.0.tar.gz"
    sha256 "9515fe0a94e823fd90b08d22de45d7bde57c90edce705b22f5e1ecf7e1b653c8"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # Get the CLI components we'll install
    components = [
      buildpath/"src/azure-cli",
      buildpath/"src/azure-cli-telemetry",
      buildpath/"src/azure-cli-core",
      buildpath/"src/azure-cli-nspkg",
      buildpath/"src/azure-cli-command_modules-nspkg",
    ]
    components += Pathname.glob(buildpath/"src/command_modules/azure-cli-*/")

    # Install CLI
    components.each do |item|
      cd item do
        venv.pip_install item
      end
    end

    (bin/"az").write <<~EOS
      #!/usr/bin/env bash
      #{libexec}/bin/python -m azure.cli \"$@\"
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
