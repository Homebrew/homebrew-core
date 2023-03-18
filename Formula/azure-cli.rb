class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://github.com/Azure/azure-cli/archive/azure-cli-2.46.0.tar.gz"
  sha256 "aa49d402fd3346418b796e40f8c3119e42c325d70a0a2b8ddb2ebc3c4e208fc3"
  license "MIT"
  head "https://github.com/Azure/azure-cli.git", branch: "dev"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/azure-cli[._-]v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9822986ac5c14da8a7c9b2474dd8b95da3da1c860a92977e3074c611024a9628"
    sha256 cellar: :any,                 arm64_monterey: "75e6b494a2647dfdd5bf15571de5870f12d7dc0f29b238d3ea15dd82a7f97f94"
    sha256 cellar: :any,                 arm64_big_sur:  "4fe75739941dfe964960a28fd566126dd7bc14b87f272053951f849cadfca7e5"
    sha256 cellar: :any,                 ventura:        "c0e3cf15401d66df1f11ada723de7fdc7ed06a5c69e1adbafce82f50820d1d9e"
    sha256 cellar: :any,                 monterey:       "94ff5e26ab75f5bf088f95c1c99794992031e9aba8f6b3d41514b05e357b02a7"
    sha256 cellar: :any,                 big_sur:        "de147edb6eff4973d204e577c4961bc754e624d7143b54422cd495d763c815a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7494f03771857bcedfe33b150338e37baee739042fedd5aa56d8aa1387a45b68"
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

  resource "PyGithub" do
    url "https://files.pythonhosted.org/packages/98/36/386d282903c572b18abc36de68aaf4146db4659c82dceee009ef88a86b67/PyGithub-1.55.tar.gz"
    sha256 "1bbfff9372047ff3f21d5cd8e07720f3dbfdaf6462fcaed9d815f528f1ba7283"
  end

  resource "PyMySQL" do
    url "https://files.pythonhosted.org/packages/60/ea/33b8430115d9b617b713959b21dfd5db1df77425e38efea08d121e83b712/PyMySQL-1.0.2.tar.gz"
    sha256 "816927a350f38d56072aeca5dfb10221fe1dc653745853d30a216637f5d7ad36"
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
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "azure-appconfiguration" do
    url "https://files.pythonhosted.org/packages/21/0a/1b24d1b3c1477b849d48aa29dcde3141c1524fab293042493f3432b672c2/azure-appconfiguration-1.1.1.zip"
    sha256 "b83cd2cb63d93225de84e27abbfc059212f8de27766f4c58dd3abb839dff0be4"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/b9/2b/28153115f287a7d8f5964223744a466eaf3f78adcac070cb8113ce65aa0e/azure-batch-13.0.0.zip"
    sha256 "e9295de70404d276eda0dd2253d76397439abe5d8f18c1fca199c49b8d6ae30a"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/99/33/fe8ffd51ed08a2b77d34b6a997f8e3e884a6e08f08f9626c9969d930fd3c/azure-common-1.1.22.zip"
    sha256 "c8e4a7bf15f139f779a415d2d3c371738b1e9f5e14abd9c18af6b9bed3babf35"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/f2/b0/334c52e5bee1c46aec7a1b62739be6ea9c19ace38f54ca4510d45398071d/azure-core-1.24.0.zip"
    sha256 "345b1b041faad7d0205b20d5697f1d0df344302e7aaa8501905580ff87bd0be5"
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
    url "https://files.pythonhosted.org/packages/75/8f/d984f31d1c6736e0b81f9ea8e63e57d54995bf5d61de8fe8ab8e131c2e44/azure-keyvault-keys-4.8.0b2.zip"
    sha256 "554c10240c2964843c7f30548d45f4ba2db26959032bba747f09a7cf7ef75db6"
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
    url "https://files.pythonhosted.org/packages/48/59/24bbcbd71d520dac7d684ee9cd4f40e8ba2a8290d2261afb4dfde7a2fd12/azure-mgmt-appconfiguration-2.2.0.zip"
    sha256 "47608e4b6da90ad169de857df0b2e7fd7d8b90f3955026ac10e3611488447414"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https://files.pythonhosted.org/packages/04/d6/31fdc6bc6cebfbf66e12e8a5556e5f7bda7f7ec57367ec9d8025df62560a/azure-mgmt-applicationinsights-1.0.0.zip"
    sha256 "c287a2c7def4de19f92c0c31ba02867fac6f5b8df71b5dbdab19288bb455fc5b"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/7b/39/46adcbabc61a6d91f8514b46a2b64cfba365170325a6c38c31e2c1567090/azure-mgmt-authorization-3.0.0.zip"
    sha256 "0a5d7f683bf3372236b841cdbd4677f6b08ed7ce41b999c3e644d4286252057d"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/ff/16/92da0d8d3006a8cdfc07be79b6cc975bb49b780bf952a5291531f6bb950b/azure-mgmt-batch-17.0.0.zip"
    sha256 "8643385952eec318f8aa05ec63c61aef3bbbfefdfb80a74fd176dfd84aabb16a"
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
    url "https://files.pythonhosted.org/packages/b9/8d/0b681fc3be71de2e46bb2d4a16e6375eb1f65b65f4f240d1af056929c4dd/azure-mgmt-botservice-2.0.0b3.zip"
    sha256 "5d919039e330f2eb32435b65f23e7b7d9deea8bb21a261d8f633bfadba503af3"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/d7/fc/48310b510043223c42ea2f9ac1e91a9a88b7438c0882d4c32db9f0b9fb0c/azure-mgmt-cdn-12.0.0.zip"
    sha256 "b7c3ee2189234b4af51ace2924927c5fd733f3de748a642d6d5040067c8c9ddd"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/ae/06/4c72a2996870dae1a3ddee84e390d9f3a098e0d784f17bd41914a4e4742e/azure-mgmt-cognitiveservices-13.3.0.zip"
    sha256 "bf5a5334f1f4ba3466e1532df79530e9dd3b945f1b80cdd721adcd2486cd2c52"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/cd/f2/69cdd710bd8171fb2a0b30749811eeb311f703e9af40d21fc91b13ec3d2a/azure-mgmt-compute-29.1.0.zip"
    sha256 "2d5a1bae7f5d307ca1e850d7e83fed9c839d4f635b10a4b8d3f8bc6098ac2888"
  end

  resource "azure-mgmt-consumption" do
    url "https://files.pythonhosted.org/packages/8c/f0/e2d94b246e2dce71eff8d362836a1979f02b4185f5403a13e4fb26c07ccb/azure-mgmt-consumption-2.0.0.zip"
    sha256 "9a85a89f30f224d261749be20b4616a0eb8948586f7f0f20573b8ea32f265189"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/6f/1f/fd9a9b24725881a659cdeaa5b5fda83ac5f8f6f514365bb9e33fd230cdb4/azure-mgmt-containerinstance-10.1.0b1.zip"
    sha256 "86a64344574045f333d18c9814b80c5f832608b42e90fb789c4a37ec7e34c50d"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/81/89/8ee7c242efbbaa0e046346e8edf7db972f526ab193baf5400eadcce8f6da/azure-mgmt-containerregistry-10.1.0.zip"
    sha256 "56b5fd61f60dbe503cf9e36a1c2a77e4101e419cd029a919b3b6592b04fca187"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/d5/83/d70a36446e40c830392b0ffc4952a38f7aec21f7c44af0c5ae09e09c5a8a/azure-mgmt-containerservice-21.2.0.zip"
    sha256 "a492e74ae49b5db6ab3a25f07e78d20cd9b253b64e97621451568403c990ae24"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/ae/18/6f79cfddbf08f233de5a51961323c0b1b2174e06ae9460988091fd012043/azure-mgmt-core-1.3.2.zip"
    sha256 "07f4afe823a55d704b048d61edfdc1318c051ed59f244032126350be95e9d501"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/cb/e2/e9a4c90b74435678bc0810434983bbb5ac42cfea5e461a943eafe6154149/azure-mgmt-cosmosdb-9.0.0.zip"
    sha256 "edb3fc925348a76b2484d294f2ce75cdac50386ea960c08af7093a71ee69c920"
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

  resource "azure-mgmt-devtestlabs" do
    url "https://files.pythonhosted.org/packages/f0/18/ef3217b4ef0acc25d1ed20f5e873f6ad3fe80dafaf8b9c17349063bb1d98/azure-mgmt-devtestlabs-4.0.0.zip"
    sha256 "59549c4c4068f26466b1097b574a8e5099fb2cd6c8be0a00395b06d3b29e278d"
  end

  resource "azure-mgmt-dns" do
    url "https://files.pythonhosted.org/packages/58/04/a2849bf2e2a5e115666dfa50e7ca551e75fa39d0f9bfe83f0bdb7d7e4765/azure-mgmt-dns-8.0.0.zip"
    sha256 "407c2dacb33513ffbe9ca4be5addb5e9d4bae0cb7efa613c3f7d531ef7bf8de8"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/ff/ef/2d48ac5af17c3ae32feaf40769e4579ca47c4d1c5a6798f149faf0397b65/azure-mgmt-eventgrid-10.2.0b2.zip"
    sha256 "41c1d8d700b043254e11d522d3aff011ae1da891f909c777de02754a3bb4a990"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/20/dc/5e2ff08ecff52df3a767b62bd92eef43c94ebd7e8dccd8127df863ce2712/azure-mgmt-eventhub-10.1.0.zip"
    sha256 "319aa1481930ca9bc479f86811610fb0150589d5980fba805fa79d7010c34920"
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
    url "https://files.pythonhosted.org/packages/98/1e/0308326188b9a5b1d5a88f7edbec375d48f550f5c26515789fcc6117fca7/azure-mgmt-imagebuilder-1.1.0.zip"
    sha256 "d8459f4ec979cb74b0e0ff1de57ed32b16263b83da8144cdbff48529d8d8d92b"
  end

  resource "azure-mgmt-iotcentral" do
    url "https://files.pythonhosted.org/packages/9e/9e/50b30ad35c0038ce93ccf80535d2052967dc0dedae0eee84d2dc81458614/azure-mgmt-iotcentral-10.0.0b1.zip"
    sha256 "d42899b935d88486fbe1e1906542471f3a2f60d9e755ddd876ed540b2d81bb4d"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/87/e1/ade7f65b73061a7780837202800fadfe5a381e2e58eba3b6aa2efe04e931/azure-mgmt-iothub-2.3.0.zip"
    sha256 "9a5fa4a23e76979a34b6801c9ec1adb30d2d1a73b917f2caab9ea8bf3766c7f0"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https://files.pythonhosted.org/packages/47/78/b5252f7e42d596d0e8ab4d7ea5f90545436d83c4bf45f1e86d7618d128db/azure-mgmt-iothubprovisioningservices-1.1.0.zip"
    sha256 "d383a826e7dff772fad86e88a33a661e911a51b1c71c3ea72a590c1d5a09bc9e"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/3b/d7/4997524c6284ecc6641d17ff9e91cd1f1ab0ea8cf2b6654f2f335faa353f/azure-mgmt-keyvault-10.1.0.zip"
    sha256 "0e93bee85bec3708e3733d889a11e90a894754da4f50c802b4432b7d4cdf01a0"
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
    url "https://files.pythonhosted.org/packages/75/34/5acd343743ba66e06107f323d06844faa51900380143992b4a9ec3554883/azure-mgmt-monitor-5.0.0.zip"
    sha256 "78bf4a268c314c5ee164941040234967b97eaca3c533cc0fe6f12282ddd91461"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/77/d7/4ef788fb8e0f90a3fe5875b05dcef535ad4b4a766372af82870120cd5dd3/azure-mgmt-msi-7.0.0.zip"
    sha256 "72d46c9a62783ec4eab619be9d1b78ffebbdaa164d406fd303f16303f37256b2"
  end

  resource "azure-mgmt-netapp" do
    url "https://files.pythonhosted.org/packages/b3/47/688c7a7d7ecea47824a3948ae89db6eb270cffbd83b0b68e6dfae2ffd5d9/azure-mgmt-netapp-9.0.1.zip"
    sha256 "3d844c396689517ad182a5b7fa92c163e2fa1ef5355a53ef69ab457b83bb458f"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/44/9c/02b7938dddf0ad3bb1f6e231d72e91ccbdb6b9bf65251e7aa04c8b0a0cb1/azure-mgmt-network-21.0.1.zip"
    sha256 "ecf76e3e0d092b87ffdeafdbe69ab9f138ea564f88bbebf16be6892839d2732f"
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
    url "https://files.pythonhosted.org/packages/d7/d1/cf17bfe28acd7cb3f363fc90e2c255d049fde039a9bf395f4fc6444c8d93/azure-mgmt-rdbms-10.2.0b6.zip"
    sha256 "fe0c7aa87ae5cc6cc33164c0dd1ff2da53d3feea86312511db66308bc5d15bef"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https://files.pythonhosted.org/packages/2c/65/2b46a686b02aa79190a26b0c47d0a9627b2098858a724785e8131e8ae38f/azure-mgmt-recoveryservices-2.2.0.zip"
    sha256 "dab53931ce6d7121c469e8f82de889fd6c168e4ddf64575decc230aa61e046cb"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/70/34/58aee720bdfe68bdaa06491697f67a6a019076f99bcbe1d16eec69a951a0/azure-mgmt-recoveryservicesbackup-5.1.0.zip"
    sha256 "c65f8a6cd19c789585bc9287f00c34d87a3ec0c031bf13d9e13d3d4229a7ece5"
  end

  resource "azure-mgmt-redhatopenshift" do
    url "https://files.pythonhosted.org/packages/1a/cb/b6bfc87e72d8b8e89ee15402eb9ac88893715f494b1e5a61303a44a169ad/azure-mgmt-redhatopenshift-1.2.0.zip"
    sha256 "654e26293ce7cbdb6c283ac5494fa5965e6fea80e2bd82655c3ae25892c061e7"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/c1/fa/fda9c31e9d6580bfb9dd3ccfb7e1c1399feb888f3e2a53aa1b3187da6c3a/azure-mgmt-redis-14.1.0.zip"
    sha256 "2cef7659cdbe56fb042a23a35521d7c36a370faf4d4252f9f26f98a9697afa28"
  end

  resource "azure-mgmt-relay" do
    url "https://files.pythonhosted.org/packages/df/76/f4673094df467c1198dfd944f8a800a25d0ed7f4bbd7c73e9e2605874576/azure-mgmt-relay-0.1.0.zip"
    sha256 "d9f987cf2998b8a354f331b2a71082c049193f1e1cd345812e14b9b821365acb"
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
    url "https://files.pythonhosted.org/packages/a5/e7/5242104430b1b8337e7c2e91a09981985c4eab6dca663ddaafd6118a0a16/azure-mgmt-security-3.0.0.zip"
    sha256 "bcba7cef857f6b02a2d98afeb07f9871b1628fa33d8861ab1387e732e7db3f84"
  end

  resource "azure-mgmt-servicebus" do
    url "https://files.pythonhosted.org/packages/f9/fa/88014c3bd2fe34694184e9ced1b8230de495bcf2eb368c0bfc82db36dc12/azure-mgmt-servicebus-8.2.0.zip"
    sha256 "8be9208f141d9a789f68db8d219754ff78069fd8f9390e9f7644bb95a3be9ec2"
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
    url "https://files.pythonhosted.org/packages/15/dd/83b8347d509310fa9182e7d0f7eef11d17eaf426abc2c4de1e02df3f223c/azure-mgmt-servicelinker-1.2.0b1.zip"
    sha256 "44ad50e75434c001b9e682ab166bfae7fd8050a97e811769dbbb7f11cb8c38d9"
  end

  resource "azure-mgmt-signalr" do
    url "https://files.pythonhosted.org/packages/ad/cf/0b76fb075bd552512c1a62f6404c96225818663a92818cccd59c22f627ce/azure-mgmt-signalr-1.1.0.zip"
    sha256 "9543480f23f95bef1a217ee66a77cca9a3b6209266ffed8ef81baff818781191"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/b5/4f/a5dfd452b1c4969300a38d0ee5fce4f2f24d7e935afb1cc33c3ee78c0302/azure-mgmt-sql-4.0.0b8.zip"
    sha256 "525cfe76ff10e4ff9dafdd032b8bcc9a2d9346011d8556246ab7d12f7ac053b3"
  end

  resource "azure-mgmt-sqlvirtualmachine" do
    url "https://files.pythonhosted.org/packages/8c/9a/b5f0ebf6b82df07a55556bfb18388d09582e50369b6a69e85b0df66dcb02/azure-mgmt-sqlvirtualmachine-1.0.0b5.zip"
    sha256 "6458097e58329d14b1a3e07e56ca38797d4985e5a50d08df27d426ba95f2a4c7"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/83/9d/f486f601c9902bce42ea77adfa6f81895535adfb3eadc1f8522b1abbd44b/azure-mgmt-storage-21.0.0.zip"
    sha256 "6eb13eeecf89195b2b5f47be0679e3f27888efd7bd2132eec7ebcbce75cb1377"
  end

  resource "azure-mgmt-synapse" do
    url "https://files.pythonhosted.org/packages/9a/37/83c4b44418fb7bb10389e43a5fc29c164bd8524f73a0e664d5f4ccf716be/azure-mgmt-synapse-2.1.0b5.zip"
    sha256 "e44e987f51a03723558ddf927850db843c67380e9f3801baa288f1b423f89be9"
  end

  resource "azure-mgmt-trafficmanager" do
    url "https://files.pythonhosted.org/packages/0f/f0/31bbc546d10254513905174e429e320f192f853159482f2bdc71b4623830/azure-mgmt-trafficmanager-1.0.0.zip"
    sha256 "4741761e80346c4edd4cb3f271368ea98063f804d015e245c2fe048ed2b596a8"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/49/40/8866f35ca9cacf7f9991bccb8fc470a1728d1445716f510d0031dbb3557c/azure-mgmt-web-7.0.0.zip"
    sha256 "5afc8d81f8a5884b7aa9ac2acbc2def1e89f871bac324a196dfe987326354810"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/bd/df/5221bb0e12270f83c4fa80315be6a81e91407d637274dbde6dbe9e38b34a/azure-multiapi-storage-1.0.0.tar.gz"
    sha256 "c79bf77b7fe9a129be24cb7449623595c33a60051c3fea364a7f1396e5cec888"
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
    url "https://files.pythonhosted.org/packages/35/3e/d9baf379f88caa4bfdf877537523f6d0091a4f4883fce1cc197b6877bb46/azure-synapse-artifacts-0.15.0.zip"
    sha256 "5f1af2b8de4756e63d87a8a8484bfd9f0ce42bac182eea6f14e089a97f367961"
  end

  resource "azure-synapse-managedprivateendpoints" do
    url "https://files.pythonhosted.org/packages/14/85/3f7224fb15155be1acd9d5cb2a5ac0575b617cade72a890f09d35b175ad7/azure-synapse-managedprivateendpoints-0.4.0.zip"
    sha256 "900eaeaccffdcd01012b248a7d049008c92807b749edd1c9074ca9248554c17e"
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
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
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
    url "https://files.pythonhosted.org/packages/e3/3f/41186b1f2fd86a542d399175f6b8e43f82cd4dfa51235a0b030a042b811a/cryptography-38.0.4.tar.gz"
    sha256 "175c1a818b87c9ac80bb7377f5520b7f31b3ef2a0004e2420319beadedb67290"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "fabric" do
    url "https://files.pythonhosted.org/packages/cf/3c/19f930f9e74c417e2c617055ceb2be6aee439ac68e07b7d3b3119a417191/fabric-2.4.0.tar.gz"
    sha256 "93684ceaac92e0b78faae551297e29c48370cede12ff0f853cdebf67d4b87068"
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
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
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
    url "https://files.pythonhosted.org/packages/2e/9c/b6fc4ca774d3730fd1c2c9fe516afc223562976a4bcf0cec6e9e4dbf38c5/knack-0.10.1.tar.gz"
    sha256 "c5728128297e6d269791085cf96c2ffdfcef58cf83c634a5cb92eb03b2929838"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/c5/f8/05c343f2652b5b32f063bc908f428ffd14da65939d96b7adc48986f242a8/msal-1.20.0.tar.gz"
    sha256 "78344cd4c91d6134a593b5e3e45541e666e37b747ff8a6316c3668dd1e6ab6b2"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "msrestazure" do
    url "https://files.pythonhosted.org/packages/48/fc/5c2940301a83f18884a8e3aead2b2ff177a1a373f75c7b17e2e404199b2a/msrestazure-0.6.4.tar.gz"
    sha256 "a06f0dabc9a6f5efe3b6add4bd8fb623aeadacf816b7a35b0f89107e0544d189"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/3b/6b/554c00e5e68cd573bda345322a4e895e22686e94c7fa51848cd0e0442a71/paramiko-3.0.0.tar.gz"
    sha256 "fedc9b1dd43bc1d45f67f1ceca10bc336605427a46dcdf8dec6bfea3edf57965"
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
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/d8/6b/6287745054dbcccf75903630346be77d4715c594402cec7c2518032416c2/PyJWT-2.4.0.tar.gz"
    sha256 "d42908208c699b3b973cbeb01a969ba6a96c821eefb1c5bfe4c390c01d67abba"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/e7/2f/c6d89edac75482f11e231b644e365d31d5479b7b727734e6a8f3d00decd5/pyOpenSSL-22.1.0.tar.gz"
    sha256 "7a83b7b272dd595222d672f5ce29aa030f1fb837630ef229f62e72e395ce8968"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sshtunnel" do
    url "https://files.pythonhosted.org/packages/c5/5c/4b320d7ec4b0d5d4d6df1fdf66a5799625b3623d0ce4efe81719c6f8dfb3/sshtunnel-0.1.5.tar.gz"
    sha256 "c813fdcda8e81c3936ffeac47cb69cfb2d1f5e77ad0de656c6dab56aeebd9249"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d3/20/06270dac7316220643c32ae61694e451c98f8caf4c8eab3aa80a2bedf0df/typing_extensions-4.5.0.tar.gz"
    sha256 "5cb5f4a79139d699607b3ef622a1dedafa84e115ab0024e0d9c044a9479ca7cb"
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
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10", system_site_packages: false)
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
      AZ_INSTALLER=HOMEBREW #{libexec}/bin/python -m azure.cli "$@"
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
