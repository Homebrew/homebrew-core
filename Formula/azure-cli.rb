class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://github.com/Azure/azure-cli/archive/azure-cli-2.37.0.tar.gz"
  sha256 "757f30e2450df32847815785c3cbeac9a641d10911e2082a8534999a477d5e57"
  license "MIT"
  head "https://github.com/Azure/azure-cli.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/azure-cli[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9286a5d0952e678bd48cef023bf2fa652736bb5f5496f5a9fc352fa70e6f992b"
    sha256 cellar: :any,                 arm64_big_sur:  "90f35d43d3f21ded1e940c0de9cdeff29ac0b9498d034d87e0839b49aaf19191"
    sha256 cellar: :any,                 monterey:       "333614fc8702997c352302d9a54e5e2fe0da9961a46925164982dd62d438e301"
    sha256 cellar: :any,                 big_sur:        "c70d057b648017d0c3030206ae57e188eff584dd91e21da94a9b33f580f05963"
    sha256 cellar: :any,                 catalina:       "48e76464b0b2fe5eea80ae9cce8620144dbe21b9f1cd8a1e73cbb9c51f7759b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fa31fd7879df8934244a3996b4a13f04da4dd3b7d7b74e7c598380bbf00b25"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/c8/d1/e412abc2a358a6b9334250629565fe12697ca1cdee4826239eddf944ddd0/Deprecated-1.2.13.tar.gz"
    sha256 "43ac5335da90c31c24ba028af536a91d41d53f9e6901ddb021bcc572ce44e38d"
  end

  resource "Fabric" do
    url "https://files.pythonhosted.org/packages/cf/3c/19f930f9e74c417e2c617055ceb2be6aee439ac68e07b7d3b3119a417191/fabric-2.4.0.tar.gz"
    sha256 "93684ceaac92e0b78faae551297e29c48370cede12ff0f853cdebf67d4b87068"
  end

  resource "PyGithub" do
    url "https://files.pythonhosted.org/packages/98/36/386d282903c572b18abc36de68aaf4146db4659c82dceee009ef88a86b67/PyGithub-1.55.tar.gz"
    sha256 "1bbfff9372047ff3f21d5cd8e07720f3dbfdaf6462fcaed9d815f528f1ba7283"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/f5/02/b831bf3281723b81eb6b041d91d2c219123366f975ec0a73556620773417/applicationinsights-0.11.9.tar.gz"
    sha256 "30a11aafacea34f8b160fbdc35254c9029c7e325267874e3c68f6bdbcd6ed2c3"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/43/61/345856864a72ccc004bea5f74183c58bfd6675f9eab931ff9ce21a8fe06b/argcomplete-1.11.1.tar.gz"
    sha256 "5ae7b601be17bf38a749ec06aa07fb04e7b6b5fc17906948dc1866e7facf3740"
  end

  resource "azure-appconfiguration" do
    url "https://files.pythonhosted.org/packages/21/0a/1b24d1b3c1477b849d48aa29dcde3141c1524fab293042493f3432b672c2/azure-appconfiguration-1.1.1.zip"
    sha256 "b83cd2cb63d93225de84e27abbfc059212f8de27766f4c58dd3abb839dff0be4"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/31/0a/20b7fc1b50e12834fea4f64c0a41676fca386885d47ebdb9223d4c71e972/azure-batch-12.0.0.zip"
    sha256 "1a9b1e178984a7bf495af67bcce51f0db1e4a8a957afb29e33554a14a9674deb"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/99/33/fe8ffd51ed08a2b77d34b6a997f8e3e884a6e08f08f9626c9969d930fd3c/azure-common-1.1.22.zip"
    sha256 "c8e4a7bf15f139f779a415d2d3c371738b1e9f5e14abd9c18af6b9bed3babf35"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/89/79/5e937f85e0e2876539a3bff63a6b89e516f4e093e2c46e60aad8216acb31/azure-core-1.21.1.zip"
    sha256 "88d2db5cf9a135a7287dc45fdde6b96f9ca62c9567512a3bb3e20e322ce7deb2"
  end

  resource "azure-cosmos" do
    url "https://files.pythonhosted.org/packages/3c/d3/f74bf55c48851944b726cb36883c68d3c4bb887fb2196f216ca543c691e1/azure-cosmos-3.2.0.tar.gz"
    sha256 "4f77cc558fecffac04377ba758ac4e23f076dc1c54e2cf2515f85bc15cbde5c6"
  end

  resource "azure-data-tables" do
    url "https://files.pythonhosted.org/packages/8b/0c/bc5ca41bcfeb1ce3a7e870084abc257463be521da27c27409f4b502f4739/azure-data-tables-12.4.0.zip"
    sha256 "dd5fc8de91e2f8908efa4c64ca7f63cf83b3068a9ba426298de3b54139e9665c"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/39/9d/8acff66e50186e64347b96268b6763a47c632d0240fd46b5e04d86656de7/azure-datalake-store-0.0.49.tar.gz"
    sha256 "3fcede6255cc9cd083d498c3a399b422f35f804c561bb369a7150ff1f2f07da9"
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
    url "https://files.pythonhosted.org/packages/0d/3b/b43b361f9b1383d00943b2a0315c7e8c66040b8d0f827321d21f45446556/azure-keyvault-administration-4.0.0b3.zip"
    sha256 "777b4958e6ccde9951babcdfa96987927e42a952fd7a441f9fd01e0dcfcac4b4"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/1d/e9/4b79049594b922741f9424078bcfd98f3d33cad7f6bd162a89b0c6c23129/azure-keyvault-keys-4.5.1.zip"
    sha256 "da88e71fec92a14fb58cec8868abf7eba040188dcdce369ce1050add196586f6"
  end

  resource "azure-loganalytics" do
    url "https://files.pythonhosted.org/packages/7a/37/6d296ee71319f49a93ea87698da2c5326105d005267d58fb00cb9ec0c3f8/azure-loganalytics-0.1.0.zip"
    sha256 "3ceb350def677a351f34b0a0d1637df6be0c6fe87ff32a5270b17f540f6da06e"
  end

  resource "azure-mgmt-advisor" do
    url "https://files.pythonhosted.org/packages/34/96/e28b949dd55e1fc381fae2676c95c8a9410fa4b9768cc02ec3668fc490c4/azure-mgmt-advisor-9.0.0.zip"
    sha256 "fc408b37315fe84781b519124f8cb1b8ac10b2f4241e439d0d3e25fd6ca18d7b"
  end

  resource "azure-mgmt-apimanagement" do
    url "https://files.pythonhosted.org/packages/39/91/b46486cd5e74e19028f4cde54aba6c2e150d92d13963b5f9944e5171eef9/azure-mgmt-apimanagement-3.0.0.zip"
    sha256 "9262f54ed387eb083d8dae66d32a8df35647319b902bd498cdc376f50a12d154"
  end

  resource "azure-mgmt-appconfiguration" do
    url "https://files.pythonhosted.org/packages/58/ff/a8b04edfcc2d22fc9bd2d18402d188cab1fcb60701e29d52bef5a43d9804/azure-mgmt-appconfiguration-2.1.0b2.zip"
    sha256 "ff0fa423fb52368d2f5b964570c8d118f3eb98dc196c52ca6ca5646e5650e856"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https://files.pythonhosted.org/packages/04/d6/31fdc6bc6cebfbf66e12e8a5556e5f7bda7f7ec57367ec9d8025df62560a/azure-mgmt-applicationinsights-1.0.0.zip"
    sha256 "c287a2c7def4de19f92c0c31ba02867fac6f5b8df71b5dbdab19288bb455fc5b"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/8d/e7/193801d2a703c1892bae98c2d517308a4711c63d0fc2d693df74fca43a26/azure-mgmt-authorization-0.61.0.zip"
    sha256 "f5cceea3add04e9445ea88492f15eecf6c126f0406d967c95f6e48b79be8db75"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/57/09/7280a4d11f1e28f6ad4e29bbe67fa08ee9f3acc01e19ebad5301589a6ad7/azure-mgmt-batch-16.1.0.zip"
    sha256 "f49d15437b80b22e24b847bd506e31a5c115d5273e9e48c40a055fcc6ee3e639"
  end

  resource "azure-mgmt-batchai" do
    url "https://files.pythonhosted.org/packages/80/8b/ed14bdce18c5f7a54dde2d4717f7bfb4bf1546b7b380d2af0af6cb11a999/azure-mgmt-batchai-7.0.0b1.zip"
    sha256 "993eafbe359bab445642276e811db6f44f09795122a1b3c3dd703f9c333723a6"
  end

  resource "azure-mgmt-billing" do
    url "https://files.pythonhosted.org/packages/b0/40/59a55614cc987457efe35c2055a7c5d8757f9cb5207010cb1d3ddf382edd/azure-mgmt-billing-6.0.0.zip"
    sha256 "d4f5c5a4188a456fe1eb32b6c45f55ca2069c74be41eb76921840b39f2f5c07f"
  end

  resource "azure-mgmt-botservice" do
    url "https://files.pythonhosted.org/packages/2c/38/6ec85a038ea48d9408351d49331dcc644bccf75d6f43e564933a74ba63c9/azure-mgmt-botservice-0.3.0.zip"
    sha256 "f8318878a66a0685a01bf27b7d1409c44eb90eb72b0a616c1a2455c72330f2f1"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/d7/fc/48310b510043223c42ea2f9ac1e91a9a88b7438c0882d4c32db9f0b9fb0c/azure-mgmt-cdn-12.0.0.zip"
    sha256 "b7c3ee2189234b4af51ace2924927c5fd733f3de748a642d6d5040067c8c9ddd"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/25/c4/1ba46b74e2c0baf2b48eb1e0c66f39830bfeefbdeb1273ea877401fad967/azure-mgmt-cognitiveservices-13.1.0.zip"
    sha256 "1574bcdf8bf9b831a2106710308bfd89a1f185f716f6e6375665fb97dd537e3e"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/7a/30/da24d8bb9a87cfbb3565b7dd751b6f0c5956abb2259ba0596a8f1217f710/azure-mgmt-compute-27.0.0.zip"
    sha256 "9fe31027465e43f8724b61bc0ab342b68c5bbdc7eb2179a7e0b5c1fd5e895d3d"
  end

  resource "azure-mgmt-consumption" do
    url "https://files.pythonhosted.org/packages/8c/f0/e2d94b246e2dce71eff8d362836a1979f02b4185f5403a13e4fb26c07ccb/azure-mgmt-consumption-2.0.0.zip"
    sha256 "9a85a89f30f224d261749be20b4616a0eb8948586f7f0f20573b8ea32f265189"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/3b/bc/21b2b701389e8e59aaa9f08c12ed2b6cead9a3a5ad0ef6cf07aed58a5557/azure-mgmt-containerinstance-9.1.0.zip"
    sha256 "22164b0c59138b37bc48ba6d476bf635152bc428dcb420b521a14b8c25c797ad"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/0d/22/3ae65ee96ccff2362c2836b9ad5c58051dc0b9e0f3752316607d064aba4e/azure-mgmt-containerregistry-8.2.0.zip"
    sha256 "f2bcdbcf0b9fdc2df0df9eccb77cb489091d3c670ed53cba77e5ffd734e9539b"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/94/4a/7ff0605883e68b1a65cbcffd13e0b4356f9351c55dffdaee1a7c5f71d230/azure-mgmt-containerservice-19.1.0.zip"
    sha256 "b74e827acc6f8e4df5683c645f6623d15cc5b9b59b880736e8bccd4c881512ab"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/b8/d1/924eed2ee15100f288b2c349e32bceacda1f7783ad07d4e5893b029660b0/azure-mgmt-core-1.3.0.zip"
    sha256 "3ffb7352b39e5495dccc2d2b47254f4d82747aff4735e8bf3267c335b0c9bb40"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/23/d4/e5d7c99c5e3029ed703bf250eef9803cac069175457f33bf3992e5a7bf4b/azure-mgmt-cosmosdb-7.0.0b2.zip"
    sha256 "855bd85bd8247d354cc22b3721d0f4257603c5d29ccb2cc8171de1364ed530b2"
  end

  resource "azure-mgmt-databoxedge" do
    url "https://files.pythonhosted.org/packages/bc/97/e6f9041c0e22cdf3fa8f5ccfec70daf0d1c15740bc5f36e8e9694ff98a98/azure-mgmt-databoxedge-1.0.0.zip"
    sha256 "04090062bc1e8f00c2f45315a3bceb0fb3b3479ec1474d71b88342e13499b087"
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
    url "https://files.pythonhosted.org/packages/06/47/cccd2c22f8f525b8a1c38fd88ffef7ae989f50bd15f1ad5b955e27ef5985/azure-mgmt-datamigration-10.0.0.zip"
    sha256 "5cee70f97fe3a093c3cb70c2a190c2df936b772e94a09ef7e3deb1ed177c9f32"
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
    url "https://files.pythonhosted.org/packages/58/04/a2849bf2e2a5e115666dfa50e7ca551e75fa39d0f9bfe83f0bdb7d7e4765/azure-mgmt-dns-8.0.0.zip"
    sha256 "407c2dacb33513ffbe9ca4be5addb5e9d4bae0cb7efa613c3f7d531ef7bf8de8"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/c4/d4/081833d711a1e7e5159febc0351ff4b72800d3a6fe4c1961ceeecb9b29f9/azure-mgmt-eventgrid-9.0.0.zip"
    sha256 "aecbb69ecb010126c03668ca7c9a2be8e965568f5b560f0e7b5bc152b157b510"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/5c/0a/846685a56bc434c294df5573908a94946cf4c3a01c06d4726b29976257f3/azure-mgmt-eventhub-10.0.0.zip"
    sha256 "0856574ef4b73bbbc62834051061e2081400aba7e3715e10ef5181d639e86a0b"
  end

  resource "azure-mgmt-extendedlocation" do
    url "https://files.pythonhosted.org/packages/b7/de/a7b62f053597506e01641c68e1708222f01cd7574e4147d4f645ff6e6aaa/azure-mgmt-extendedlocation-1.0.0b2.zip"
    sha256 "9a37c7df94fcd4943dee35601255a667c3f93305d5c5942ffd024a34b4b74fc0"
  end

  resource "azure-mgmt-hdinsight" do
    url "https://files.pythonhosted.org/packages/2a/cf/f163054cdebc0eb4c17a6e805c3523dc4b6e22a8cb649f3389c762a4f1a3/azure-mgmt-hdinsight-9.0.0.zip"
    sha256 "41ebdc69c0d1f81d25dd30438c14fff4331f66639f55805b918b9649eaffe78a"
  end

  resource "azure-mgmt-imagebuilder" do
    url "https://files.pythonhosted.org/packages/d1/7f/f40960952f7cf175a2f75ac83b75e0ca5803bf847111537431837557c7b7/azure-mgmt-imagebuilder-1.0.0.zip"
    sha256 "634e398de9a23e712aa27a4a59f9ea5d5091d1dfcfed5ac977230918872c4430"
  end

  resource "azure-mgmt-iotcentral" do
    url "https://files.pythonhosted.org/packages/9e/9e/50b30ad35c0038ce93ccf80535d2052967dc0dedae0eee84d2dc81458614/azure-mgmt-iotcentral-10.0.0b1.zip"
    sha256 "d42899b935d88486fbe1e1906542471f3a2f60d9e755ddd876ed540b2d81bb4d"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/4c/ff/8c0c9c96ecb3c813513e38d9e4952415641d24cbcdf69bdc3d3ef428a164/azure-mgmt-iothub-2.2.0.zip"
    sha256 "9ec01e561b3937c6e9c187a7991c099aa17f200ab3fee952a1821e394e65d1e3"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https://files.pythonhosted.org/packages/47/78/b5252f7e42d596d0e8ab4d7ea5f90545436d83c4bf45f1e86d7618d128db/azure-mgmt-iothubprovisioningservices-1.1.0.zip"
    sha256 "d383a826e7dff772fad86e88a33a661e911a51b1c71c3ea72a590c1d5a09bc9e"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/cd/34/6091d8d2ad740cee9db16c6347cd1a315a4df470f08cfdfc0a958630e183/azure-mgmt-keyvault-9.3.0.zip"
    sha256 "54156422e618b686d52232a7989594b240bd18afd0fa381e12e4772ed4ab5ea8"
  end

  resource "azure-mgmt-kusto" do
    url "https://files.pythonhosted.org/packages/0d/79/887c8f71d7ebd87e4f2359f6726a0a881f1c9369167bf075bf22ba39751c/azure-mgmt-kusto-0.3.0.zip"
    sha256 "9eb8b7781fd4410ee9e207cd0c3983baf9e58414b5b4a18849d09856e36bacde"
  end

  resource "azure-mgmt-loganalytics" do
    url "https://files.pythonhosted.org/packages/da/3f/c784b29431b597d11fdcdb6b430d114819459eb34da190fceff5a70901cd/azure-mgmt-loganalytics-13.0.0b4.zip"
    sha256 "266d6deefe6fc858cd34cfdebd568423db1724a370264e97017b894914a72879"
  end

  resource "azure-mgmt-managedservices" do
    url "https://files.pythonhosted.org/packages/f8/db/faab14079c628202d771a2bc33016326de6d194d1460fd8e531a59664371/azure-mgmt-managedservices-1.0.0.zip"
    sha256 "fed8399fc6773aada37c1d0496a46f59410d77c9494d0ca5967c531c3376ad19"
  end

  resource "azure-mgmt-managementgroups" do
    url "https://files.pythonhosted.org/packages/b3/e7/74159d9cd15966031ba03a92e0b53c6b0cc895bb5fdb7374fc326fb9dd21/azure-mgmt-managementgroups-1.0.0.zip"
    sha256 "bab9bd532a1c34557f5b0ab9950e431e3f00bb96e8a3ce66df0f6ce2ae19cd73"
  end

  resource "azure-mgmt-maps" do
    url "https://files.pythonhosted.org/packages/c2/d1/35d471f400b612b38473ffa7747ba5fa2f79f47e410009fb887db19a4e8a/azure-mgmt-maps-2.0.0.zip"
    sha256 "384e17f76a68b700a4f988478945c3a9721711c0400725afdfcb63cf84e85f0e"
  end

  resource "azure-mgmt-marketplaceordering" do
    url "https://files.pythonhosted.org/packages/17/9c/74d7746672a4e9ac6136e3043078a2f4d0a0e3568daf2de772de8e4d7cff/azure-mgmt-marketplaceordering-1.1.0.zip"
    sha256 "68b381f52a4df4435dacad5a97e1c59ac4c981f667dcca8f9d04453417d60ad8"
  end

  resource "azure-mgmt-media" do
    url "https://files.pythonhosted.org/packages/54/97/90167348963e7544be9984866712dadaae665d91d0f4fbbae6cddf5875ba/azure-mgmt-media-9.0.0.zip"
    sha256 "4c8ee5f2c490d905203ea884dc2bbf17aed69daf8a1db412ddfb888ce6fde593"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/85/88/9c2a2450804cd247b061275228e5c5175f30ad272c1521aa3553e73a18f7/azure-mgmt-monitor-3.0.0.zip"
    sha256 "91ddb7333bf2b9541a53864cc8d2501e3694a03a9c0e41cbfae3348558675ce6"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/7b/8d/b6c51da42e364bac683dfcb5dc20d529f21742b6385bf4bdc27d99f272c2/azure-mgmt-msi-6.0.1.zip"
    sha256 "3cf910994a01909f12bbb87d1b6fedf1d572fcf4f7b826198e57fbd1f9d8daf5"
  end

  resource "azure-mgmt-netapp" do
    url "https://files.pythonhosted.org/packages/f3/6c/17bb637577121e09a8b14db5448f3cb7c4d5f9b78f597de68ee68642f334/azure-mgmt-netapp-7.0.0.zip"
    sha256 "ce269d746fba3283c6d7c39867243d1d1c7c9df1accf651b58f0b5a5669c2ada"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/8c/c4/7ecb49ac70bc7f2ca73ffa69de63183d95716c642de0823294567a2e42bc/azure-mgmt-network-20.0.0.zip"
    sha256 "9a78cfc82009fab94d819e2e9926237d555583cdc4a1b65863fceea720e37686"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/c4/d4/a9a140ee15abd8b0a542c0d31b7212acf173582c10323b09380c79a1178b/azure-mgmt-nspkg-3.0.2.zip"
    sha256 "8b2287f671529505b296005e6de9150b074344c2c7d1c805b3f053d081d58c52"
  end

  resource "azure-mgmt-policyinsights" do
    url "https://files.pythonhosted.org/packages/15/08/572e5907cececdf3976493f55d1970e0492fdaad85678a8058035a26ed8b/azure-mgmt-policyinsights-1.1.0b2.zip"
    sha256 "7be23931d6db5fb5a1c470a3d44af2df3d9652b26da56183d5b84b6ea45e6f9f"
  end

  resource "azure-mgmt-privatedns" do
    url "https://files.pythonhosted.org/packages/72/f0/e8e401da635a72936c7edc32d4fdb7fcc4572400e0d66ed6ff6978b935a9/azure-mgmt-privatedns-1.0.0.zip"
    sha256 "b60f16e43f7b291582c5f57bae1b083096d8303e9d9958e2c29227a55cc27c45"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/8c/94/4660d6c92128dc8a01c716b266ac590bb8c84def9a0ff06db4258a16cfac/azure-mgmt-rdbms-10.0.0.zip"
    sha256 "bdc479b3bbcac423943d63e746a81dd5fc80b46a4dbb4393e760016e3fa4f74a"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https://files.pythonhosted.org/packages/1c/e6/e36d27dcfe788e426cd9a4828b3e49f75a755d3fca6b5e9f78a2b407c4a1/azure-mgmt-recoveryservices-2.0.0.zip"
    sha256 "a7d3137d5c460f50ac2d44061d60a70b4f2779d4ca844b77419b5725e65e09be"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/20/65/3514e4b6820abf4d2df2bd2de2eed4352c7b035dafa9e31aa454c194a885/azure-mgmt-recoveryservicesbackup-5.0.0.zip"
    sha256 "05c880dec1728dae71a3dc92dd6560942ef7cbc8137f0f147a3744cdb0f81d81"
  end

  resource "azure-mgmt-redhatopenshift" do
    url "https://files.pythonhosted.org/packages/28/20/ec5e7a3174f2fd48331a61358e9a0c7aea1b9a519a455de4de361f17c914/azure-mgmt-redhatopenshift-1.1.0.zip"
    sha256 "4eaf21ddfbda8f1206d908ed0b21c240313675e0438a8c4b2da4107a4fcedb85"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/b8/42/4ba027854d4ebcc4e7414d8b9b4fefceaea80e43a5163bfb757ceeaf38f9/azure-mgmt-redis-13.1.0.zip"
    sha256 "ece913e5fc7f157e945809e557443f79ff7691cabca4bbc5ecb266352f843179"
  end

  resource "azure-mgmt-relay" do
    url "https://files.pythonhosted.org/packages/df/76/f4673094df467c1198dfd944f8a800a25d0ed7f4bbd7c73e9e2605874576/azure-mgmt-relay-0.1.0.zip"
    sha256 "d9f987cf2998b8a354f331b2a71082c049193f1e1cd345812e14b9b821365acb"
  end

  resource "azure-mgmt-reservations" do
    url "https://files.pythonhosted.org/packages/90/af/9b60d1fe383d6724291ebeefd3e2f6f63cbda6744659937efc6f189a6f4a/azure-mgmt-reservations-2.0.0.zip"
    sha256 "e6f5dd5e246e6e7ccf938b9315e34747aaf08874866de511117f5e5b5a6a0b71"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/2b/52/d64e8f1c293b848e9cfa108948d59ec1bf9c1ea54d87fc79a5c89f9e2d7d/azure-mgmt-resource-21.1.0b1.zip"
    sha256 "a220b993e320f4a267f78d233311b8001f4fa26fadfc3591039291bfc1ced072"
  end

  resource "azure-mgmt-search" do
    url "https://files.pythonhosted.org/packages/fe/ad/39e9f7c32b6656c3e76a9b7a097678ed7dee0ecd19dee1e661c8270a39c0/azure-mgmt-search-8.0.0.zip"
    sha256 "a96d50c88507233a293e757202deead980c67808f432b8e897c4df1ca088da7e"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/c3/eb/bb9ce31935a75fe407eba63641cd25555b0fe47adeffc470ecafab5fc9a5/azure-mgmt-security-2.0.0b1.zip"
    sha256 "f0ab1ad3cc3c11e644297224d80438cc70a67ef4c3c3357f93d23aec256eb084"
  end

  resource "azure-mgmt-servicebus" do
    url "https://files.pythonhosted.org/packages/87/8a/aee8940560ed582b604c52b70085355e99443eb2ee2b03fe9929a22e2611/azure-mgmt-servicebus-7.1.0.zip"
    sha256 "d8ae7905fb7d3e24822daa20aa7bc5014f41aa18b48ea2d0161e997fc11a3d36"
  end

  resource "azure-mgmt-servicefabric" do
    url "https://files.pythonhosted.org/packages/9a/31/5fca9db5f21aeb733dfbe24ca67fdf320776197833ce6bcca17323260158/azure-mgmt-servicefabric-1.0.0.zip"
    sha256 "de35e117912832c1a9e93109a8d24cab94f55703a9087b2eb1c5b0655b3b1913"
  end

  resource "azure-mgmt-servicefabricmanagedclusters" do
    url "https://files.pythonhosted.org/packages/0c/94/fd20fa0fa04919c015fa7376b16d9f4be04c05b15d0d5137fc0013842687/azure-mgmt-servicefabricmanagedclusters-1.0.0.zip"
    sha256 "109ca3a251ebb7ddb35a0f8829614a4daa7065a16bc13b52c8422ee7f9995ce8"
  end

  resource "azure-mgmt-servicelinker" do
    url "https://files.pythonhosted.org/packages/85/19/0bbb9184c21a52381b4c67334a98a57d0a3bbd517faafb01a28bf0256f20/azure-mgmt-servicelinker-1.0.0.zip"
    sha256 "9408e0c046b64c90c4514f29c1fc2453c1320356e12e4700bfef88e961dbed7b"
  end

  resource "azure-mgmt-signalr" do
    url "https://files.pythonhosted.org/packages/a6/e1/69d0e7f65a52ee5c98ce0c4c3b32776e5029ad1c0e82b2e810b698cb38d8/azure-mgmt-signalr-1.0.0b2.zip"
    sha256 "153c58f2aa228471b8399b8a4f7b1146529f3916c8a2a0eaba0f4aa3ee92f5dc"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/ba/4c/c9eedb10989b4bbde689529a937700bc740df959aeed54485c609268339e/azure-mgmt-sql-4.0.0b1.zip"
    sha256 "758937b2dbd01cdfd51194bc3810a9d086c6f20ea2207a4cacbc4259683b21df"
  end

  resource "azure-mgmt-sqlvirtualmachine" do
    url "https://files.pythonhosted.org/packages/8c/80/d254ccc09c8d4c908c724ad01e52c67486bd542154e078919ceb50ae6ac4/azure-mgmt-sqlvirtualmachine-1.0.0b2.zip"
    sha256 "ceab0bb9f8d498e975671bbc421633b042988284be9bc193a51c9d97b8ef5cc9"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/5b/d4/56060366fead4e2fcceb160447c5f5022c9c0f8a929e7e6425af6fe2ea60/azure-mgmt-storage-20.0.0.zip"
    sha256 "6ee476b5622ff6f5954edee6eb0d8dd427b3217022855adf1ec8633ca04cdee2"
  end

  resource "azure-mgmt-synapse" do
    url "https://files.pythonhosted.org/packages/bb/4a/46ff9dbcefbbbac75d53322f08a09d4fc434d2f1a36bc4e6f0ea9a1ce96d/azure-mgmt-synapse-2.1.0b2.zip"
    sha256 "fc1031283b6da7fb52fd7e39cbc5f82819b9ab1b4db955e1adce6a07703ec111"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/0f/f0/31bbc546d10254513905174e429e320f192f853159482f2bdc71b4623830/azure-mgmt-trafficmanager-1.0.0.zip"
    sha256 "4741761e80346c4edd4cb3f271368ea98063f804d015e245c2fe048ed2b596a8"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/c4/8d/833c5a82d8a6ad2d4ce25d52fbd4d71aee04f9c36fc32591daaabef114c5/azure-mgmt-web-6.1.0.zip"
    sha256 "c26635089276515b0488fcf014aab50a0446f54800c6e0e5583cc493ac8d738f"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/66/4a/06bf478867afd7fec1a109ba2b3bddf88766fc4a6f95fdc7771449702909/azure-multiapi-storage-0.9.0.tar.gz"
    sha256 "eeeabcb916773172351b2f8398c91154d57bb993f0ea3f2bf4a7e14bc77eb426"
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
    url "https://files.pythonhosted.org/packages/e9/fd/df10cfab13b3e715e51dd04077f55f95211c3bad325d59cda4c22fec67ea/azure-synapse-accesscontrol-0.5.0.zip"
    sha256 "835e324a2072a8f824246447f049c84493bd43a1f6bac4b914e78c090894bb04"
  end

  resource "azure-synapse-artifacts" do
    url "https://files.pythonhosted.org/packages/26/0b/7700182fd17e6d5d26efe643255fb275be6d8215cc145a5b1b2327475ccb/azure-synapse-artifacts-0.12.0.zip"
    sha256 "21f416b084ee4e1ce1f93460bfdf494ed703158de032ae4f8c02e4378989119a"
  end

  resource "azure-synapse-managedprivateendpoints" do
    url "https://files.pythonhosted.org/packages/ad/7a/4c944432ced6165550541cf0653f2cb76cb30c10247d7f1b717b7821a300/azure-synapse-managedprivateendpoints-0.3.0.zip"
    sha256 "7cdd48b99f5f8f181166feaa87d820eafe8a6299ca9577e7a0ba9f6420d7a116"
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
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/d4/85/38715448253404186029c575d559879912eb8a1c5d16ad9f25d35f7c4f4c/cryptography-3.3.2.tar.gz"
    sha256 "5a60d3780149e13b7a6ff7ad6526b38846354d11a15e21068e57073e29e19bed"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/b5/7e/ddfbd640ac9a82e60718558a3de7d5988a7d4648385cf00318f60a8b073a/distro-1.7.0.tar.gz"
    sha256 "151aeccf60c216402932b52e40ee477a939f8d58898927378a02abbe852c1c39"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
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

  resource "javaproperties" do
    url "https://files.pythonhosted.org/packages/db/43/58b89453727acdcf07298fe0f037e45b3988e5dcc78af5dce6881d0d2c5e/javaproperties-0.5.1.tar.gz"
    sha256 "2b0237b054af4d24c74f54734b7d997ca040209a1820e96fb4a82625f7bd40cf"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/5c/40/3bed01fc17e2bb1b02633efc29878dfa25da479ad19a69cfb11d2b88ea8e/jmespath-0.9.5.tar.gz"
    sha256 "cca55c8d153173e21baa59983015ad0daf603f9cb799904ff057bfb8ff8dc2d9"
  end

  resource "jsondiff" do
    url "https://files.pythonhosted.org/packages/dd/13/2b691afe0a90fb930a32b8fc1b0fd6b5bdeaed459a32c5a58dc6654342da/jsondiff-2.0.0.tar.gz"
    sha256 "2795844ef075ec8a2b8d385c4d59f5ea48b08e7180fce3cb2787be0db00b1fb4"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/da/9c/d04c32ecf37e0ed5a887b30058de4bb817791550462383e3473cc8527309/knack-0.9.0.tar.gz"
    sha256 "7fcab17585c0236885eaef311c01a1e626d84c982aabcac81703afda3f89c81f"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/82/cb/940dafe80e7d252579421cc5c5d3eeeab8909dc2c1328daf602ce9d9af44/msal-1.18.0b1.tar.gz"
    sha256 "9226038f35fbe7abae94b16be200ae2e75e09808beb365830869af910142f0ec"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/bb/2c/e8ac4f491efd412d097d42c9eaf79bcaad698ba17ab6572fd756eb6bd8f8/msrest-0.6.21.tar.gz"
    sha256 "72661bc7bedc2dc2040e8f170b6e9ef226ee6d3892e01affd4d26b06474d68d8"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/48/fc/5c2940301a83f18884a8e3aead2b2ff177a1a373f75c7b17e2e404199b2a/msrestazure-0.6.4.tar.gz"
    sha256 "a06f0dabc9a6f5efe3b6add4bd8fb623aeadacf816b7a35b0f89107e0544d189"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/ec/90/882f43232719f2ebfbdbe8b7c57fc9642a25b3df30cb70a3701ea22622de/oauthlib-3.0.1.tar.gz"
    sha256 "0ce32c5d989a1827e3f1148f98b9085ed2370fc939bf524c9c851d8714797298"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/97/bd/f66775642e1edf80ec530c27cc586353d94765f37a9583b5a68e4db9b96e/paramiko-2.10.1.tar.gz"
    sha256 "443f4da23ec24e9a9c0ea54017829c282abdda1d57110bf229360775ccd27a31"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/54/6a/42056522e1d79fa9768712782f37365ef786d905e4efeed6db44cad1803b/pkginfo-1.8.2.tar.gz"
    sha256 "542e0d0b6750e2e21c20179803e40ab50598d8066d51097a0e382cba9eb02bff"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/38/2e/32172e8418f2ba284cee4fd67cb547d39a7debb3eed37d514da173786112/portalocker-2.3.2.tar.gz"
    sha256 "75cfe02f702737f1726d83e04eedfa0bda2cc5b974b1ceafb8d6b42377efbd5f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/47/b6/ea8a7728f096a597f0032564e8013b705aa992a0990becd773dcc4d7b4a7/psutil-5.9.0.tar.gz"
    sha256 "869842dbd66bb80c3217158e629d6fceaecc3a3166d3d1faee515b05dd26ca25"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/0c/c6/3cdc7cb1289b35186fd7fd61836b6d83632ca0f7eee552516777361667b1/PyJWT-2.1.0.tar.gz"
    sha256 "fba44e7898bbca160a2b2b501f492824fc8382485d3a6f11ba5d0c1937ce6130"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc/pyOpenSSL-19.0.0.tar.gz"
    sha256 "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/de/a2/f55312dfe2f7a344d0d4044fdfae12ac8a24169dc668bd55f72b27090c32/requests-oauthlib-1.2.0.tar.gz"
    sha256 "bd6533330e8748e94bf0b214775fed487d309b8b8fe823dc45641ebcd9a32f57"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/05/e0/ac4169e773e12a08d941ca3c006cb8c91bee9d6d80328a15af850b5e7480/scp-0.13.2.tar.gz"
    sha256 "ef9d6e67c0331485d3db146bf9ee9baff8a48f3eb0e6c08276a8584b13bf34b3"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "sshtunnel" do
    url "https://files.pythonhosted.org/packages/c5/5c/4b320d7ec4b0d5d4d6df1fdf66a5799625b3623d0ce4efe81719c6f8dfb3/sshtunnel-0.1.5.tar.gz"
    sha256 "c813fdcda8e81c3936ffeac47cb69cfb2d1f5e77ad0de656c6dab56aeebd9249"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8d/12/cd10d050f7714ccc675b486cdcbbaed54c782a5b77da2bb82e5c7b31fb40/websocket-client-1.3.1.tar.gz"
    sha256 "6278a75065395418283f887de7c3beafb3aa68dada5cacbe4b214e8d26da499b"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    venv = virtualenv_create(libexec, "python3", system_site_packages: false)
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
