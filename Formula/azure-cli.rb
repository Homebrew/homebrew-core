class AzureCli < Formula
  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://azurecliprod.blob.core.windows.net/releases/azure-cli-2.0.50.tar.gz"
  sha256 "decbf866e5a4e22914ed177553b89c0b017bf459eacb16e703766e0eae7efa69"
  head "https://github.com/Azure/azure-cli.git"

  bottle do
    cellar :any
    sha256 "b2e75e69ec0b1a9b5c0197cca28a35f03e9512ca234bf780e3d66e0f1d002198" => :mojave
    sha256 "936efb511ab585189818ef3c1bb209e376433768f69f300219397d00e1de35ee" => :high_sierra
    sha256 "638f0c024d9a78e3ce0bf1bd5b939d27d078dd280ec26f1b3274914a6a9b1957" => :sierra
  end

  depends_on "openssl"
  depends_on "python"

  resource "adal" do
    url "https://files.pythonhosted.org/packages/0f/ba/07dbea5f63937c4a9a10946107d72b03354f65a51f9e0602314193fc2bae/adal-1.2.0.tar.gz"
    sha256 "ba52913c38d76b4a4d88eaab41a5763d056ab6d073f106e0605b051ab930f5c1"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/96/aba01b2948ec67f237cd387c022820835ae0d8db5cab4bd404b351660b5e/antlr4-python3-runtime-4.7.1.tar.gz"
    sha256 "1b26b72c4492cef310542da10bf6b2ab4aa1775618fc6003f75b55ae9eaa3fd3"
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
    url "https://files.pythonhosted.org/packages/39/ca/2bdd67243ae7a45281acbbfc139db273868e99fc219e46724dac68094e69/azure-common-1.1.16.zip"
    sha256 "2606ae77ff81c0036965b92ec2efe03eaec02a66714140ca0f7aa401b8b9bbb0"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/62/d6/84d6924fb1cfc108fe6ceacacd1b968e42d33d7e952d912bf2309241dbf5/azure-datalake-store-0.0.34.tar.gz"
    sha256 "54ea8eb3e2ad7c58229c29cfeefcb51401557e2aa7dbeb266a17f00cfcaba870"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/89/6a/e2db001e4f1716368153ea6cae3e2e84e11f8503dc840a764f6671317976/azure-graphrbac-0.52.0.zip"
    sha256 "c401ecaceb40d3724cbe6a43758da525e4e64e6d08dd6339df51daa57baa84cc"
  end

  resource "azure-keyvault" do
    url "https://files.pythonhosted.org/packages/8e/47/b71d7ab466189d0663a8aa216e4cc67eb16d5dfc7d69b62a9140dd8d1a20/azure-keyvault-1.1.0.zip"
    sha256 "37a8e5f376eb5a304fcd066d414b5d93b987e68f9212b0c41efa37d429aadd49"
  end

  resource "azure-mgmt-advisor" do
    url "https://files.pythonhosted.org/packages/f2/fb/bca29d83a2062c7d977742189195d669fd5983017fddb464c90f07adaac0/azure-mgmt-advisor-2.0.1.zip"
    sha256 "1929d6d5ba49d055fdc806e981b93cf75ea42ba35f78222aaf42d8dcf29d4ef3"
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
    url "https://files.pythonhosted.org/packages/c5/c5/e5a7a49a9b96ec3f70b2332e8919d8df940baed4f799fe1ad7d52ff6a241/azure-mgmt-compute-4.3.1.zip"
    sha256 "5b0c2390af3e29d910e3d6e7a72b0be59d6e15933740dd193129217c000e4fed"
  end

  resource "azure-mgmt-consumption" do
    url "https://files.pythonhosted.org/packages/8c/f0/e2d94b246e2dce71eff8d362836a1979f02b4185f5403a13e4fb26c07ccb/azure-mgmt-consumption-2.0.0.zip"
    sha256 "9a85a89f30f224d261749be20b4616a0eb8948586f7f0f20573b8ea32f265189"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/e7/c1/2866937bc19ba102eaca9bc84cd28c0e7695cfbda26d3f299fbd9bd2e5a3/azure-mgmt-containerinstance-1.2.1.zip"
    sha256 "5badd436938767924d89dac2d9a950010131a3ba40febdf3b36c7d30ba5cf69a"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/74/e1/e83d0bc97b63fc6f500b317482c188db4d871ce25db00154d05e25daff12/azure-mgmt-containerregistry-2.3.0.zip"
    sha256 "b707e5943e304e505dd0664e10d08b0916fa8a031575b638f5fea717daa84ba7"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/e4/1c/88e48e8fe7a5d13cfafc7716052d392b08dcc69d08c4302bc48c12b5c3e7/azure-mgmt-containerservice-4.2.2.zip"
    sha256 "99df430a03aada02625e35ef13d7de6c667e9bef56b5e2f60b2c284514223bff"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/2a/53/8a05f9fcce6595c5ce80896efad34ea51a97dde714b0a1763b9178ef2156/azure-mgmt-cosmosdb-0.5.1.zip"
    sha256 "a69f363cc09cd61d9c26ba4fb2e0db6f25e487844132a76b1858e67c719adacc"
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
    url "https://files.pythonhosted.org/packages/a8/b5/a3e49faa5bd5618294d411bbd11ed1ae9eb886c65b78cdcb9bea360a53e4/azure-mgmt-eventgrid-0.4.0.zip"
    sha256 "cf22195fe453627e20d81695a14e3c7b9329790763b65243be55d66964c789ac"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/bb/ad/a6f807a52d6c52e1e44e6f8ca877860970b6593bbfd3286802c322453e65/azure-mgmt-eventhub-2.2.0.zip"
    sha256 "b5407e529b9daeefbb9393c8f7401f44a21ecfeede6e03cf08456149c1d3533e"
  end

  resource "azure-mgmt-hdinsight" do
    url "https://files.pythonhosted.org/packages/54/8d/ae164176232e1d5e03ebe915c06f5dca7c6a5978ca294c131546501b0a17/azure-mgmt-hdinsight-0.1.0.zip"
    sha256 "89c8a3816742cb8ceba8a16d74d3980289d34323177978a410bb7323f6ddf71c"
  end

  resource "azure-mgmt-iotcentral" do
    url "https://files.pythonhosted.org/packages/fe/00/6b67140a57880f58516230897d580392d9d2e9b476934767834c5c6a4b82/azure-mgmt-iotcentral-0.2.0.zip"
    sha256 "8be8a30acd3c07f05c87e8b3109108d6e19351354e51183743977958cf0ada2e"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/54/6f/3d67a99c211fc6b5de1a9930c3c83962cd416b5f6e9e69366a968c6401c7/azure-mgmt-iothub-0.6.0.zip"
    sha256 "a95b20466572f331f884d3e8cd5f159b3924b9ffd9069439b3afcfe6ad388434"
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
    url "https://files.pythonhosted.org/packages/eb/4b/bae36713bb209ac647f030e19b0b81147c18290cc42405655c0e9582a52b/azure-mgmt-network-2.2.1.zip"
    sha256 "a4327bccc435ca4f829ac18f82f17923b490958c202af7a86044ccabeaaa5401"
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
    url "https://files.pythonhosted.org/packages/e4/c6/ee02448a38668a3118846203c1c0605bd8411130f737bc7c8df519c9dd13/azure-mgmt-rdbms-1.4.1.zip"
    sha256 "5a18791e027aa05f636199ee13c2e3ac74216a14d3cbdcb365da82873d02ac5a"
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
    url "https://files.pythonhosted.org/packages/be/19/d41b3eb642735e7e96d6a13947a59328000a3de0813c5b272c19ed76f482/azure-mgmt-reservations-0.3.0.zip"
    sha256 "2588c2f5bfdcd81abc4f79517328925e3518396aa3a7e252fb8a2f7ab1459b77"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/48/31/5996d2af3e32cf6ccc3f44da401ae397e6302b08d7ef7d8736191a8bfe61/azure-mgmt-resource-2.0.0.zip"
    sha256 "2e83289369be88d0f06792118db5a7d4ed7150f956aaae64c528808da5518d7f"
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
    url "https://files.pythonhosted.org/packages/9e/68/d7df2ec227c9082454981f4043f4994e0f1b8aa92beca0cf21c25cf1cfbe/azure-mgmt-sql-0.9.1.zip"
    sha256 "5da488a56d5265757b45747cf5fd22413eb089e606658d6e6d84fe3e9b07e4fa"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/01/99/15d513ee430b5e873e82549087ee185d8cb784674dcce4bcf6733593a70f/azure-mgmt-storage-2.0.0rc4.zip"
    sha256 "7f4282011b4298db9c430274d9c68c50b8785f4a9dfa72863222f487ef99cbd3"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/bb/66/ca0d8190a227ba2fcd2b712209cd39e10e28f71b4d621ef07e7c325e29ca/azure-mgmt-trafficmanager-0.50.0.zip"
    sha256 "126167eaa82b443b5b71394050ec292f45074701232bdbdda71f636e9b46516b"
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
    url "https://files.pythonhosted.org/packages/42/7e/fa7e93011cf319ea5c47ae75024b649b84f011bb06c3cdff5c605ba85730/azure-storage-common-1.3.0.tar.gz"
    sha256 "585658ebc784e843a285732a69aa69ef922e17c3063460c2c7b27c89f377004c"
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
    url "https://files.pythonhosted.org/packages/41/b6/4f0cefba47656583217acd6cd797bc2db1fede0d53090fdc28ad2c8e0716/certifi-2018.10.15.tar.gz"
    sha256 "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a"
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
    url "https://files.pythonhosted.org/packages/55/d5/c35bd3e63757ac767105f8695b055581d8b8dd8c22fef020ebefa2a3725d/colorama-0.4.0.zip"
    sha256 "c9b54bebe91a6a803e0772c8561d53f2926bfeb17cd141fbabcb08424086595c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/22/21/233e38f74188db94e8451ef6385754a98f3cad9b59bedf3a8e8b14988be4/cryptography-2.3.1.tar.gz"
    sha256 "8d10113ca826a4c29d5b85b2c4e045ffa8bad74fb525ee0eceb1d38d4c70dfd6"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/fc/62/327ccaf2bbc726b8612708c3324d8bb8a157418cfba1cf710fc3adf714cf/humanfriendly-4.17.tar.gz"
    sha256 "1d3a1c157602801c62dfdb321760229df2e0d4f14412a0f41b13ad3f930a936a"
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
    url "https://files.pythonhosted.org/packages/16/1d/74adf3b164a8d19a60d0fcf706a751ffa2a1eaa8e5bbb1b6705c92a05263/jeepney-0.4.tar.gz"
    sha256 "6089412a5de162c04747f0220f6b2223b8ba660acd041e52a76426ca550e3c70"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/d5/04/cec2bbdd31057c554ef97769bf8ed3bc014ce01e3b60e13799f26dc5640d/keyring-16.0.0.tar.gz"
    sha256 "8a9b0c2c2abc3e7326559f840e1f05e6d010ccaf397d09f450485920ba08e443"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/eb/bc/23da2de49b20e1b5623619b9eabc7164aa0ddf29710187caa6bd3eefc0e5/knack-0.4.5.tar.gz"
    sha256 "e4b878a5ded7c96b66041d117954a109642d639f6537367162a149428194fd60"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/f7/63/cf85cfa172be9da3c64c6f1f54430411137b81b398bb0e13a04154e9a6df/msrest-0.6.1.tar.gz"
    sha256 "c087b91d68281a870e8cdff84f20dd55bbd6685daa76a307493e6e3a4343fc56"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/cd/ce/1381822930cb2e90e889e43831428982577acb9caec5244bcce1c9c542f9/msrestazure-0.4.34.tar.gz"
    sha256 "4fc94a03ecd5b094ab904d929cc5be7a6a80262eab93948260cfe9081a9e6de4"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/df/5f/3f4aae7b28db87ddef18afed3b71921e531ca288dc604eb981e9ec9f8853/oauthlib-2.1.0.tar.gz"
    sha256 "ac35665a61c1685c56336bda97d5eefa246f1202618a1d6f34fccb1bdd404162"
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
    url "https://files.pythonhosted.org/packages/10/46/059775dc8e50f722d205452bced4b3cc965d27e8c3389156acd3b1123ae3/pyasn1-0.4.4.tar.gz"
    sha256 "f58f2a3d12fd754aa123e9fa74fb7345333000a035f3921dbdaa08597aa53137"
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
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/00/5e/b358c9bb24421e6155799d995b4aa3aa3307ffc7ecae4ad9d29fd7e07a73/PyJWT-1.6.4.tar.gz"
    sha256 "4ee413b357d53fd3fb44704577afac88e72e878716116270d722723d65b42176"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
    sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/9b/7c/ee600b2a9304d260d96044ab5c5e57aa489755b92bbeb4c0803f9504f480/pyOpenSSL-18.0.0.tar.gz"
    sha256 "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"
    sha256 "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/cd/71/ae99fc3df1b1c5267d37ef2c51b7d79c44ba8a5e37b48e3ca93b4d74d98b/pytz-2018.7.tar.gz"
    sha256 "31cb35c89bd7d333cd32c5f278fca91b523b0834369e757f4c5641ea252236ca"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/be/072464f05b70e4142cb37151e215a2037b08b1400f8a56f2538b76ca6205/requests-oauthlib-1.0.0.tar.gz"
    sha256 "8886bfec5ad7afb391ed5443b1f697c6f4ae98d0e5620839d8b4499c032ada3f"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/b3/b6/0ae7a921028d6375e029aad13ea23476279bbf3e719cff483893516ec12e/scp-0.12.1.tar.gz"
    sha256 "5199258c18bb1a5e80421a3cf9cfc3302754fe410e05e61bcc9c1ab253605e32"
  end

  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/17/7a/683ce8d41b0b392199f1f6273a5cc81a0583b886e799786b7add5750817f/SecretStorage-3.1.0.tar.gz"
    sha256 "29aa3cbd36dd5e54ac17d69161f9a150548f4ffba21fa8b5fdd5add854fe7d8b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
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
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
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
