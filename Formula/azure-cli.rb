class AzureCli < Formula
  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://azurecliprod.blob.core.windows.net/releases/azure-cli-2.0.45.tar.gz"
  sha256 "a9478f5a0d87e6cf1b14e42b14f5f560df3721f1f75f3f004842a2a3f5ec4553"
  head "https://github.com/Azure/azure-cli.git"

  bottle do
    cellar :any
    sha256 "579a695a925e907607b788691067306cc890dc99a2fd53e6001f453cd8921039" => :mojave
    sha256 "2ae976022528a7c21aa0a8c9cb7863290d0b0ac6b2c03ff5860aaf72e5d99d09" => :high_sierra
    sha256 "bba0452bf50fdcdb1e5c4ce1cb3677333349a1f29a24786cf95ba8989c7698da" => :sierra
    sha256 "6623994161a4e17f5eaa85009febd0fdb10c8a53f250ebb0741cd9327d0ea3ac" => :el_capitan
  end

  depends_on "openssl"
  depends_on "python"

  resource "adal" do
    url "https://files.pythonhosted.org/packages/80/65/d62a4b43eca475cf865ffc2acc18be08fe3430f374b0a0d931d7063b5d72/adal-1.0.2.tar.gz"
    sha256 "4c020807b3f3cfd90f59203077dd5e1f59671833f8c3c5028ec029ed5072f9ce"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/96/aba01b2948ec67f237cd387c022820835ae0d8db5cab4bd404b351660b5e/antlr4-python3-runtime-4.7.1.tar.gz"
    sha256 "1b26b72c4492cef310542da10bf6b2ab4aa1775618fc6003f75b55ae9eaa3fd3"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/84/d5/20b751cd4495c6bc4639cf53e7f4a12185bc48434aa4f50dcaf5ddcf1c96/applicationinsights-0.11.6.tar.gz"
    sha256 "028c963683a6fe9d4b22fcaa532e9207befdb8c44710a3a0ee78aad51b5baa2c"
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

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/bb/c1/ac3842e1016561953872d7ee15aae2d246fb989e5b236abd22ee40b2c39a/azure-common-1.1.14.zip"
    sha256 "4f8fc8879cfded406d0032d86f5750d8c742658072aef5edb1d54a055a847645"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/82/22/e546bad3b8467e0ca386d5497a3001bfdf049d11c75ceb24f6cddfff543b/azure-datalake-store-0.0.27.tar.gz"
    sha256 "c13f73b02264a71ab450331a5c3d49cc70d3e8ada67443bfc148262e907fd5b8"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/c1/4c/3904f9c7b4470df6a2e49c2d1c6f314a337f34dccbadcdcb892d12493c52/azure-graphrbac-0.40.0.zip"
    sha256 "f94b97bdcf774878fe2f8b8c46a5d6550a4ed891350ed0730c1561a24d488ee2"
  end

  resource "azure-keyvault" do
    url "https://files.pythonhosted.org/packages/8e/47/b71d7ab466189d0663a8aa216e4cc67eb16d5dfc7d69b62a9140dd8d1a20/azure-keyvault-1.1.0.zip"
    sha256 "37a8e5f376eb5a304fcd066d414b5d93b987e68f9212b0c41efa37d429aadd49"
  end

  resource "azure-mgmt-advisor" do
    url "https://files.pythonhosted.org/packages/f0/67/5de0f7f8f71f2adbed66f981fcd77c0db5ed8801be87dc00799f3296f686/azure-mgmt-advisor-1.0.1.zip"
    sha256 "8fdcb41f760a216e6b835eaec11dba61822777b386139d83eee31f0ff63b05da"
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

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/3f/2a/2c5450add0e93067270b24a39444c1bfb1a18ee705c5735cf38f5900f270/azure-mgmt-cdn-3.0.0.zip"
    sha256 "069774eb4b59b76ff9bd01708be0c8f9254ed40237b48368c3bb173f298755dd"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/2d/98/998cc11d25751c3fc93078040c9f725641d34d3424dd9cada2b7edf585e4/azure-mgmt-cognitiveservices-1.0.0.zip"
    sha256 "9a124d5c8827c2af3eeb1e3829e116d0ae582d27eb0e49d6a250489b7be11582"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/82/56/8d901cc9068d1ee2ea39da1f0752d131317022f804f5fc2a1005fbe364d4/azure-mgmt-compute-4.0.0.zip"
    sha256 "d6f3caf624a504bbc1ecd9becce832bcd6db4e96bfd83b767ca8430600c598a7"
  end

  resource "azure-mgmt-consumption" do
    url "https://files.pythonhosted.org/packages/8c/f0/e2d94b246e2dce71eff8d362836a1979f02b4185f5403a13e4fb26c07ccb/azure-mgmt-consumption-2.0.0.zip"
    sha256 "9a85a89f30f224d261749be20b4616a0eb8948586f7f0f20573b8ea32f265189"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/37/db/356a1d44dd6a5fc019780dfc098e17c4680601876349a4f4103b893d778e/azure-mgmt-containerinstance-1.0.0.zip"
    sha256 "68c8150b5431752484b4933a6a15856b503068314b9d87ff99b03df3549bc92f"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/d9/7c/44822668ea94b748884fbcb4359673a9abbe1ff37bc7ae763ae99d351c3e/azure-mgmt-containerregistry-2.1.0.zip"
    sha256 "4624bdaae57b5e107264f286931d0d81f942d0c57b0d93e8a2432abf9b074d7d"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/e4/1c/88e48e8fe7a5d13cfafc7716052d392b08dcc69d08c4302bc48c12b5c3e7/azure-mgmt-containerservice-4.2.2.zip"
    sha256 "99df430a03aada02625e35ef13d7de6c667e9bef56b5e2f60b2c284514223bff"
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
    url "https://files.pythonhosted.org/packages/1d/67/b3fad6c04240edf278d2afa71129b8a86f43803ee681c518beac5729e58b/azure-mgmt-devtestlabs-2.2.0.zip"
    sha256 "d416a6d0883b0d33a63c524db6455ee90a01a72a9d8757653e446bf4d3f69796"
  end

  resource "azure-mgmt-dns" do
    url "https://files.pythonhosted.org/packages/aa/11/b6c0172c25cf3be7a89282213e58a624b85ec1ed5396e9400277b6082ef6/azure-mgmt-dns-2.0.0rc2.zip"
    sha256 "d7fc25555f2e88ebf47bc2c654caf3f06b5a636eec1f5ab052224ca2b4c4db05"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/a8/b5/a3e49faa5bd5618294d411bbd11ed1ae9eb886c65b78cdcb9bea360a53e4/azure-mgmt-eventgrid-0.4.0.zip"
    sha256 "cf22195fe453627e20d81695a14e3c7b9329790763b65243be55d66964c789ac"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/a5/f4/aa3ae0be1bd05127afd178bb363034dbf68f7e46af45c61cd364de4a3698/azure-mgmt-eventhub-2.1.0.zip"
    sha256 "6a3a0cc288c5fb40cff2b88f9abdf783b4dbac287ba1ddb05b3b7e668b89426b"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/34/7b/9a8aa8bebf77b18b208a65ceedb915167b314746572d6e4ea2913eb3526c/azure-mgmt-iothub-0.5.0.zip"
    sha256 "08388142ed6844f0a0e97d2740decf80ffc94f22adca174c15f60b9e2c2d14be"
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

  resource "azure-mgmt-marketplaceordering" do
    url "https://files.pythonhosted.org/packages/30/16/e381dd68bfc281f110a94733abdce0626b9c38647ea17f89adc937c61f49/azure-mgmt-marketplaceordering-0.1.0.zip"
    sha256 "6da12425cbab0cc62f246e7266b4d67aff6bdd031ecbe50c7542c2f2b2440ad4"
  end

  resource "azure-mgmt-media" do
    url "https://files.pythonhosted.org/packages/97/ac/f3fb4c8a5565a0b7b8dfd27a9d3bccea351019680a8c5dd118a9e5146eda/azure-mgmt-media-1.0.0rc1.zip"
    sha256 "389ebf1cfa3c3a0678ddc13157b567a1c0995fd508d10d9a3abfca2e87684395"
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
    url "https://files.pythonhosted.org/packages/c6/ce/27caa87ff5f12af522d392aeea035e14b560d59cd5c034dfb94be08a30dd/azure-mgmt-network-2.0.0rc3.zip"
    sha256 "87e5d847970a2e28437a1b0c751d8590411adf63d6917cd6fbd3d47a84a7e7ed"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/fe/66/66eb0d5ead69b7371649466fa160a166de0d1ddafc4a1d7a172858a8abc9/azure-mgmt-nspkg-2.0.0.zip"
    sha256 "e36488d4f5d7d668ef5cc3e6e86f081448fd60c9bf4e051d06ff7cfc5a653e6f"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/de/61/80e7b2510efee13334095e509f8daf42187b811f7eb7fab830be9f453d19/azure-mgmt-rdbms-1.2.0.zip"
    sha256 "6e5abef2fcac1149dda1119443ea26c847e55e8b4c771b7b033f92d1b3140263"
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

  resource "azure-mgmt-reservations" do
    url "https://files.pythonhosted.org/packages/27/04/fd610a6e3095ec09f6c0e3d9b3ba356c7fac329b260b82014a7cb7b0eb2b/azure-mgmt-reservations-0.2.1.zip"
    sha256 "40618a3700c47a788182649f238d985edf15b08b6577ea27557e70e2866ac171"
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
    url "https://files.pythonhosted.org/packages/bf/73/ab9df5d9e771a54457d8e20bff1b2ef3be4f6817f5df9efa37a785ec016e/azure-mgmt-servicebus-0.5.1.zip"
    sha256 "7977e9118206c7740e00b5e37c697b195125cbaedca19a54ed4bdb79ec4b988d"
  end

  resource "azure-mgmt-servicefabric" do
    url "https://files.pythonhosted.org/packages/13/cd/996d5887c207c175eb1be0936b994db3382d0e2998e58baaf5255e53ddc2/azure-mgmt-servicefabric-0.2.0.zip"
    sha256 "b2bf2279b8ff8450c35e78e226231655021482fdbda27db09975ebfc983398ad"
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
    url "https://files.pythonhosted.org/packages/44/d6/08ba5653702e67d401291128fc30aa6cff05fb82299832899c2ce63ca6cd/azure-mgmt-web-0.35.0.zip"
    sha256 "8ea0794eef22a257773c13269b94855ab79d36c342ad15a98135403c9785cc0a"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/b6/fd/be45075a77d26e32a2687c301e566989fbe3c8c0da27f5b87b4b073726cb/azure-multiapi-storage-0.2.2.tar.gz"
    sha256 "2f46a08fa73f857ed37d7f2d43ce50d382ab69dd4e502662ea7be30166f7a1e8"
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
    url "https://files.pythonhosted.org/packages/e1/0f/f8d5e939184547b3bdc6128551b831a62832713aa98c2ccdf8c47ecc7f17/certifi-2018.8.24.tar.gz"
    sha256 "376690d6f16d32f9d1fe8932551d80b23e9d393a8578c5633a2ed39a64861638"
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
    url "https://files.pythonhosted.org/packages/22/21/233e38f74188db94e8451ef6385754a98f3cad9b59bedf3a8e8b14988be4/cryptography-2.3.1.tar.gz"
    sha256 "8d10113ca826a4c29d5b85b2c4e045ffa8bad74fb525ee0eceb1d38d4c70dfd6"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cf/46/256928c918abb6794eb639706e82c1da6845d5532957b9013abc8a48b6af/humanfriendly-4.16.1.tar.gz"
    sha256 "ed1e98ae056b597f15b41bddcc32b9f21e6ab4f3445f9faad1668675de759f7b"
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
    url "https://files.pythonhosted.org/packages/a0/c9/c08bf10bd057293ff385abaef38e7e548549bbe81e95333157684e75ebc6/keyring-13.2.1.tar.gz"
    sha256 "6364bb8c233f28538df4928576f4e051229e0451651073ab20b315488da16a58"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/04/6c/a81b1f3282157591816f03254ba4f52097980f04abb25bd0088089253b7e/knack-0.4.2.tar.gz"
    sha256 "ad346fb0aa8103936f4e40d951492502e719fce93bf050f508dcd8a94c07bfe7"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/d9/48/e636320da2f5ebf2a0786af61f9656ede1448f57b5b8d1a232e313fc5081/msrest-0.5.4.tar.gz"
    sha256 "d609c2997ab66aa8985a6ced972e895cd7aa0a415d715af042a554c5c791934a"
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
    url "https://files.pythonhosted.org/packages/29/65/83181630befb17cd1370a6abb9a87957947a43c2332216e5975353f61d64/paramiko-2.4.1.tar.gz"
    sha256 "33e36775a6c71790ba7692a73f948b329cf9295a72b0102144b031114bd2a4f3"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c8/c3/935b102539529ea9e6dcf3e8b899583095a018b09f29855ab754a2012513/pbr-4.2.0.tar.gz"
    sha256 "1b8be50d938c9bb75d0eaf7eda111eec1bf6dc88a62a6412e33bf077457e0f45"
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
    url "https://files.pythonhosted.org/packages/00/5e/b358c9bb24421e6155799d995b4aa3aa3307ffc7ecae4ad9d29fd7e07a73/PyJWT-1.6.4.tar.gz"
    sha256 "4ee413b357d53fd3fb44704577afac88e72e878716116270d722723d65b42176"
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

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"
    sha256 "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"
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
    url "https://files.pythonhosted.org/packages/bb/ae/4ff2ae1f722d0c23dc4cdf74a4e05b0d1bbe752dc28620b9fe05c53e61aa/websocket_client-0.51.0.tar.gz"
    sha256 "030bbfbf29ac9e315ffb207ed5ed42b6981b5038ea00d1e13b02b872cc95e8f6"
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
