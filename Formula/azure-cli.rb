class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://github.com/Azure/azure-cli/archive/azure-cli-2.30.0.tar.gz"
  sha256 "fc95b8e85268c926b29fd7cb236dd0010f9fc82ed405761dd78ef56f3a78d6e7"
  license "MIT"
  revision 1
  head "https://github.com/Azure/azure-cli.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/azure-cli[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eba2c5bafd94831abc5613ecd24a1ce5fc9cedbb5b2737ee5ee05f2d57708d20"
    sha256 cellar: :any,                 arm64_big_sur:  "a68559a8e2a7dbfa66a14d2ca7cdc5efd76743c05d0cb564a273e7377a019c92"
    sha256 cellar: :any,                 monterey:       "24235c70ae640e482f525b2074a11fe1ba68880156ff5e26fda0d83449516185"
    sha256 cellar: :any,                 big_sur:        "cad2d1f606dd01d4ababe0d4990154308318eb4bdfce5024a9ec6533e83b2116"
    sha256 cellar: :any,                 catalina:       "9aaf2ac77f65be6e971c0a758b7037d6af991ec6ba97c41bd19c86e87d73eef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17d3567d894e88492052dfc6fe22fb652601b32c91c19c93714bffd0635db64"
  end

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
    url "https://files.pythonhosted.org/packages/29/14/8ac135ec7cc9db3f768e2d032776718c6b23f74e63543f0974b4873500b2/antlr4-python3-runtime-4.7.2.tar.gz"
    sha256 "168cdcec8fb9152e84a87ca6fd261b3d54c8f6358f42ab3b813b14a7193bb50b"
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
    url "https://files.pythonhosted.org/packages/25/f6/e4a2dca7aa85d62f85f28d84ee509b4524012cdf3ea3d879cdfbacbee6bd/azure-batch-11.0.0.zip"
    sha256 "ce5fdb0ec962eddfe85cd82205e9177cb0bbdb445265746e38b3bbbf1f16dc73"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/99/33/fe8ffd51ed08a2b77d34b6a997f8e3e884a6e08f08f9626c9969d930fd3c/azure-common-1.1.22.zip"
    sha256 "c8e4a7bf15f139f779a415d2d3c371738b1e9f5e14abd9c18af6b9bed3babf35"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/39/1a/d553fc6f999759b125a434cad778b8f8b4fe5ef3a5dc303eb8b57fbd8423/azure-core-1.19.0.zip"
    sha256 "18d2a6cd3b7391489f005775fe69e4d0870f9384b755e45185efd45c050e2306"
  end

  resource "azure-cosmos" do
    url "https://files.pythonhosted.org/packages/3c/d3/f74bf55c48851944b726cb36883c68d3c4bb887fb2196f216ca543c691e1/azure-cosmos-3.2.0.tar.gz"
    sha256 "4f77cc558fecffac04377ba758ac4e23f076dc1c54e2cf2515f85bc15cbde5c6"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/39/9d/8acff66e50186e64347b96268b6763a47c632d0240fd46b5e04d86656de7/azure-datalake-store-0.0.49.tar.gz"
    sha256 "3fcede6255cc9cd083d498c3a399b422f35f804c561bb369a7150ff1f2f07da9"
  end

  resource "azure-graphrbac" do
    url "https://files.pythonhosted.org/packages/3e/4e/4598ea52efc2654b0c865243bd60625d4ffa4df874e7e5dcb76a9a4ddbbc/azure-graphrbac-0.60.0.zip"
    sha256 "d0bb62d8bf8e196b903f3971ba4afa448e4fe14e8394ebfcdd941d84d62ecafe"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/a8/20/6dcb10fdbce9d6c22fdc401ee0b825c751125ad078d49b2750eb6aeb0050/azure-identity-1.6.1.zip"
    sha256 "69035c81f280fac5fa9c55f87be3a359b264853727486e3568818bb43988080e"
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
    url "https://files.pythonhosted.org/packages/ad/fc/c0121bf1034f0844f59d1f6e8c1f663889b2760cf7ba9aaead0a92481a4e/azure-keyvault-keys-4.5.0b4.zip"
    sha256 "7f8dd94cc15cd0854869aebd80464538b00b444731dd14421686036361582eb6"
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
    url "https://files.pythonhosted.org/packages/eb/6b/cbcc455ff4a5128955928ec7718787821e522f654f456b158f0fcc344e21/azure-mgmt-apimanagement-0.2.0.zip"
    sha256 "790f01c0b32583706b8b8c59667c0f5a51cd70444eee76474e23a598911e1d72"
  end

  resource "azure-mgmt-appconfiguration" do
    url "https://files.pythonhosted.org/packages/36/c1/17364b213669823e8c6deb126ad0bf8f5079bd84aef4b4150f90e6388cfd/azure-mgmt-appconfiguration-2.0.0.zip"
    sha256 "97e990ec6a5a3acafc7fc1add8ff1a160ebb2052792931352fd7cf1d90f1f956"
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
    url "https://files.pythonhosted.org/packages/32/06/aedae003e3b5295a3f62a4d12e00f22f6d0e31287aa637183b0b1f7125ca/azure-mgmt-batch-16.0.0.zip"
    sha256 "1b3cecd6f16813879c6ac1a1bb01f9a6f2752cd1f9157eb04d5e41e4a89f3c34"
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
    url "https://files.pythonhosted.org/packages/e5/65/fdba478260260b7e430924823adfb83a49277dbbfe1b53e5298df5a4cafa/azure-mgmt-cdn-11.0.0.zip"
    sha256 "28e7070001e7208cdb6c2ad253ec78851abdd73be482230d2c0874eed5bc0907"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/f4/70/bc6a1037642081a5fbea6f409a82e3d502d8dea24c2ab1d028a0541ee0ae/azure-mgmt-cognitiveservices-12.0.0.zip"
    sha256 "73054bd19866577e7e327518afc8f47e1639a11aea29a7466354b81804f4a676"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/5a/c8/a068d52bb49300b7e1f55ed81c5ab43f4bb7f10187a9af98ee21ceb9a72d/azure-mgmt-compute-23.1.0.zip"
    sha256 "49dbb0f51006d557cbd0b22999cb9ecf3eabc2be46d96efcc6d651c6b33754b3"
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
    url "https://files.pythonhosted.org/packages/52/f2/f123779a2ced801ef58dbc0b2f218b2f7b1cde8f78adeb9c411b23c21eac/azure-mgmt-containerservice-16.1.0.zip"
    sha256 "3654c8ace2b8868d0ea9c4c78c74f51e86e23330c7d8a636d132253747e6f3f4"
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
    url "https://files.pythonhosted.org/packages/54/b4/08f5234f7453e3671ba8005d4aa36cf9aac34b16c82ad477194424dac628/azure-mgmt-eventhub-9.1.0.zip"
    sha256 "0ba9f10e1e8d03247a316e777d6f27fabf268d596dda2af56ac079fcdf5e7afe"
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
    url "https://files.pythonhosted.org/packages/25/37/63e5eca05f58b7d9d9f0525f389f1938afe0f593e4216679fb8af4a5bc6b/azure-mgmt-imagebuilder-0.4.0.zip"
    sha256 "4c9291bf16b40b043637e5e4f15650f71418ac237393e62219cab478a7951733"
  end

  resource "azure-mgmt-iotcentral" do
    url "https://files.pythonhosted.org/packages/46/f8/1c2ff8521593993299aa0c0b1e063b7e59837a5671cef53e1d83c3d5ad91/azure-mgmt-iotcentral-9.0.0b1.zip"
    sha256 "5841791ee89a5139e46bfdb0d1c557fd5c11b7cfc60f4fb97ea1a49f5055c782"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/16/89/fda1663a6caa121bbefe88a40804691b0063abc2205d14d0d390d8127fb5/azure-mgmt-iothub-2.1.0.zip"
    sha256 "2724f48cadb1be7ee96fc26c7bfa178f82cea5d325e785e91d9f26965fa8e46f"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https://files.pythonhosted.org/packages/2b/f3/45c5b167268a338e8e761ff30b6b97060d657c38385549a670cae12b91df/azure-mgmt-iothubprovisioningservices-0.3.0.zip"
    sha256 "d01b7725f3f68c5a6ff02184a9bdda8c775888af66378dd8314903d0a46e32b9"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/36/61/703555e439b335150f14b6b9a29570d0ff4172885e9b273d5768b27c14d9/azure-mgmt-keyvault-9.2.0.zip"
    sha256 "37ecd44c49ceca7d7c9431e59148febd15d7fec261651ed72ddd58755e7450b0"
  end

  resource "azure-mgmt-kusto" do
    url "https://files.pythonhosted.org/packages/0d/79/887c8f71d7ebd87e4f2359f6726a0a881f1c9369167bf075bf22ba39751c/azure-mgmt-kusto-0.3.0.zip"
    sha256 "9eb8b7781fd4410ee9e207cd0c3983baf9e58414b5b4a18849d09856e36bacde"
  end

  resource "azure-mgmt-loganalytics" do
    url "https://files.pythonhosted.org/packages/3c/ec/1a3ee18d07c90600a5b6dace260b0d03e3967c5535bb2d157ef0a900e28c/azure-mgmt-loganalytics-11.0.0.zip"
    sha256 "41671fc6e95180fb6147cb40567410c34b85fb69bb0a9b3e09feae1ff370ee9d"
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
    url "https://files.pythonhosted.org/packages/c2/d1/35d471f400b612b38473ffa7747ba5fa2f79f47e410009fb887db19a4e8a/azure-mgmt-maps-2.0.0.zip"
    sha256 "384e17f76a68b700a4f988478945c3a9721711c0400725afdfcb63cf84e85f0e"
  end

  resource "azure-mgmt-marketplaceordering" do
    url "https://files.pythonhosted.org/packages/17/9c/74d7746672a4e9ac6136e3043078a2f4d0a0e3568daf2de772de8e4d7cff/azure-mgmt-marketplaceordering-1.1.0.zip"
    sha256 "68b381f52a4df4435dacad5a97e1c59ac4c981f667dcca8f9d04453417d60ad8"
  end

  resource "azure-mgmt-media" do
    url "https://files.pythonhosted.org/packages/8a/37/eb693a927e962ec9033fec6bd994b1aef6ee7a023191d063ec4e6d78642b/azure-mgmt-media-7.0.0.zip"
    sha256 "b45e82a594ed91cd5aa7a5cd5d01f038b7ac3cf12233e7ba2beaaa3477900e8e"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/d1/07/6109120151e9bb768a581fccea4adfc1016bcf3cfe7a167431d400b277ac/azure-mgmt-monitor-2.0.0.zip"
    sha256 "e7f7943fe8f0efe98b3b1996cdec47c709765257a6e09e7940f7838a0f829e82"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/da/6f/60f92469f93e2820949f967b8c722fe0c04f03e4cc9a6332ffaf5e9f405b/azure-mgmt-msi-0.2.0.zip"
    sha256 "8622bc9a164169a0113728ebe7fd43a88189708ce6e10d4507247d6907987167"
  end

  resource "azure-mgmt-netapp" do
    url "https://files.pythonhosted.org/packages/aa/01/566bdba5bd0f7eef7ff4e4a14de6a0096dd114e4df4bea6cbd4d3ccf568d/azure-mgmt-netapp-5.1.0.zip"
    sha256 "306088088ee10e86c4cf24cc82a9ca619db5cdfc0da3fa207d00ec7f77f06e8e"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/37/43/6ffdc3a4a509436d1575afd2b4cb7c6edd18f66936de408734feb62cd471/azure-mgmt-network-19.1.0.zip"
    sha256 "62ef7fe8ba98e56412b434c9c35dc755b3c5e469f2c01bbed2ce0d12973a044b"
  end

  resource "azure-mgmt-nspkg" do
    url "https://files.pythonhosted.org/packages/c4/d4/a9a140ee15abd8b0a542c0d31b7212acf173582c10323b09380c79a1178b/azure-mgmt-nspkg-3.0.2.zip"
    sha256 "8b2287f671529505b296005e6de9150b074344c2c7d1c805b3f053d081d58c52"
  end

  resource "azure-mgmt-policyinsights" do
    url "https://files.pythonhosted.org/packages/d3/02/9353c3f24f92c424ce0ee05f7defa373f6c4db1a396154f2c15a2603737c/azure-mgmt-policyinsights-1.0.0.zip"
    sha256 "75103fb4541aeae30bb687dee1fedd9ca65530e6b97b2d9ea87f74816905202a"
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
    url "https://files.pythonhosted.org/packages/25/a1/08931afe8fd40951c77f92ae7cf1b687f97919a205af0c8130f34650e710/azure-mgmt-recoveryservicesbackup-3.0.0.zip"
    sha256 "1992486b28ddd6d4f597fd3004217cd2caf4f4dc8a0ce71226b5ae767ace3a18"
  end

  resource "azure-mgmt-redhatopenshift" do
    url "https://files.pythonhosted.org/packages/a5/16/ff6b3e2aa6b13348b60b52c164d4bd2aa3da65a95793f964474ea75e26fa/azure-mgmt-redhatopenshift-1.0.0.zip"
    sha256 "94cd41f1ebd82e40620fd3e6d88f666b5c19ac7cf8b4e8edadb9721bd7c80980"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/73/86/fdfb93bc1049aae79942ec46125c04ce1e352bf0c0ff80fc77dee9564870/azure-mgmt-redis-13.0.0.zip"
    sha256 "283f776afe329472c20490b1f2c21c66895058cb06fb941eccda42cc247217f1"
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
    url "https://files.pythonhosted.org/packages/5c/b3/ec5591a7d25cd27fede908e68309ac668cbfaa190613fc92528a643f8770/azure-mgmt-resource-19.0.0.zip"
    sha256 "bbb60bb9419633c2339569d4e097908638c7944e782b5aef0f5d9535085a9100"
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
    url "https://files.pythonhosted.org/packages/55/9a/c9dc0da4a25e8d23552f298614fe5cc26f666ae520252dbe7c61ff06a424/azure-mgmt-servicebus-6.0.0.zip"
    sha256 "f6c64ed97d22d0c03c4ca5fc7594bd0f3d4147659c10110160009b93f541298e"
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
    url "https://files.pythonhosted.org/packages/82/2d/5eb18bf965db54d523d832ccd91be00981ee32e215ba31a917791a77947d/azure-mgmt-servicelinker-1.0.0b1.zip"
    sha256 "4f70d3bcd98ba539bfef870e3c497ebdc5efed3200c2627a61718baa9ab21a61"
  end

  resource "azure-mgmt-signalr" do
    url "https://files.pythonhosted.org/packages/a6/e1/69d0e7f65a52ee5c98ce0c4c3b32776e5029ad1c0e82b2e810b698cb38d8/azure-mgmt-signalr-1.0.0b2.zip"
    sha256 "153c58f2aa228471b8399b8a4f7b1146529f3916c8a2a0eaba0f4aa3ee92f5dc"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/3f/af/398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310/azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-sqlvirtualmachine" do
    url "https://files.pythonhosted.org/packages/b6/94/f8f74fe1d409929a6ba0d6a349cac891aad3ed6ab6141ddd414cbb5cc7aa/azure-mgmt-sqlvirtualmachine-1.0.0b1.zip"
    sha256 "4ab153bd4fbaed4dc2a4c2cf64c6b05ee45d4886d3b1f6afda315922c6563e6c"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/64/d7/73feaaa6d0a6440556da543545d54bbf93a4cab37d23f5dcf6e1bbebe7a2/azure-mgmt-storage-19.0.0.zip"
    sha256 "f05963e5a8696d0fd4dcadda4feecb9b382a380d2e461b3647704ac787d79876"
  end

  resource "azure-mgmt-synapse" do
    url "https://files.pythonhosted.org/packages/bb/4a/46ff9dbcefbbbac75d53322f08a09d4fc434d2f1a36bc4e6f0ea9a1ce96d/azure-mgmt-synapse-2.1.0b2.zip"
    sha256 "fc1031283b6da7fb52fd7e39cbc5f82819b9ab1b4db955e1adce6a07703ec111"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/14/98/6fb3bc67bb862b7bac2ea43108aa1648f72c8fa63de22ab1e58278224c43/azure-mgmt-trafficmanager-0.51.0.zip"
    sha256 "fc8ae77022cfe52fda4379a2f31e0b857574d536e41291a7b569b5c0f4104186"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/66/bc/8e53a3df60e40dd43ea59d7256d6e3bd7a152e88451a85e19abc99d2f6d2/azure-mgmt-web-4.0.0.zip"
    sha256 "e57437a933e7dea9b0618fe790e0dadc63f9857735361ac8b5f5e8062b9c2a0d"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/3a/04/baead436bdd983c41c6fc6873f98d843a4c25b3fafb843145b86c05725c6/azure-multiapi-storage-0.7.0.tar.gz"
    sha256 "cd4f184be8c9ca8aca969f93ed50dc7fe556d28ca11520440fc182cf876abdf9"
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
    url "https://files.pythonhosted.org/packages/c2/e3/f56c3e76d9a0e2323871db73f31c7b9e2941f267a01bf18611bf9502ae5d/azure-synapse-artifacts-0.8.0.zip"
    sha256 "3d4fdfd0bd666984f7bdc7bc0c7a6018c35a5d46a81a32dd193b07c03b528b72"
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
    url "https://files.pythonhosted.org/packages/c5/67/5d0548226bcc34468e23a0333978f0e23d28d0b3f0c71a151aef9c3f7680/certifi-2019.6.16.tar.gz"
    sha256 "945e3ba63a0b9f577b1395204e13c3a231f9bc0223888be653286534e5873695"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
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
    url "https://files.pythonhosted.org/packages/d4/85/38715448253404186029c575d559879912eb8a1c5d16ad9f25d35f7c4f4c/cryptography-3.3.2.tar.gz"
    sha256 "5a60d3780149e13b7a6ff7ad6526b38846354d11a15e21068e57073e29e19bed"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
    sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
  end

  resource "fabric" do
    url "https://files.pythonhosted.org/packages/cf/3c/19f930f9e74c417e2c617055ceb2be6aee439ac68e07b7d3b3119a417191/fabric-2.4.0.tar.gz"
    sha256 "93684ceaac92e0b78faae551297e29c48370cede12ff0f853cdebf67d4b87068"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/31/0e/a2e882aaaa0a378aa6643f4bbb571399aede7dbb5402d3a1ee27a201f5f3/humanfriendly-9.1.tar.gz"
    sha256 "066562956639ab21ff2676d1fda0b5987e985c534fc76700a19bd54bcb81121d"
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
    url "https://files.pythonhosted.org/packages/64/5c/2b4b0ae4d42cb1b0b1a89ab1c4d9fe02c72461e33a5d02009aa700574943/jsondiff-1.2.0.tar.gz"
    sha256 "34941bc431d10aa15828afe1cbb644977a114e75eef6cc74fb58951312326303"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/b2/4f/4c6fc2ee28055b961ebbbbed5e7f645c70e25b774b564ae152e3aa62ce9e/knack-0.8.2.tar.gz"
    sha256 "4eaa50a1c5e79d1c5c8e5e1705b661721b0b83a089695e59e229cc26c64963b9"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/29/4b/e772f95418e4c2039a946a3a5e4274c15cb1ab3f46c3ea93afa6ac1d3ea7/msal-1.15.0.tar.gz"
    sha256 "00d3cc77c3bcd8e2accaf178aa58a1d036918faa9c0f3039772cc16a470bdacc"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/8e/76/32e0bc0ab99c439aadf854751601bf9ad8aca01c884cf30fab0a29746c6b/msal-extensions-0.3.0.tar.gz"
    sha256 "5523dfa15da88297e90d2e73486c8ef875a17f61ea7b7e2953a300432c2e7861"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/bb/2c/e8ac4f491efd412d097d42c9eaf79bcaad698ba17ab6572fd756eb6bd8f8/msrest-0.6.21.tar.gz"
    sha256 "72661bc7bedc2dc2040e8f170b6e9ef226ee6d3892e01affd4d26b06474d68d8"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/33/09/3e739919833155dfa6126bcd00a406fb9beab7ca002022c65b7e7e9cd1eb/msrestazure-0.6.3.tar.gz"
    sha256 "0ec9db93eeea6a6cf1240624a04f49cd8bbb26b98d84a63a8220cfda858c2a96"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/ec/90/882f43232719f2ebfbdbe8b7c57fc9642a25b3df30cb70a3701ea22622de/oauthlib-3.0.1.tar.gz"
    sha256 "0ce32c5d989a1827e3f1148f98b9085ed2370fc939bf524c9c851d8714797298"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/54/68/dde7919279d4ecdd1607a7eb425a2874ccd49a73a5a71f8aa4f0102d3eb8/paramiko-2.6.0.tar.gz"
    sha256 "f4b2edfa0d226b70bd4ca31ea7e389325990283da23465d572ed1f70a7583041"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
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
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/0c/c6/3cdc7cb1289b35186fd7fd61836b6d83632ca0f7eee552516777361667b1/PyJWT-2.1.0.tar.gz"
    sha256 "fba44e7898bbca160a2b2b501f492824fc8382485d3a6f11ba5d0c1937ce6130"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc/pyOpenSSL-19.0.0.tar.gz"
    sha256 "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200"
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
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/a0/e4/2bae99e2bbdeb17c7cb9c2f7ef6022383ffcab8461d2ec339ff19ce4a969/pyparsing-3.0.3.tar.gz"
    sha256 "9e3511118010f112a4b4b435ae50e1eaa610cda191acb9e421d60cf5fde83455"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
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
    url "https://files.pythonhosted.org/packages/c2/fd/202954b3f0eb896c53b7b6f07390851b1fd2ca84aa95880d7ae4f434c4ac/tabulate-0.8.3.tar.gz"
    sha256 "8af07a39377cee1103a5c8b3330a421c2d99b9141e9cc5ddd2e3263fea416943"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/c5/01/8c9c7de6c46f88e70b5a3276c791a2be82ae83d8e0d0cc030525ee2866fd/websocket_client-0.56.0.tar.gz"
    sha256 "1fd5520878b68b84b5748bb30e592b10d0a91529d5383f74f4964e72b297fd3a"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/23/84/323c2415280bc4fc880ac5050dddfb3c8062c2552b34c2e512eb4aa68f79/wrapt-1.11.2.tar.gz"
    sha256 "565a021fd19419476b9362b05eeaa094178de64f8361e44468f9e9d7843901e1"
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
