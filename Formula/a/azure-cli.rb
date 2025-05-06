class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://github.com/Azure/azure-cli/archive/refs/tags/azure-cli-2.72.0.tar.gz"
  sha256 "f2c9d7e25c7826c5c75126d2c87fcc1d6cfd8b1bfd27ae08f37b97e63eb5a0cc"
  license "MIT"
  head "https://github.com/Azure/azure-cli.git", branch: "dev"

  livecheck do
    url :stable
    regex(/azure-cli[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3129bc0d140ba5d0bdee7282986e90cca7cacf43af4c01c4b4e218e1265719fc"
    sha256 cellar: :any,                 arm64_sonoma:  "d7d6482f0130148e381ace7da8f543111b60d32c6a99097e2cfbd612be16ae5b"
    sha256 cellar: :any,                 arm64_ventura: "b47a04430e286c06d8aa308291891a84e7fcbf78e9410029dd31b64161a21b94"
    sha256 cellar: :any,                 sonoma:        "0b499936e96f8e880504b0a43e01cb69d00e9bd6162ba73df47377c1aeaf15c4"
    sha256 cellar: :any,                 ventura:       "2d830e7924cd7af190dc07e2c6127201676c6d31e8c0065d183ac5754625f9ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c4f54dfd5b4bb04491348c687791c634210dd4f1d53cf9d06a9714277212338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7109e1df4670934bcdaf5de9e047542129979e9f819bc8a3ebe55225141988a2"
  end

  # `pkgconf`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
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
    url "https://files.pythonhosted.org/packages/b6/00/7f1cab9b44518ca225a03f4493ac9294aab5935a7a28486ba91a20ea29cf/antlr4-python3-runtime-4.13.1.tar.gz"
    sha256 "3cd282f5ea7cfb841537fe01f143350fdb1c0b1ce7981443a2fa8513fddb6d1a"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/f5/02/b831bf3281723b81eb6b041d91d2c219123366f975ec0a73556620773417/applicationinsights-0.11.9.tar.gz"
    sha256 "30a11aafacea34f8b160fbdc35254c9029c7e325267874e3c68f6bdbcd6ed2c3"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/7f/03/581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0/argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "azure-appconfiguration" do
    url "https://files.pythonhosted.org/packages/07/fe/e4aa2ca52bcd3fcc2231c02e216d97010b4345cbd963e10eb49539c59cbd/azure-appconfiguration-1.7.0.tar.gz"
    sha256 "9eb079d061f05738ad3b42fe1d53da73fc6076dd7178a52df3e631f131d4ed1f"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/34/e8/6a1354d9fd22a84a83f009915598b823a7d9cb60e39cd28661b9c54d1121/azure_batch-15.0.0b1.tar.gz"
    sha256 "dfbddd158ffade52193e3e4d86c996ea7236ffd2695a43734fae5e05a974e2ed"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/99/33/fe8ffd51ed08a2b77d34b6a997f8e3e884a6e08f08f9626c9969d930fd3c/azure-common-1.1.22.zip"
    sha256 "c8e4a7bf15f139f779a415d2d3c371738b1e9f5e14abd9c18af6b9bed3babf35"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/03/7a/f79ad135a276a37e61168495697c14ba1721a52c3eab4dae2941929c79f8/azure_core-1.31.0.tar.gz"
    sha256 "656a0dd61e1869b1506b7c6a3b31d62f15984b1a573d6326f6aa2f3e4123284b"
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
    url "https://files.pythonhosted.org/packages/f7/8b/adfe6c43c71d53eeafa98ee0eb798170d857beb3d78f42fdedb21f8f8f1c/azure_datalake_store-1.0.0a0.tar.gz"
    sha256 "310ff34ad830feb5d42f452900aad6eabfce4cc8ae20736dbba75c585b743b59"
  end

  resource "azure-keyvault-administration" do
    url "https://files.pythonhosted.org/packages/80/4f/b0d62738a6e3c8e27c3cc33400e8deb14d6490042180fc872c1cdbe891ac/azure-keyvault-administration-4.4.0b2.tar.gz"
    sha256 "8d0edefad78024c3a97b071fa5cf50daf923085e9d4379259f7237d911e66810"
  end

  resource "azure-keyvault-certificates" do
    url "https://files.pythonhosted.org/packages/e6/cf/85d521e65557e4dee2cd9c700f518c3a46f6f71068e61c07d0b13b2e0727/azure-keyvault-certificates-4.7.0.zip"
    sha256 "9e47d9a74825e502b13d5481c99c182040c4f54723f43371e00859436dfcf3ca"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/50/f0/cc544f2ea8dc1a7ea9a1159ffb5b2b56b3fb86694fc565c87e5444a98718/azure-keyvault-keys-4.9.0b3.tar.gz"
    sha256 "aa8b1ec9fe96a81106f2f3dcd61175ecae3a01693c05af15f4a45e77894e946a"
  end

  resource "azure-keyvault-secrets" do
    url "https://files.pythonhosted.org/packages/5c/a1/78ecabf98e97d600dcac1559ff64b4bc9f84eca126c0aeba859916832b0c/azure-keyvault-secrets-4.7.0.zip"
    sha256 "77ee2534ba651a1f306c85d7b505bc3ccee8fea77450ebafafc26aec16e5445d"
  end

  resource "azure-mgmt-advisor" do
    url "https://files.pythonhosted.org/packages/34/96/e28b949dd55e1fc381fae2676c95c8a9410fa4b9768cc02ec3668fc490c4/azure-mgmt-advisor-9.0.0.zip"
    sha256 "fc408b37315fe84781b519124f8cb1b8ac10b2f4241e439d0d3e25fd6ca18d7b"
  end

  resource "azure-mgmt-apimanagement" do
    url "https://files.pythonhosted.org/packages/55/41/18982d29dceae7d2cca0e03513e30d65229a6785a0ab0d6b05e942ea6f6c/azure-mgmt-apimanagement-4.0.0.zip"
    sha256 "0224e32c9dbc83cd319eb4452df3d47af26079ac4ba6e1a6be4777f85b24362c"
  end

  resource "azure-mgmt-appconfiguration" do
    url "https://files.pythonhosted.org/packages/ac/38/8916327a19b106916ed950461eed816c53a7d8736990ddc6167a5738f161/azure_mgmt_appconfiguration-3.1.0.tar.gz"
    sha256 "0596f09e7e7841be91dde1c818134100bbfa124486e06889d239dd587744b47c"
  end

  resource "azure-mgmt-appcontainers" do
    url "https://files.pythonhosted.org/packages/97/ad/3eb1687c3f27b8a4c87b284f5180984073564f47ebd8445e4a44184473a7/azure-mgmt-appcontainers-2.0.0.zip"
    sha256 "71c74876f7604d83d6119096aa42dcf2512e32e004111be5e41d61b89c8192f5"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https://files.pythonhosted.org/packages/04/d6/31fdc6bc6cebfbf66e12e8a5556e5f7bda7f7ec57367ec9d8025df62560a/azure-mgmt-applicationinsights-1.0.0.zip"
    sha256 "c287a2c7def4de19f92c0c31ba02867fac6f5b8df71b5dbdab19288bb455fc5b"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-batch" do
    url "https://files.pythonhosted.org/packages/37/6d/b76ba7ca3b3e68f173afbdaf3373acd11d203be1ccf9408957525c355cba/azure-mgmt-batch-17.3.0.tar.gz"
    sha256 "fc94881a6acdb8a9533f371b6f7b2d3eaea1789eb955014b24a908d6dfe75991"
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
    url "https://files.pythonhosted.org/packages/f7/86/8f31cf3709ad612f5e0f17810d97124193468eb5f1e3b36d37227715a2df/azure-mgmt-cognitiveservices-13.5.0.zip"
    sha256 "44af0b19b1f827e9cdea09c6054c1e66092a51c32bc1ef5a56dbd9b40bc57815"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/87/30/bb941f2eee419009668305b510dfb3577604a08102b3a1d0df78d14205f3/azure_mgmt_compute-34.1.0.tar.gz"
    sha256 "cd9d35d1cc1b8cb0bd241ad55c91b77d14e04ae73c632ada1140135f9c217fe1"
  end

  resource "azure-mgmt-containerinstance" do
    url "https://files.pythonhosted.org/packages/4a/0c/434063cc0dfd1a5f07e4517d6ffc9ffa6bdc6159019266402f61624129c6/azure_mgmt_containerinstance-10.2.0b1.tar.gz"
    sha256 "bf4bb77bd6681270dd0a733aa3a7c3ecdfacba8e616d3a8c3b98cce9c48cc7c0"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/43/a0/be41acff20fdb2ad8f5fa9107e1698284843cb2f8b4f17bd770f0f1ffa7c/azure_mgmt_containerregistry-11.0.0.tar.gz"
    sha256 "a76e3a06791cd4138acf064bb25f6ed266ce4a370e1cc113eb8d488d34b7ba77"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/35/09/a640bfdb168a42bb23b588f65a4eba363334c6a8c63b7355dfc13ac539cf/azure_mgmt_containerservice-35.0.0.tar.gz"
    sha256 "71a149b3d65c2bc5c9c9c7843a11f81c3a1fb61ea187326feaa94ad3cee3dc74"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/ae/18/6f79cfddbf08f233de5a51961323c0b1b2174e06ae9460988091fd012043/azure-mgmt-core-1.3.2.zip"
    sha256 "07f4afe823a55d704b048d61edfdc1318c051ed59f244032126350be95e9d501"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/74/2a/3240e83aff38443d334a17467d32a46bab269164ab9477bb17d2277b32f8/azure_mgmt_cosmosdb-9.7.0.tar.gz"
    sha256 "b5072d319f11953d8f12e22459aded1912d5f27e442e1d8b49596a85005410a1"
  end

  resource "azure-mgmt-databoxedge" do
    url "https://files.pythonhosted.org/packages/bc/97/e6f9041c0e22cdf3fa8f5ccfec70daf0d1c15740bc5f36e8e9694ff98a98/azure-mgmt-databoxedge-1.0.0.zip"
    sha256 "04090062bc1e8f00c2f45315a3bceb0fb3b3479ec1474d71b88342e13499b087"
  end

  resource "azure-mgmt-datalake-store" do
    url "https://files.pythonhosted.org/packages/70/61/e16aaf70be45eae80aaeb4bd2d4b4101bc6e6dbe301d9ab4c22572808ea7/azure-mgmt-datalake-store-1.1.0b1.zip"
    sha256 "5a275768bc1bd918caa0e65df9bae28b74e6fdf3dc9ea7e24aed75ffb499cb64"
  end

  resource "azure-mgmt-datamigration" do
    url "https://files.pythonhosted.org/packages/06/47/cccd2c22f8f525b8a1c38fd88ffef7ae989f50bd15f1ad5b955e27ef5985/azure-mgmt-datamigration-10.0.0.zip"
    sha256 "5cee70f97fe3a093c3cb70c2a190c2df936b772e94a09ef7e3deb1ed177c9f32"
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
    url "https://files.pythonhosted.org/packages/89/3c/04ce6c779c28d95a13e37cf00854a31472ef4b563d98361c50200180b8f2/azure-mgmt-hdinsight-9.0.0b3.tar.gz"
    sha256 "72549e08ff3eed3d6e23835e73ece1cc32bdf340bdf8919e78916c352c200f64"
  end

  resource "azure-mgmt-imagebuilder" do
    url "https://files.pythonhosted.org/packages/06/a0/5996570f011ddab6dfcc19c5bf64056370c255ffbbd2232447f88f24e5d1/azure-mgmt-imagebuilder-1.3.0.tar.gz"
    sha256 "3f325d688b6125c2fa92681e5b18ea407ba032d5be3f7c0724406d733e6c14ef"
  end

  resource "azure-mgmt-iotcentral" do
    url "https://files.pythonhosted.org/packages/9e/9e/50b30ad35c0038ce93ccf80535d2052967dc0dedae0eee84d2dc81458614/azure-mgmt-iotcentral-10.0.0b1.zip"
    sha256 "d42899b935d88486fbe1e1906542471f3a2f60d9e755ddd876ed540b2d81bb4d"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/e8/99/145453e748480be1d7abf17ab56f45f295679bde00b3edf7a4199494cd74/azure-mgmt-iothub-3.0.0.tar.gz"
    sha256 "daf21fc98c68a353ec616318c0e62be04c8d6899960be8c2cbf991673ac8b722"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https://files.pythonhosted.org/packages/47/78/b5252f7e42d596d0e8ab4d7ea5f90545436d83c4bf45f1e86d7618d128db/azure-mgmt-iothubprovisioningservices-1.1.0.zip"
    sha256 "d383a826e7dff772fad86e88a33a661e911a51b1c71c3ea72a590c1d5a09bc9e"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/9f/d3/9e8d31aaedfb37efd20c8a9ac420b07cdb5c3d2f19c3452c9cdcb082dad6/azure_mgmt_keyvault-11.0.0.tar.gz"
    sha256 "fcfb1366852926f2a311e1bc6e6a786eb8a8a1fd46e6025d4c114ede2cb4642e"
  end

  resource "azure-mgmt-loganalytics" do
    url "https://files.pythonhosted.org/packages/da/3f/c784b29431b597d11fdcdb6b430d114819459eb34da190fceff5a70901cd/azure-mgmt-loganalytics-13.0.0b4.zip"
    sha256 "266d6deefe6fc858cd34cfdebd568423db1724a370264e97017b894914a72879"
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

  resource "azure-mgmt-mysqlflexibleservers" do
    url "https://files.pythonhosted.org/packages/61/85/b86cb3e554d72a837f0c86caf9ed43c3462cce5d7ce1bb1114bfcd34745b/azure_mgmt_mysqlflexibleservers-1.0.0b3.tar.gz"
    sha256 "611fd88f3db1e0a8477a1633fe94c461d17213e215170eb53c1eea9b823bd4c3"
  end

  resource "azure-mgmt-netapp" do
    url "https://files.pythonhosted.org/packages/0f/f2/074f7ddf5e62b5853b88483fcdc5bd5acb12ae16d98aa910c8e57132f1f3/azure-mgmt-netapp-10.1.0.zip"
    sha256 "7898964ce0a4d82efd268b64bbd6ca96edef53a1fcd34e215ab5fe87be8c8d03"
  end

  resource "azure-mgmt-policyinsights" do
    url "https://files.pythonhosted.org/packages/d8/ec/4af9af212e5680831208e12874dd064dfdd5a0876af0edfe15be79c04f0e/azure-mgmt-policyinsights-1.1.0b4.zip"
    sha256 "681d7ac72ae13581c97a2b6f742795fa48a4db50762c2fb9fce4834081b04e92"
  end

  resource "azure-mgmt-postgresqlflexibleservers" do
    url "https://files.pythonhosted.org/packages/52/f2/7cc422a144074a30e88bd5d5ca8e12100ca2a90791fef82a1e962bea816f/azure_mgmt_postgresqlflexibleservers-1.1.0b2.tar.gz"
    sha256 "f0eb026f275f97bf95ae82cd58e30a760fff2944a7f4a80fc285aaf8da070934"
  end

  resource "azure-mgmt-privatedns" do
    url "https://files.pythonhosted.org/packages/72/f0/e8e401da635a72936c7edc32d4fdb7fcc4572400e0d66ed6ff6978b935a9/azure-mgmt-privatedns-1.0.0.zip"
    sha256 "b60f16e43f7b291582c5f57bae1b083096d8303e9d9958e2c29227a55cc27c45"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/ad/48/a494ad47d0ea08d1f9a29abcd241787d2513b5727ac6f3836a66487eaf39/azure-mgmt-rdbms-10.2.0b17.tar.gz"
    sha256 "d679d1932af8226efd07b0c3a86cff14eacf013a05686844f9aeebe5b64cb8e4"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https://files.pythonhosted.org/packages/fa/52/bb554f77c7e73f4ddf9833abfbc183a073f26a20453034c54798c0c9bb44/azure-mgmt-recoveryservices-3.0.0.tar.gz"
    sha256 "df212dfadfbcc659c31231c3e170aab7c21144d172b0f88268ab0f5ad8e95882"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/d1/10/e3d49f12842a84de410f8ed9831d6dcf6ee04e993f79fe4eb33adf1a9265/azure-mgmt-recoveryservicesbackup-9.1.0.tar.gz"
    sha256 "1e9fd406c0c9ee2627f5a371f012f877342f7fc6f33b2564fcd14d6f0663cd0f"
  end

  resource "azure-mgmt-redhatopenshift" do
    url "https://files.pythonhosted.org/packages/01/a2/b89ba36f4bc2708a7ab0115b451028b8888184b3c19bd9a3ac71afec8941/azure-mgmt-redhatopenshift-1.5.0.tar.gz"
    sha256 "51fb7429c39c88acc9fa273d9f89f19303520662996a6d7d8e1122a98f5f2527"
  end

  resource "azure-mgmt-redis" do
    url "https://files.pythonhosted.org/packages/7c/e2/7e4895296df120458af54186d788cb43abb95676e0a075c154606b8772ab/azure_mgmt_redis-14.5.0.tar.gz"
    sha256 "5c3434c82492688e25b93aaf5113ecff0b92b7ad6da2a4fd4695530f82b152fa"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/89/60/19471f7f2499888da9d5abc7ff8c470a6d620fbf35657fff31df9eeb483d/azure-mgmt-resource-23.1.1.tar.gz"
    sha256 "20b6b006b544fdb19607f3f6a381105625e0bb60fbf3036f39885c4646d3343e"
  end

  resource "azure-mgmt-search" do
    url "https://files.pythonhosted.org/packages/c5/52/70315fa90fddd4ac681ecf39ce63e81254e4aa972be3ad94a29eb5e8e24d/azure-mgmt-search-9.0.0.zip"
    sha256 "19cfaaa136b5104e3f62626f512a951becd9e74c1fa21bd639efdf2c9fef81bd"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/25/b2/bbe822bca8dc617ac5fab0eb40e5786a2ed933b484a3238af5b7a19e6deb/azure-mgmt-security-6.0.0.tar.gz"
    sha256 "ceafc1869899067110bd830c5cc98bc9b8f32d8ea840ca1f693b1a5f52a5f8b0"
  end

  resource "azure-mgmt-servicebus" do
    url "https://files.pythonhosted.org/packages/f9/fa/88014c3bd2fe34694184e9ced1b8230de495bcf2eb368c0bfc82db36dc12/azure-mgmt-servicebus-8.2.0.zip"
    sha256 "8be9208f141d9a789f68db8d219754ff78069fd8f9390e9f7644bb95a3be9ec2"
  end

  resource "azure-mgmt-servicefabric" do
    url "https://files.pythonhosted.org/packages/55/74/056878a1bbe4f07a49ac8479a587ae73c0d7d719cce3b540d4b22af44e81/azure-mgmt-servicefabric-2.1.0.tar.gz"
    sha256 "a08433049554436c90844bc8a96820e883699484e6ffc99032fd2571f8c5f7d6"
  end

  resource "azure-mgmt-servicefabricmanagedclusters" do
    url "https://files.pythonhosted.org/packages/4f/68/d707b2a7fc64cbb42d1e57a183b332dfe8746deca58577a78c4fe42b803e/azure_mgmt_servicefabricmanagedclusters-2.1.0b1.tar.gz"
    sha256 "2b16b93c8446e13372e28b378f635da1ad2aa631d9547b31b9fa3b7bc56d0f63"
  end

  resource "azure-mgmt-servicelinker" do
    url "https://files.pythonhosted.org/packages/81/b2/747b748a16f934f65eec2c37fbab23144b63365483ab19436a921d42ae31/azure_mgmt_servicelinker-1.2.0b3.tar.gz"
    sha256 "c51c111fb76c59e58fceccfecfd119f8c83e4d64fdca77a46b62d81ec6a3ea29"
  end

  resource "azure-mgmt-signalr" do
    url "https://files.pythonhosted.org/packages/5e/0d/fbdf31df60d756790470a50a9c0d5a51db3e16cc42ea66377190ab9ed1b8/azure-mgmt-signalr-2.0.0b2.tar.gz"
    sha256 "d393d457ca2e00aabfc611b1544588cc3a29d1aed60d35799865520b8b2ff4fe"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/f3/16/3d39ef63b655ad47fe35aea5d9e0884cf36c84d794d5b2effc71758cd0de/azure_mgmt_sql-4.0.0b21.tar.gz"
    sha256 "4ad3a68025363b34792ac0d9b7ec605d0bff8ff198a664ce09c9bb2afb62d831"
  end

  resource "azure-mgmt-sqlvirtualmachine" do
    url "https://files.pythonhosted.org/packages/8c/9a/b5f0ebf6b82df07a55556bfb18388d09582e50369b6a69e85b0df66dcb02/azure-mgmt-sqlvirtualmachine-1.0.0b5.zip"
    sha256 "6458097e58329d14b1a3e07e56ca38797d4985e5a50d08df27d426ba95f2a4c7"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/ca/d2/f06af604fe54231f049c861dd1556495c95ad95620ed3b14337c3e164913/azure_mgmt_storage-22.1.0.tar.gz"
    sha256 "727b8c8be4aca4551a9b921cdf76bb92b1e988d009de3b983ce72b7343b749e9"
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
    url "https://files.pythonhosted.org/packages/7f/a4/a47081049ae17378b920518db566587c5691ed52c15802a2b418912081ad/azure-mgmt-web-7.3.1.tar.gz"
    sha256 "87b771436bc99a7a8df59d0ad185b96879a06dce14764a06b3fc3dafa8fcb56b"
  end

  resource "azure-monitor-query" do
    url "https://files.pythonhosted.org/packages/ad/16/fd06cccfc583d8d38d8d99ee92ec1bbc9604cf6e8c62e64ddca5644e0a60/azure-monitor-query-1.2.0.zip"
    sha256 "2c57432443f203069e64e500c7e958ca31650f641950515ffe65555ba134c371"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/38/98/cc60dc8b0efcf828555c2cffe6a097184782b1a7be35aeec82eb78b4fe1a/azure-multiapi-storage-1.4.0.tar.gz"
    sha256 "45f15dfb5c4bda8b9627734b5cc72c45f436d796e2e216be88239c6178cd0f71"
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
    url "https://files.pythonhosted.org/packages/be/9a/32e71b8f048d0e7cf5b6df3d652c102368de40180834956fcc968fe0c1ff/azure_synapse_artifacts-0.20.0.tar.gz"
    sha256 "3ed6c142faf62d3191a943b3222547f7730d4cbc10355d17d64fa77e0421644a"
  end

  resource "azure-synapse-managedprivateendpoints" do
    url "https://files.pythonhosted.org/packages/14/85/3f7224fb15155be1acd9d5cb2a5ac0575b617cade72a890f09d35b175ad7/azure-synapse-managedprivateendpoints-0.4.0.zip"
    sha256 "900eaeaccffdcd01012b248a7d049008c92807b749edd1c9074ca9248554c17e"
  end

  resource "azure-synapse-spark" do
    url "https://files.pythonhosted.org/packages/bd/59/2b505c6465b05065760cc3af8905835680ef63164d9739311c275be339d4/azure-synapse-spark-0.7.0.zip"
    sha256 "86fa29463a24b7c37025ff21509b70e36b4dace28e5d92001bc920488350acd5"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c2/02/a95f2b11e207f68bc64d7aae9666fed2e2b3f307748d5123dffb72a1bbea/certifi-2024.7.4.tar.gz"
    sha256 "5a1e7645bc0ec61a09e26c36f6106dd4cf40c6db3a1fb6352b0244e7fb057c7b"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/c7/67/545c79fe50f7af51dbad56d16b23fe33f63ee6a5d956b3cb68ea110cbe64/cryptography-44.0.1.tar.gz"
    sha256 "f51f5705ab27898afda1aaa430f34ad90dc117421057782022edf0600bec5f14"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fabric" do
    url "https://files.pythonhosted.org/packages/0d/3f/337f278b70ba339c618a490f6b8033b7006c583bd197a897f12fbc468c51/fabric-3.2.2.tar.gz"
    sha256 "8783ca42e3b0076f08b26901aac6b9d9b1f19c410074e7accfab902c184ff4a3"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/f9/42/127e6d792884ab860defc3f4d80a8f9812e48ace584ffc5a346de58cdc6c/invoke-2.2.0.tar.gz"
    sha256 "ee6cbb101af1a859c7fe84f2a264c059020b0cb7fe3535f9424300ab568f6bd5"
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
    url "https://files.pythonhosted.org/packages/0c/5b/7cc69b2941a11bdace4faffef8f023543feefd14ab0222b6e62a318c53b9/knack-0.11.0.tar.gz"
    sha256 "eb6568001e9110b1b320941431c51033d104cc98cda2254a5c2b09ba569fd494"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/3f/90/81dcc50f0be11a8c4dcbae1a9f761a26e5f905231330a7cacc9f04ec4c61/msal-1.32.3.tar.gz"
    sha256 "5eea038689c78a5a70ca8ecbe1245458b55a857bd096efb6989c69ba15985d35"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/2d/38/ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5eb/msal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
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
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1b/0f/c00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609b/paramiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
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
    url "https://files.pythonhosted.org/packages/26/10/2a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310/psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/d8/6b/6287745054dbcccf75903630346be77d4715c594402cec7c2518032416c2/PyJWT-2.4.0.tar.gz"
    sha256 "d42908208c699b3b973cbeb01a969ba6a96c821eefb1c5bfe4c390c01d67abba"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "microsoft-security-utilities-secret-masker" do
    url "https://files.pythonhosted.org/packages/e8/1a/6fa5c0ba55ed62e17df010af8a3a71ffea701c3d414b4688834c527d5aeb/microsoft_security_utilities_secret_masker-1.0.0b4.tar.gz"
    sha256 "a30bd361ac18c8b52f6844076bc26465335949ea9c7a004d95f5196ec6fdef3e"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/79/67/c06f625e2968c417052b3a4a0eef40656d5d4d44033e57b40ec474af1d28/pip-25.1.tar.gz"
    sha256 "272bdd1289f80165e9070a4f881e8f9e1001bbb50378561d1af20e49bf5a2200"
  end

  resource "py-deviceid" do
    url "https://files.pythonhosted.org/packages/0c/fe/1beb99282853f4f6fd32af50dc1f77d15e8883627bf5014a14a7eb024963/py_deviceid-0.1.1.tar.gz"
    sha256 "c3e7577ada23666e7f39e69370dfdaa76fe9de79c02635376d6aa0229bfa30e3"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/9f/26/e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5/pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "pycomposefile" do
    url "https://files.pythonhosted.org/packages/a3/77/031cfe69eb2075f7479a1fc9913ed8b131001e5a94dc450b7704997e5246/pycomposefile-0.0.32.tar.gz"
    sha256 "a355d515c4c4ff92ee5a16590de8b367a3be4827046592d0870f8cb6ac4a6e34"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/44/80/97e25f0f1e4067677806084b7382a6ff9979f3d15119375c475c288db9d7/setuptools-80.0.0.tar.gz"
    sha256 "c40a5b3729d58dd749c0f08f1a07d134fb8a0a3d7f87dc33e7c5e1f762138650"
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
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c8/93/65e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1b/urllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8d/12/cd10d050f7714ccc675b486cdcbbaed54c782a5b77da2bb82e5c7b31fb40/websocket-client-1.3.1.tar.gz"
    sha256 "6278a75065395418283f887de7c3beafb3aa68dada5cacbe4b214e8d26da499b"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    venv = virtualenv_create(libexec, "python3.12", system_site_packages: false)
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

    (bin/"az").write <<~SHELL
      #!/usr/bin/env bash
      AZ_INSTALLER=HOMEBREW #{libexec}/bin/python -Im azure.cli "$@"
    SHELL

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "az",
                                         base_name: "az", shell_parameter_format: :arg)
  end

  test do
    json_text = shell_output("#{bin}/az cloud show --name AzureCloud")
    azure_cloud = JSON.parse(json_text)
    assert_equal azure_cloud["name"], "AzureCloud"
    assert_equal azure_cloud["endpoints"]["management"], "https://management.core.windows.net/"
    assert_equal azure_cloud["endpoints"]["resourceManager"], "https://management.azure.com/"
  end
end
