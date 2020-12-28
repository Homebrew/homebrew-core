class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://files.pythonhosted.org/packages/26/e7/20cb4bd25031fd8db8590faca98e0d01bbd94732b23a6e738ca4c06dcbb8/azure-cli-2.16.0.tar.gz"
  sha256 "2a6d466d4283bb30f45e9db17eec0163a6a876c3f2ee9f4699de7d29e97373a5"
  license "MIT"
  revision 1
  head "https://github.com/Azure/azure-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "060e866d833bffdc0b57cb799cc07c8c3adffe852702745d66a8fadf8d733591" => :big_sur
    sha256 "6bfac908b777166222ad3bb247162d881520ee322107f476fbba2f4d520e373f" => :catalina
    sha256 "2671ac78e9e0a19e9a82632106a343256a53eae3f55aeb1b1764553a91f90384" => :mojave
  end

  depends_on "openssl@1.1"
  # Azure CLI is not compatible with Python 3.9 yet
  depends_on "python@3.8"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/ae/8d/530a05e4e21759a3bd59ed75aed73056398906999e23a7a758c714d87762/adal-1.2.5.tar.gz"
    sha256 "8003ba03ef04170195b3eddda8a5ab43649ef2c5f0287023d515affb1ccfcfc3"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/29/14/8ac135ec7cc9db3f768e2d032776718c6b23f74e63543f0974b4873500b2/antlr4-python3-runtime-4.7.2.tar.gz"
    sha256 "168cdcec8fb9152e84a87ca6fd261b3d54c8f6358f42ab3b813b14a7193bb50b"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/f5/02/b831bf3281723b81eb6b041d91d2c219123366f975ec0a73556620773417/applicationinsights-0.11.9.tar.gz"
    sha256 "30a11aafacea34f8b160fbdc35254c9029c7e325267874e3c68f6bdbcd6ed2c3"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/cb/53/d2e3d11726367351b00c8f078a96dacb7f57aef2aca0d3b6c437afc56b55/argcomplete-1.12.2.tar.gz"
    sha256 "de0e1282330940d52ea92a80fea2e4b9e0da1932aaa570f84d268939d1897b04"
  end

  resource "azure-appconfiguration" do
    url "https://files.pythonhosted.org/packages/21/0a/1b24d1b3c1477b849d48aa29dcde3141c1524fab293042493f3432b672c2/azure-appconfiguration-1.1.1.zip"
    sha256 "b83cd2cb63d93225de84e27abbfc059212f8de27766f4c58dd3abb839dff0be4"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/76/eb/dfd058cad009024cfbb8b22c1f6e75d5f9c035a9f04db50a4360d59130d2/azure-batch-9.0.0.zip"
    sha256 "47ca6f50a640915e1cdc5ce3c1307abe5fa3a636236e561119cf62d9df384d84"
  end

  resource "azure-cli-core" do
    url "https://files.pythonhosted.org/packages/6f/f9/9e2f4f2dc9b1e3f1ada9042d259b1c1c47566690ad6b555b00c1a6ef588e/azure-cli-core-2.16.0.tar.gz"
    sha256 "6b54bf0bdab27ad8646c89ee2c2f0529fbbe00ea755eaa94e77e4aedd7fdf3e3"
  end

  resource "azure-cli-telemetry" do
    url "https://files.pythonhosted.org/packages/2e/b6/a28fb77132e29f50e185b24825c6ff925b37e9974d212273bda8eb5d13f6/azure-cli-telemetry-1.0.6.tar.gz"
    sha256 "fc6cadf59f14f3bbd6c01d1b4d6ad54cfc1456303510d8bdb6206db08c40e661"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/af/63/bbdc87fd69c7582130f61523cd9e30b7194eae7609d0d168041edc85479e/azure-common-1.1.26.zip"
    sha256 "b2866238aea5d7492cfb0282fc8b8d5f6d06fb433872345864d45753c10b6e4f"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/d3/d9/90d70fb4d4fb8be96913efcdefcfb5f838bbef9b3a27eef40d0d066b8060/azure-core-1.9.0.zip"
    sha256 "ef8ae93a2ce8b595f231395579be11aadc1838168cbc2582e2d0bbd8b15c461f"
  end

  resource "azure-cosmos" do
    url "https://files.pythonhosted.org/packages/3c/d3/f74bf55c48851944b726cb36883c68d3c4bb887fb2196f216ca543c691e1/azure-cosmos-3.2.0.tar.gz"
    sha256 "4f77cc558fecffac04377ba758ac4e23f076dc1c54e2cf2515f85bc15cbde5c6"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/2e/e8/0483d88c6dba818b5a81c410c7bf1bce5817077961f3d408731aa2481fa6/azure-datalake-store-0.0.51.tar.gz"
    sha256 "b871ebb3bcfd292e8a062dbbaacbc132793d98f1b60f549a8c3b672619603fc1"
  end

  resource "azure-functions-devops-build" do
    url "https://files.pythonhosted.org/packages/d5/96/59ca26c8d9985df8a092cf5974e54b6c3e11208833ea1c0163d7fb763c94/azure-functions-devops-build-0.0.22.tar.gz"
    sha256 "c6341abda6098813f8fa625acd1e925410a17a8a1c7aaabdf975bb7cecb14edf"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/3e/4e/4598ea52efc2654b0c865243bd60625d4ffa4df874e7e5dcb76a9a4ddbbc/azure-graphrbac-0.60.0.zip"
    sha256 "d0bb62d8bf8e196b903f3971ba4afa448e4fe14e8394ebfcdd941d84d62ecafe"
  end

  resource "azure-keyvault" do
    url "https://files.pythonhosted.org/packages/8e/47/b71d7ab466189d0663a8aa216e4cc67eb16d5dfc7d69b62a9140dd8d1a20/azure-keyvault-1.1.0.zip"
    sha256 "37a8e5f376eb5a304fcd066d414b5d93b987e68f9212b0c41efa37d429aadd49"
  end

  resource "azure-keyvault-administration" do
    url "https://files.pythonhosted.org/packages/93/14/ee5ec47f59d8a2764f5f3d5e0065b5fcb82ec203e97f0ebae79c67ebf483/azure-keyvault-administration-4.0.0b2.zip"
    sha256 "565678f2d8127632780a944017d7f4a109d692d39be27a0f895dac255443ed05"
  end

  resource "azure-loganalytics" do
    url "https://files.pythonhosted.org/packages/7a/37/6d296ee71319f49a93ea87698da2c5326105d005267d58fb00cb9ec0c3f8/azure-loganalytics-0.1.0.zip"
    sha256 "3ceb350def677a351f34b0a0d1637df6be0c6fe87ff32a5270b17f540f6da06e"
  end

  resource "azure-mgmt-advisor" do
    url "https://files.pythonhosted.org/packages/f2/fb/bca29d83a2062c7d977742189195d669fd5983017fddb464c90f07adaac0/azure-mgmt-advisor-2.0.1.zip"
    sha256 "1929d6d5ba49d055fdc806e981b93cf75ea42ba35f78222aaf42d8dcf29d4ef3"
  end

  resource "azure-mgmt-apimanagement" do
    url "https://files.pythonhosted.org/packages/eb/6b/cbcc455ff4a5128955928ec7718787821e522f654f456b158f0fcc344e21/azure-mgmt-apimanagement-0.2.0.zip"
    sha256 "790f01c0b32583706b8b8c59667c0f5a51cd70444eee76474e23a598911e1d72"
  end

  resource "azure-mgmt-appconfiguration" do
    url "https://files.pythonhosted.org/packages/3f/3b/3dd55a7081523b97ac3dafdf9191a5d557a8dd175e14daa303c3a1ee4c0e/azure-mgmt-appconfiguration-0.6.0.zip"
    sha256 "fe6e216ce7293219b7d8d1cbcca7cf2f4511f134c2bf0b3455078bf086436c5f"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https://files.pythonhosted.org/packages/83/ad/27c3e2c618c08ea451a80d6a0dc5b73b8c8c2392706909f297c37389766f/azure-mgmt-applicationinsights-0.1.1.zip"
    sha256 "f10229eb9e3e9d0ad20188b8d14d67055e86f3815b43b75eedf96b654bee2a9b"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/8d/e7/193801d2a703c1892bae98c2d517308a4711c63d0fc2d693df74fca43a26/azure-mgmt-authorization-0.61.0.zip"
    sha256 "f5cceea3add04e9445ea88492f15eecf6c126f0406d967c95f6e48b79be8db75"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/a3/f8/a91baa48ef5097d89cf4c7381b76657931fe525fad4d912bd6ac62386ac6/azure-mgmt-batch-9.0.0.zip"
    sha256 "03417eecfa1fac906e674cb1cb43ed7da27a96277277b091d7c389ba39f6c3fe"
  end

  resource "azure-mgmt-batchai" do
    url "https://files.pythonhosted.org/packages/fa/7f/0a9e5aa22ea91db0771c267c4815396516177702a4a4eea389eed7af47dd/azure-mgmt-batchai-2.0.0.zip"
    sha256 "f1870b0f97d5001cdb66208e5a236c9717a0ed18b34dbfdb238a828f3ca2a683"
  end

  resource "azure-mgmt-billing" do
    url "https://files.pythonhosted.org/packages/ed/53/79afdd87c1c117835554582a3e0ed835d49bd862f931ac38b29c9e18749f/azure-mgmt-billing-1.0.0.zip"
    sha256 "8b55064546c8e94839d9f8c98e9ea4b021004b3804e192bf39fa65b603536ad0"
  end

  resource "azure-mgmt-botservice" do
    url "https://files.pythonhosted.org/packages/eb/8e/f523bf5c10abd10c945d0911a6988b9ee347464939d8b9cf769721bdbcb3/azure-mgmt-botservice-0.2.0.zip"
    sha256 "b21d8858e69aa16d25b908c40116a1f773c127ec4dd602cbb8542ebf39a55d83"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/79/d6/310df0a02621feeda16173748befc85da4bc3656e30c55830f0bf2fecd35/azure-mgmt-cdn-5.2.0.zip"
    sha256 "3e470ba07918a4f97dadb6f50c6f64068da423b735fad38d31d9535c56f06881"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/a2/b2/209015559d399f3a9b67ee2faaf7b19676e2f15107a1b20f99a5a3d1a82c/azure-mgmt-cognitiveservices-6.3.0.zip"
    sha256 "1d029d5140152a36cc32f340e09f2b185ede2f54e577a44f3821878efb823415"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/2f/88/2fd024f3aa585f1821ef103347cdc7df04c416179865e961aa0b45bf68bb/azure-mgmt-compute-14.0.0.zip"
    sha256 "4949fec9976e5d5b3cf2bb452154a86e0bab1785f72a20bdb3f5317a4dd9782f"
  end

  resource "azure-mgmt-consumption" do
    url "https://files.pythonhosted.org/packages/8c/f0/e2d94b246e2dce71eff8d362836a1979f02b4185f5403a13e4fb26c07ccb/azure-mgmt-consumption-2.0.0.zip"
    sha256 "9a85a89f30f224d261749be20b4616a0eb8948586f7f0f20573b8ea32f265189"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/95/3b/513362470b6b61fe2a5067e5426351a40fe8d6bd7197a5355d2957928b4d/azure-mgmt-containerinstance-1.5.0.zip"
    sha256 "b055386f04ba8433112b0df7fcbc260b5208828d7bb8c057e760fe596aa7a8cd"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/fc/76/98ebc879dbc4e15e2bcb7b3d7e053368f5d7b446cc7291eadea997248dd2/azure-mgmt-containerregistry-3.0.0rc15.zip"
    sha256 "6b1b3cc4929da8a0c95be519f66ac28b35c5eda97917cd0533b6cd53076dd5ba"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/c0/e3/ce640e21c8fc8b037f6b2d7671a1aed2ee9daf3f04739ff43fe74f95f85c/azure-mgmt-containerservice-9.4.0.zip"
    sha256 "d90684106c70779450b82067be4d3e449c799ca1f47d941e45f6d2b5c016dac9"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/77/06/87dd6ff888cfa9d65fbd480115fc0795120df665c29556f37bf28b559ffc/azure-mgmt-core-1.2.1.zip"
    sha256 "a3906fa77edfedfcc3229dc3b69489d5ed63b107c7eacbc50092e6cbfbfd83f0"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/86/69/c8da66ceeb7dcb7040e86ff32c97cb0134c2d9a1ae7796d612667f15957a/azure-mgmt-cosmosdb-1.0.0.zip"
    sha256 "e08b37aea8e6b62596f55f9beb924e1759b2dc424c180ab2e752153a2b01b723"
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
    url "https://files.pythonhosted.org/packages/9d/21/548a9b6b85814fd73f61531f555230d846213a95f4612d0811ff916b71f8/azure-mgmt-deploymentmanager-0.2.0.zip"
    sha256 "46e342227993fc9acab1dda42f2eb566b522a8c945ab9d0eea56276b46f6d730"
  end

  resource "azure-mgmt-devtestlabs" do
    url "https://files.pythonhosted.org/packages/f0/18/ef3217b4ef0acc25d1ed20f5e873f6ad3fe80dafaf8b9c17349063bb1d98/azure-mgmt-devtestlabs-4.0.0.zip"
    sha256 "59549c4c4068f26466b1097b574a8e5099fb2cd6c8be0a00395b06d3b29e278d"
  end

  resource "azure-mgmt-dns" do
    url "https://files.pythonhosted.org/packages/a2/0d/a36c123a1c978d39a1da747b9e8179f37441176d2a5276124d6d3312b2c4/azure-mgmt-dns-2.1.0.zip"
    sha256 "3730b1b3f545a5aa43c0fff07418b362a789eb7d81286e2bed90ffef88bfa5d0"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/d6/c8/ff41ff7da5480246bae73bb1a31d5ffe462a6337b284d7bfed90b8981df2/azure-mgmt-eventgrid-3.0.0rc7.zip"
    sha256 "68f9eb18b74fa86e07cf4e4d1a2ed16fe549bdd53f21a707b05798616b01a9d4"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/7a/61/0c211f100900066787ea5fc6bd586806f95d54c4129e824859b9310567f2/azure-mgmt-eventhub-4.1.0.zip"
    sha256 "05b543eb3d2d9bdb2d78bf7366afa5f7e1ba5614f92793f3f2a988453538cfa0"
  end

  resource "azure-mgmt-hdinsight" do
    url "https://files.pythonhosted.org/packages/d0/92/2ceaf3ac2110852983883411619f160053303c985573512fcd253e7058d3/azure-mgmt-hdinsight-2.0.0.zip"
    sha256 "fd47029f2423e45ec4d311f651dc972043b98e960f186f5c6508c6fdf6eb2fe8"
  end

  resource "azure-mgmt-imagebuilder" do
    url "https://files.pythonhosted.org/packages/25/37/63e5eca05f58b7d9d9f0525f389f1938afe0f593e4216679fb8af4a5bc6b/azure-mgmt-imagebuilder-0.4.0.zip"
    sha256 "4c9291bf16b40b043637e5e4f15650f71418ac237393e62219cab478a7951733"
  end

  resource "azure-mgmt-iotcentral" do
    url "https://files.pythonhosted.org/packages/66/51/aab8a442dca004f4e2d71c33e15a9d7a15149a0bdb382a7409912c998e19/azure-mgmt-iotcentral-3.0.0.zip"
    sha256 "f6dacf442ccae2f18f1082e80bcbdcaa8c0efa2ba92b48c5db6ee01d37240047"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/28/d2/6868d49c45ddc6bdd8b85d45044ce7ba7373d4524981413c806aada18955/azure-mgmt-iothub-0.12.0.zip"
    sha256 "da20ee2b9b9a2c2f89be9037c3ee5421152e7f6d718eafbf50a91dbf0a07ffa0"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https://files.pythonhosted.org/packages/7a/9e/179a404d2b3d999cf2dbdbec51c849e92625706e8eff6bd6d02df3ad2ab7/azure-mgmt-iothubprovisioningservices-0.2.0.zip"
    sha256 "8c37acfd1c33aba845f2e0302ef7266cad31cba503cc990a48684659acb7b91d"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/69/56/678b158efbd4b4d70151a0d688e11a529a42eac3ff426813878f253f76c4/azure-mgmt-keyvault-8.0.0.zip"
    sha256 "2c974c6114d8d27152642c82a975812790a5e86ccf609bf370a476d9ea0d2e7d"
  end

  resource "azure-mgmt-kusto" do
    url "https://files.pythonhosted.org/packages/0d/79/887c8f71d7ebd87e4f2359f6726a0a881f1c9369167bf075bf22ba39751c/azure-mgmt-kusto-0.3.0.zip"
    sha256 "9eb8b7781fd4410ee9e207cd0c3983baf9e58414b5b4a18849d09856e36bacde"
  end

  resource "azure-mgmt-loganalytics" do
    url "https://files.pythonhosted.org/packages/e3/60/d5679339c6f87bcd5f852202e8d250fe649a4866e51d293be6189309ad2e/azure-mgmt-loganalytics-0.7.0.zip"
    sha256 "50fb7f714685d170ce9607e3c30488e194015845ef7f0a717b80609837a6c2a2"
  end

  resource "azure-mgmt-managedservices" do
    url "https://files.pythonhosted.org/packages/f8/db/faab14079c628202d771a2bc33016326de6d194d1460fd8e531a59664371/azure-mgmt-managedservices-1.0.0.zip"
    sha256 "fed8399fc6773aada37c1d0496a46f59410d77c9494d0ca5967c531c3376ad19"
  end

  resource "azure-mgmt-managementgroups" do
    url "https://files.pythonhosted.org/packages/f2/03/30442b6025da7a730b24b5d208119740382e2c5135ec0b96a1003b3c86fe/azure-mgmt-managementgroups-0.2.0.zip"
    sha256 "3d5237947458dc94b4a392141174b1c1258d26611241ee104e9006d1d798f682"
  end

  resource "azure-mgmt-maps" do
    url "https://files.pythonhosted.org/packages/58/99/735fc6f274d2f2a493071b4bc3e6ec2bc3d0d6caf1425eb903647785532c/azure-mgmt-maps-0.1.0.zip"
    sha256 "c120e210bb61768da29de24d28b82f8d42ae24e52396eb6569b499709e22f006"
  end

  resource "azure-mgmt-marketplaceordering" do
    url "https://files.pythonhosted.org/packages/e9/90/1bf9d50614acee60ba5447bc9db6d63930f1559182fa8266ccac60a96dd3/azure-mgmt-marketplaceordering-0.2.1.zip"
    sha256 "dc765cde7ec03efe456438c85c6207c2f77775a8ce8a7adb19b0df5c5dc513c2"
  end

  resource "azure-mgmt-media" do
    url "https://files.pythonhosted.org/packages/8d/66/20204097b73f62c9707a46d9a766a6f450f85267ae95f9d13ea95706eb48/azure-mgmt-media-2.2.0.zip"
    sha256 "0adeee9e654a9011f5107def06fea6838864a3514a1e5a9ed495f3a56a687cc7"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/70/e0/ffc140937f4b3b3e55b96a859afcb5eea6b57a29237f36e84db8da52aa69/azure-mgmt-monitor-0.11.0.zip"
    sha256 "c6e1fe83dd2ddffa7f6d90c7aa63b3128042396a3893c14dc4816ad28cb15016"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/da/6f/60f92469f93e2820949f967b8c722fe0c04f03e4cc9a6332ffaf5e9f405b/azure-mgmt-msi-0.2.0.zip"
    sha256 "8622bc9a164169a0113728ebe7fd43a88189708ce6e10d4507247d6907987167"
  end

  resource "azure-mgmt-netapp" do
    url "https://files.pythonhosted.org/packages/1c/03/e8620fd9a48fde3b6f3db552912ba903c14c319bd220e70aac9b12ec3f7d/azure-mgmt-netapp-0.14.0.zip"
    sha256 "6fd915e68d314bec8b56c6ece194005d2c4fc97478fc1f797639d4a6913c1539"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/f6/76/3c987c51b5f683e0af10fe7e5c3d9ab2820ee0939f78772df10b2f834ed2/azure-mgmt-network-13.0.0.zip"
    sha256 "084b4253ef61e26a72cad3eb00e7adbfd0e54cf738498392e70d73a21d294c09"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/c4/d4/a9a140ee15abd8b0a542c0d31b7212acf173582c10323b09380c79a1178b/azure-mgmt-nspkg-3.0.2.zip"
    sha256 "8b2287f671529505b296005e6de9150b074344c2c7d1c805b3f053d081d58c52"
  end

  resource "azure-mgmt-policyinsights" do
    url "https://files.pythonhosted.org/packages/25/aa/1f0cb5c3533de2641a692b0b3cb4d06003579a21e6eec280a8718fcf95bf/azure-mgmt-policyinsights-0.5.0.zip"
    sha256 "ed229e3845c477e88dde413825d4fba0d38b3a5ffab4e694c7d0da995f3db0f3"
  end

  resource "azure-mgmt-privatedns" do
    url "https://files.pythonhosted.org/packages/1b/88/bd382d401e58b87df086f0218af94e7defd78f7cb300427eee3d25a9d7a1/azure-mgmt-privatedns-0.1.0.zip"
    sha256 "d29cfd8cec806e06673d9382d3f5766fc65d9a9de75b424705094a34a7db8d23"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/3a/df/3589cb655554dcf1e5c66c05e600c7f6719179d10b4203ead88e1d5b1246/azure-mgmt-rdbms-3.1.0rc1.zip"
    sha256 "c5b068d93996030e3485805cd4c28dd329584fc080d7fca6c66cf725af20e249"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https://files.pythonhosted.org/packages/7c/67/9857c8741d0ccbc4bd22af3350df974631c2b04a62e4fcbdb704bc05dae3/azure-mgmt-recoveryservices-0.4.0.zip"
    sha256 "e1e794760232239f8a9328d5de1740565ff70d1612a2921c9609746ba5671e6c"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/07/dc/f7609a3d6adbd6f4f79029ff16f23e9cc3853924e8a87d548fda59968023/azure-mgmt-recoveryservicesbackup-0.6.0.zip"
    sha256 "4df62479c90a6f93e7689f9d58e0a139899f0407f5e3298d5ce014442599428f"
  end

  resource "azure-mgmt-redhatopenshift" do
    url "https://files.pythonhosted.org/packages/28/9c/e93323b264196847b41e08dc7cfadfc91a7c1b4df1c5eb532261eaa717aa/azure-mgmt-redhatopenshift-0.1.0.zip"
    sha256 "565afbc63f5283f37c76135174f2ca20dd417da3e24b3fb1e132c4a0e2a2c5bc"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/cd/9e/24f97eb70f5ba0470f5206a88273ebd36752b4e02f56703912c3687cd082/azure-mgmt-redis-7.0.0rc2.zip"
    sha256 "9a412fa791ac2d7f5454886e3bd289511dc9ae374e4d5976648990fcdedc34be"
  end

  resource "azure-mgmt-relay" do
    url "https://files.pythonhosted.org/packages/df/76/f4673094df467c1198dfd944f8a800a25d0ed7f4bbd7c73e9e2605874576/azure-mgmt-relay-0.1.0.zip"
    sha256 "d9f987cf2998b8a354f331b2a71082c049193f1e1cd345812e14b9b821365acb"
  end

  resource "azure-mgmt-reservations" do
    url "https://files.pythonhosted.org/packages/97/0a/eb194a08fd35bda1e6b27ef227241ac36c8abb3bf3a201772c2777a74caf/azure-mgmt-reservations-0.6.0.zip"
    sha256 "83a9a70d6fd78b8b3e92ca64bbc1fde8d1bc5e2efea54076052c51c946b4cc9b"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/62/9d/3d6b0c9cfdb0fbb838788921393c68eeb7a4fd8738402dfbfc5a8db2636b/azure-mgmt-resource-10.3.0.zip"
    sha256 "1fca79db668ed98c1211d886babcf23de4e768d9403dffeea06e46c7692e69ad"
  end

  resource "azure-mgmt-search" do
    url "https://files.pythonhosted.org/packages/e7/9d/6aae72f83c1a30d6b0fb9b7892ddf150b8e6bc0f01a82e53c675877944aa/azure-mgmt-search-2.1.0.zip"
    sha256 "92a40a1a7a9e3a82b6fa302042799e8d5a67d3996c20835af72afc14f1610501"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/17/0b/2cbe5e7acde4d8bd234ebe9dff49dddaeb9a18ba369c6a56b81aabc77c33/azure-mgmt-security-0.4.1.zip"
    sha256 "391c8df5400485049a6c19d50e536304c186bb64fd569eec0c6d01d20220ee21"
  end

  resource "azure-mgmt-servicebus" do
    url "https://files.pythonhosted.org/packages/8f/bd/fdb9db085a1590ef13e683f3aa6462c6fe70fb1e61e69212017abe58b419/azure-mgmt-servicebus-0.6.0.zip"
    sha256 "f20920b8fb119ef4abeda4d2dac765a4fc48cd0bcf30c27f8c4cc6d890bc08b1"
  end

  resource "azure-mgmt-servicefabric" do
    url "https://files.pythonhosted.org/packages/12/fb/b10985ab709023472edf69ae058a8a1272e7d0a3525944204b36a2b29360/azure-mgmt-servicefabric-0.5.0.zip"
    sha256 "5771f24516c8d4a27f5569f23f3a606f6f106e4ad502eec7f38aedfcd3eadc74"
  end

  resource "azure-mgmt-signalr" do
    url "https://files.pythonhosted.org/packages/84/9e/3dfd91f786df6fdfe9938a201695793484782ea412234b24392b232e500c/azure-mgmt-signalr-0.4.0.zip"
    sha256 "6503ddda9d6f4b634dfeb8eb4bcd14ede5e0900585f6c83bf9010cf82215c126"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/b9/1d/03ff2b35c2ae95f2eecedc659ea34656e95c9cf9ddc2065b12ac70994ffa/azure-mgmt-sql-0.21.0.zip"
    sha256 "7bf7a41d2e42532a00b5f41d3fc0512244451a35f038ac0a25c96ef2c5c04300"
  end

  resource "azure-mgmt-sqlvirtualmachine" do
    url "https://files.pythonhosted.org/packages/f6/03/efe8f2ea66d51a23d908ab08c6a7b5f55b43c16bafb8d703f69594c635cf/azure-mgmt-sqlvirtualmachine-0.5.0.zip"
    sha256 "b5a9423512a7b12844ac014366a1d53c81017a14f39676beedf004a532aa2aad"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/d9/9a/31529fb92dc5a8c0a0eae73a0e8af8696b1330f53799b93f0aa59566d674/azure-mgmt-storage-16.0.0.zip"
    sha256 "2f9d714d9722b1ef4bac6563676612e6e795c4e90f6f3cd323616fdadb0a99e5"
  end

  resource "azure-mgmt-synapse" do
    url "https://files.pythonhosted.org/packages/55/cb/ccd7fa24e714a5dbaef963bebacf65e2f46f38167041641f971fe170ffd5/azure-mgmt-synapse-0.5.0.zip"
    sha256 "4eb76230c38525b71eb1addefebd265bc3d9b68ba7ff60ce5356d39f68ed2837"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/14/98/6fb3bc67bb862b7bac2ea43108aa1648f72c8fa63de22ab1e58278224c43/azure-mgmt-trafficmanager-0.51.0.zip"
    sha256 "fc8ae77022cfe52fda4379a2f31e0b857574d536e41291a7b569b5c0f4104186"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/4a/d2/84d38f97d713e97e596b5b6dee9de3415fbc66cc0ab6dcb3aa66bdbdf00c/azure-mgmt-web-0.48.0.zip"
    sha256 "da0f9e3b57528c72a7bc92e3515413a4a4fdbc9626c26ac04b7551a7739a81ec"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/2c/3f/c55e896a3d37c7ce100a278ed298e43209f1e7ed6fceccae97654b8b9e44/azure-multiapi-storage-0.5.2.tar.gz"
    sha256 "ee9d7589bb61388b550766cf13571829af9ee86ebb75b068232fcec36a39c027"
  end

  resource "azure-nspkg" do
    url "https://files.pythonhosted.org/packages/39/31/b24f494eca22e0389ac2e81b1b734453f187b69c95f039aa202f6f798b84/azure-nspkg-3.0.2.zip"
    sha256 "e7d3cea6af63e667d87ba1ca4f8cd7cb4dfca678e4c55fc1cedb320760e39dd0"
  end

  resource "azure-storage-common" do
    url "https://files.pythonhosted.org/packages/ae/45/0d21c1543afd3a97c416298368e06df158dfb4740da0e646a99dab6080de/azure-storage-common-1.4.2.tar.gz"
    sha256 "4ec87c7537d457ec95252e0e46477e2c1ccf33774ffefd05d8544682cb0ae401"
  end

  resource "azure-synapse-accesscontrol" do
    url "https://files.pythonhosted.org/packages/3d/82/b2824ba944ba17971a0a3cc32ee7ba97b9ffee2d3b398a9ac1d11d36b03f/azure-synapse-accesscontrol-0.2.0.zip"
    sha256 "ab40dbfbf2f88ffbfaca9c466a56a34177452159791e66f89a09f89761c64de7"
  end

  resource "azure-synapse-artifacts" do
    url "https://files.pythonhosted.org/packages/20/69/4ac19875b86210bfeb18f9e0aa64a233a74f5c93177b4ca56038a7e7fe19/azure-synapse-artifacts-0.3.0.zip"
    sha256 "2a705b4a89cea8e67c2189b9be7153662cd73073c3c15bcee5033a9378fd835c"
  end

  resource "azure-synapse-spark" do
    url "https://files.pythonhosted.org/packages/76/be/1a645ecf2b8215e2753d115e163b8c0fa0a4d9fec02f24486e7f9993c212/azure-synapse-spark-0.2.0.zip"
    sha256 "390e5bae1c1e108aed37688fe08e4d69c742f6ddd852218856186a4acdc532e2"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/56/3b/78c6816918fdf2405d62c98e48589112669f36711e50158a0c15d804c30d/cryptography-2.9.2.tar.gz"
    sha256 "a0c30272fb4ddda5f5ffc1089d7405b7a71b0b0f51993cb4e5dbb4590b2fc229"
  end

  resource "fabric" do
    url "https://files.pythonhosted.org/packages/f9/14/e81b9425d450de0f34d8c49b46133aa5554a7f4f1f1f2e7857e66dfa270b/fabric-2.5.0.tar.gz"
    sha256 "24842d7d51556adcabd885ac3cf5e1df73fc622a1708bf3667bf5927576cdfa6"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/6c/19/8e3b4c6fa7cca4788817db398c05274d98ecc6a35e0eaad2846fde90c863/humanfriendly-8.2.tar.gz"
    sha256 "bf52ec91244819c780341a3438d5d7b09f431d3f113a475147ac9b7b167a3d12"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/b6/08/b345475cfaaa542ae78a172d5b23979ad0577f15a32b16e5e54b2a7e80c6/invoke-1.4.1.tar.gz"
    sha256 "de3f23bfe669e3db1085789fd859eb8ca8e0c5d9c20811e2407fa042e8a5e15d"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "javaproperties" do
    url "https://files.pythonhosted.org/packages/db/43/58b89453727acdcf07298fe0f037e45b3988e5dcc78af5dce6881d0d2c5e/javaproperties-0.5.1.tar.gz"
    sha256 "2b0237b054af4d24c74f54734b7d997ca040209a1820e96fb4a82625f7bd40cf"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsmin" do
    url "https://files.pythonhosted.org/packages/17/73/615d1267a82ed26cd7c124108c3c61169d8e40c36d393883eaee3a561852/jsmin-2.2.2.tar.gz"
    sha256 "b6df99b2cd1c75d9d342e4335b535789b8da9107ec748212706ef7bbe5c2553b"
  end

  resource "jsondiff" do
    url "https://files.pythonhosted.org/packages/64/5c/2b4b0ae4d42cb1b0b1a89ab1c4d9fe02c72461e33a5d02009aa700574943/jsondiff-1.2.0.tar.gz"
    sha256 "34941bc431d10aa15828afe1cbb644977a114e75eef6cc74fb58951312326303"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/26/19/d59ed5e8bea6cbdc53c851eb5aca56b756a9e73566010cc566851172ad00/knack-0.7.2.tar.gz"
    sha256 "dfc6aef6760ea9a9620577e01540617678d78cab3111a0f03e8b9f987d0f08ca"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/e2/be/3ea39a8fd4ed3f9a25aae18a1bff2df7a610bca93c8ede7475e32d8b73a0/mock-4.0.3.tar.gz"
    sha256 "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/5c/9e/f34e9823b1dcb8fef1828d52e348761d4d0ac5a0a50b04a1f3e605aea4a4/msal-1.0.0.tar.gz"
    sha256 "ecbe3f5ac77facad16abf08eb9d8562af3bc7184be5d4d90c9ef4db5bde26340"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/7c/9d/a0294d164cdba0098846dcd4d6c2b880d768d0fc013d82378a9f291ff1f9/msal-extensions-0.1.3.tar.gz"
    sha256 "59e171a9a4baacdbf001c66915efeaef372fb424421f1a4397115a3ddd6205dc"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/6f/ad/fc4dc6c53ec8db010e9acbb1cb6c2626bed9a6646fc5a3383d171affb375/msrest-0.6.19.tar.gz"
    sha256 "55f8c3940bc5dc609f8cf9fcd639444716cc212a943606756272e0d0017bbb5b"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/48/fc/5c2940301a83f18884a8e3aead2b2ff177a1a373f75c7b17e2e404199b2a/msrestazure-0.6.4.tar.gz"
    sha256 "a06f0dabc9a6f5efe3b6add4bd8fb623aeadacf816b7a35b0f89107e0544d189"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/30/e3/5b17405ee8c8a78b5ae6ede4c5f296bebd97eb5982b28bbe37d61802bbc5/pkginfo-1.6.1.tar.gz"
    sha256 "a6a4ac943b496745cec21f14f021bbd869d5e9b4f6ec06918cffea5a2f4b9193"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/31/e3/b75d97109c793db0e23bcad15ab642da7517fe8dd6ad31567ed66ff51760/portalocker-1.7.1.tar.gz"
    sha256 "6d6f5de5a3e68c4dd65a98ec1babb26d28ccc5e770e07b672d65d5a35e4b2d8a"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/29/60/8ff9dcb5eac7f4da327ba9ecb74e1ad783b2d32423c06ef599e48c79b1e1/Pygments-2.7.3.tar.gz"
    sha256 "ccf3acacf3782cbed4a989426012f1c535c9a90d3a7fc3f16d231b9372d2b716"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/2f/38/ff37a24c0243c5f45f5798bd120c0f873eeed073994133c084e1cf13b95c/PyJWT-1.7.1.tar.gz"
    sha256 "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/4b/13/5521fdbfe26e0aa4aa04b9133c0dd5450a50e4aee5be44461d448e57560e/pyOpenSSL-17.1.0.tar.gz"
    sha256 "5a20a51d35104cd234d056861ace3e7a335aaf1f47fc96726c9e20ac1dc49563"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/df/d5/3e3ff673e8f3096921b3f1b79ce04b832e0100b4741573154b72b756a681/pytz-2019.1.tar.gz"
    sha256 "d747dd3d23d77ef44c6a3526e274af6efeb0a6f1afd5a69ba4d5be4098c8e141"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/31/ea/957c864e8f0aafab52edfd18bbaacf342a1935ba3a5cb6b5704a1738ebac/scp-0.13.3.tar.gz"
    sha256 "8bd748293d7362073169b96ce4b8c4f93bcc62cfc5f7e1d949e01e406a025bd4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sshtunnel" do
    url "https://files.pythonhosted.org/packages/c5/5c/4b320d7ec4b0d5d4d6df1fdf66a5799625b3623d0ce4efe81719c6f8dfb3/sshtunnel-0.1.5.tar.gz"
    sha256 "c813fdcda8e81c3936ffeac47cb69cfb2d1f5e77ad0de656c6dab56aeebd9249"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  resource "vsts" do
    url "https://files.pythonhosted.org/packages/ce/fa/4405cdb2a6b0476a94b24254cdfb1df7ff43138a91ccc79cd6fc877177af/vsts-0.1.25.tar.gz"
    sha256 "da179160121f5b38be061dbff29cd2b60d5d029b2207102454d77a7114e64f97"
  end

  resource "vsts-cd-manager" do
    url "https://files.pythonhosted.org/packages/fc/cd/29c798a92d5f7a718711e4beace03612c93ad7ec2121aea606d8abae38ee/vsts-cd-manager-1.0.2.tar.gz"
    sha256 "0bb09059cd553e1c206e92ef324cb0dcf92334846d646c44c684f6256b86447b"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/c5/01/8c9c7de6c46f88e70b5a3276c791a2be82ae83d8e0d0cc030525ee2866fd/websocket_client-0.56.0.tar.gz"
    sha256 "1fd5520878b68b84b5748bb30e592b10d0a91529d5383f74f4964e72b297fd3a"
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
    ]

    # Install CLI
    components.each do |item|
      cd item do
        venv.pip_install item
      end
    end

    (bin/"az").write <<~EOS
      #!/usr/bin/env bash
      AZ_INSTALLER=HOMEBREW #{libexec}/bin/python -m azure.cli \"$@\"
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
