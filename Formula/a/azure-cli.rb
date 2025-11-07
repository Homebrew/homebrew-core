class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://github.com/Azure/azure-cli/archive/refs/tags/azure-cli-2.79.0.tar.gz"
  sha256 "79fb9c8e0b063144ca0f671c18b23847e4096d204bfc2323997a40ae8a4039d4"
  license "MIT"
  head "https://github.com/Azure/azure-cli.git", branch: "dev"

  livecheck do
    url :stable
    regex(/azure-cli[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f14426c9ab39d35ddd78d7402945250ac4cb7b2cba1da7c9fbb98de06ad5d40"
    sha256 cellar: :any,                 arm64_sequoia: "88dbf609d3936910a78e06d02d8323a437101c02b4789181c8b154b701094d23"
    sha256 cellar: :any,                 arm64_sonoma:  "33c9695ccd0f09e08521867e1bb4cc18aad7db31f2ca222f18a4060e3e6cda34"
    sha256 cellar: :any,                 sonoma:        "e95448623f70b684726d540443a8820622ec94098569d089a3f9bf052987a4d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d21aac960fc64468118accc638aee0d69fed5d07944ea47238dbf458b8e9194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5adacf466a746fb096d201d66cad99230682304b71079cb34e82ad1a6c853ef"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "cryptography"],
                extra_packages:   ["distro"]

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/33/5f/2cdf6f7aca3b20d3f316e9f505292e1f256a32089bd702034c29ebde6242/antlr4_python3_runtime-4.13.2.tar.gz"
    sha256 "909b647e1d2fc2b70180ac586df3933e38919c85f98ccc656a96cd3f25ef3916"
  end

  resource "applicationinsights" do
    url "https://files.pythonhosted.org/packages/d3/f2/46a75ac6096d60da0e71a068015b610206e697de01fa2fb5bba8564b0798/applicationinsights-0.11.10.tar.gz"
    sha256 "0b761f3ef0680acf4731906dfc1807faa6f2a57168ae74592db0084a6099f7b3"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  resource "azure-appconfiguration" do
    url "https://files.pythonhosted.org/packages/d3/9f/f2a9ab639df9f9db2112ded1c6286d1a685f6dadc8b56fc1f1d5faed8c57/azure_appconfiguration-1.7.2.tar.gz"
    sha256 "cefd75b298b898a8ed9f73048f3f39f4e81059a58cd832d0523787fc1d912a06"
  end

  resource "azure-batch" do
    url "https://files.pythonhosted.org/packages/34/e8/6a1354d9fd22a84a83f009915598b823a7d9cb60e39cd28661b9c54d1121/azure_batch-15.0.0b1.tar.gz"
    sha256 "dfbddd158ffade52193e3e4d86c996ea7236ffd2695a43734fae5e05a974e2ed"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/15/6b/2653adc0f33adba8f11b1903701e6b1c10d34ce5d8e25dfa13a422f832b0/azure_core-1.35.1.tar.gz"
    sha256 "435d05d6df0fff2f73fb3c15493bb4721ede14203f1ff1382aa6b6b2bdd7e562"
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
    url "https://files.pythonhosted.org/packages/74/58/41042543710a3a0be3bd1b7851c790a3087cdbf4c8eb14efcd7a0a910ea7/azure_datalake_store-1.0.1.tar.gz"
    sha256 "5364d4445aab154a1c7cb10215629c3ce46ce5c7aaaf16071890c03fae53a035"
  end

  resource "azure-keyvault-administration" do
    url "https://files.pythonhosted.org/packages/a9/7c/6f6fb2e13eb0628ed5b2708058ea48746ffaf1dfde59f94ca792eceb11e1/azure-keyvault-administration-4.4.0.tar.gz"
    sha256 "7a6b36cb9f544f35750ff2fa94c83b97b3ef20c1fe1b424ea68018eee703f1df"
  end

  resource "azure-keyvault-certificates" do
    url "https://files.pythonhosted.org/packages/e6/cf/85d521e65557e4dee2cd9c700f518c3a46f6f71068e61c07d0b13b2e0727/azure-keyvault-certificates-4.7.0.zip"
    sha256 "9e47d9a74825e502b13d5481c99c182040c4f54723f43371e00859436dfcf3ca"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/69/ed/450c9389d76be1a95a056528ec2b832a3721858dd47b1f4eb12dab7060a1/azure_keyvault_keys-4.11.0.tar.gz"
    sha256 "f257b1917a2c3a88983e3f5675a6419449eb262318888d5b51e1cb3bed79779a"
  end

  resource "azure-keyvault-secrets" do
    url "https://files.pythonhosted.org/packages/5c/a1/78ecabf98e97d600dcac1559ff64b4bc9f84eca126c0aeba859916832b0c/azure-keyvault-secrets-4.7.0.zip"
    sha256 "77ee2534ba651a1f306c85d7b505bc3ccee8fea77450ebafafc26aec16e5445d"
  end

  resource "azure-keyvault-securitydomain" do
    url "https://files.pythonhosted.org/packages/a6/18/3a67754d999a0244f3551c8c28031cdfb5d2b6f072df6b55fc2bf2e69ec5/azure_keyvault_securitydomain-1.0.0b1.tar.gz"
    sha256 "3291a191e778a947e4b28ed01327892a93aedcf8e0a0dd674cf116cb11043776"
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
    url "https://files.pythonhosted.org/packages/02/96/864552c912934cef3feec816f3012fddaa5b5d8dacb59d01ddbe8c6a4fa3/azure_mgmt_appconfiguration-5.0.0.tar.gz"
    sha256 "f8f0f81b790d1ed77bbc052ecdcf7b13091fad88b10c1f3f471000dbd9c20977"
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
    url "https://files.pythonhosted.org/packages/a6/dc/f62c0f30274cd06b9afa5f997326e31b05e673a2922333117c8ebaa64e14/azure_mgmt_authorization-5.0.0b1.tar.gz"
    sha256 "2b96eab3a61ef9dd84776a476482e82726013bfe110262d90619685b235e5737"
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
    url "https://files.pythonhosted.org/packages/77/b5/a9dc9413e69e2e1b31885771173cb70018847a4c2bcd2f53c6e375ae1cad/azure-mgmt-botservice-2.0.0.zip"
    sha256 "86c04d27c527c19d9600a88215fae2ba524dc674455387b0d0e51722b5a6d6ba"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/d7/fc/48310b510043223c42ea2f9ac1e91a9a88b7438c0882d4c32db9f0b9fb0c/azure-mgmt-cdn-12.0.0.zip"
    sha256 "b7c3ee2189234b4af51ace2924927c5fd733f3de748a642d6d5040067c8c9ddd"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/f7/4b/428c41c3aacad9506e65bd67055cc8ea950857ce4161b6bd895ed44e37f2/azure_mgmt_cognitiveservices-13.7.0.tar.gz"
    sha256 "48a5a44c15c6768bad238011aaac83a806ceb8ace1b51b8043e35b39a9167a19"
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
    url "https://files.pythonhosted.org/packages/b2/38/833c885a044fc1285773b00c618ac5216d8a63c8dd269c7df984b2660c60/azure_mgmt_containerregistry-14.1.0b1.tar.gz"
    sha256 "c3f3c8a0f73aa24a19b64c0187db7ec455453efe1df303fbee983922515baa6f"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/f1/d8/57a59d50f2287809af2f5a3dd4092ab58a6dfd98b992c3a137911a3c50d2/azure_mgmt_containerservice-40.0.0.tar.gz"
    sha256 "6c52a0cd5d55520ef028ea90b72bd8d1328f80d0ce697434ef61c5068626af6f"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/a1/cd/b5d1eac32515370da90454fe64500d29e20daffd15575550fca5628eb300/azure_mgmt_cosmosdb-9.8.0.tar.gz"
    sha256 "214ee47165387e578f86e6611fb329b4d54dc295ad79da37b9d92c5d6d20d1b1"
  end

  resource "azure-mgmt-datalake-store" do
    url "https://files.pythonhosted.org/packages/70/61/e16aaf70be45eae80aaeb4bd2d4b4101bc6e6dbe301d9ab4c22572808ea7/azure-mgmt-datalake-store-1.1.0b1.zip"
    sha256 "5a275768bc1bd918caa0e65df9bae28b74e6fdf3dc9ea7e24aed75ffb499cb64"
  end

  resource "azure-mgmt-datamigration" do
    url "https://files.pythonhosted.org/packages/06/47/cccd2c22f8f525b8a1c38fd88ffef7ae989f50bd15f1ad5b955e27ef5985/azure-mgmt-datamigration-10.0.0.zip"
    sha256 "5cee70f97fe3a093c3cb70c2a190c2df936b772e94a09ef7e3deb1ed177c9f32"
  end

  resource "azure-mgmt-eventgrid" do
    url "https://files.pythonhosted.org/packages/ff/ef/2d48ac5af17c3ae32feaf40769e4579ca47c4d1c5a6798f149faf0397b65/azure-mgmt-eventgrid-10.2.0b2.zip"
    sha256 "41c1d8d700b043254e11d522d3aff011ae1da891f909c777de02754a3bb4a990"
  end

  resource "azure-mgmt-eventhub" do
    url "https://files.pythonhosted.org/packages/6c/e5/d56993e6334d53ada0b45a07266bafde48d14c72ba9473211b606d95ecf0/azure_mgmt_eventhub-12.0.0b1.tar.gz"
    sha256 "e7bdf166c32de7aef5a626953f536ca4f1c6115f16795354c8c3f38f1da1fe10"
  end

  resource "azure-mgmt-extendedlocation" do
    url "https://files.pythonhosted.org/packages/b7/de/a7b62f053597506e01641c68e1708222f01cd7574e4147d4f645ff6e6aaa/azure-mgmt-extendedlocation-1.0.0b2.zip"
    sha256 "9a37c7df94fcd4943dee35601255a667c3f93305d5c5942ffd024a34b4b74fc0"
  end

  resource "azure-mgmt-hdinsight" do
    url "https://files.pythonhosted.org/packages/4a/50/598359f4aeb3dc7b9d74815ee113138088bca3b095230d9e54da3f76f33a/azure_mgmt_hdinsight-9.1.0b2.tar.gz"
    sha256 "5b0d1335e2c1a73bc0891abbb178dc006309756d1e0bc5766c1832b9fb442717"
  end

  resource "azure-mgmt-imagebuilder" do
    url "https://files.pythonhosted.org/packages/06/a0/5996570f011ddab6dfcc19c5bf64056370c255ffbbd2232447f88f24e5d1/azure-mgmt-imagebuilder-1.3.0.tar.gz"
    sha256 "3f325d688b6125c2fa92681e5b18ea407ba032d5be3f7c0724406d733e6c14ef"
  end

  resource "azure-mgmt-iotcentral" do
    url "https://files.pythonhosted.org/packages/d3/c7/87f88bace5652407987de3bf2f4b5e9b19e204801efbc0207f0ec81386e5/azure-mgmt-iotcentral-10.0.0b2.zip"
    sha256 "0366753a58884951de5554872453b0b3281a0147fd2dc97cec048a589f08c6e4"
  end

  resource "azure-mgmt-iothub" do
    url "https://files.pythonhosted.org/packages/c9/41/e44db1427723bd768e7bfd3f0cebd93406878997b3035a982fc3f657f18f/azure_mgmt_iothub-5.0.0b1.tar.gz"
    sha256 "091f19a2917b5b486d87c88e04662a90520666233d870746aee70284d6556204"
  end

  resource "azure-mgmt-iothubprovisioningservices" do
    url "https://files.pythonhosted.org/packages/47/78/b5252f7e42d596d0e8ab4d7ea5f90545436d83c4bf45f1e86d7618d128db/azure-mgmt-iothubprovisioningservices-1.1.0.zip"
    sha256 "d383a826e7dff772fad86e88a33a661e911a51b1c71c3ea72a590c1d5a09bc9e"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/ca/79/a2200a22c0aa36a85b9e9d93a0702adf75afcf3b79791041ee9872d7a940/azure_mgmt_keyvault-12.1.0.tar.gz"
    sha256 "ced572c166354db5db89c9bbe5e215f607c46eabeaac1211138bb9db5de421d3"
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
    url "https://files.pythonhosted.org/packages/0e/12/25874f6b894e972646244f570a23298969b58f57cfb7a188e2740017b43a/azure_mgmt_monitor-7.0.0.tar.gz"
    sha256 "b75f536441d430f69ff873a1646e5f5dbcb3080a10768a59d0adc01541623816"
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
    url "https://files.pythonhosted.org/packages/86/0d/eb3e3928a38e365d2301b9dc08700e0af5474c44542d36c8adf3d5c193c8/azure_mgmt_recoveryservices-4.0.0.tar.gz"
    sha256 "a1429cfd283a9c9950ac153482fa9c9741646fd20da8aa9c3c81e725c78c5c9f"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/72/28/99997bb991c8d1d53ec1164a4f07adc520e3c10c55b7e0b814f6e6c6043e/azure_mgmt_recoveryservicesbackup-9.2.0.tar.gz"
    sha256 "c402b3e22a6c3879df56bc37e0063142c3352c5102599ff102d19824f1b32b29"
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
    url "https://files.pythonhosted.org/packages/a7/28/e950da2d89e55e2315ff0f4de075da4ac0fed4c27a489f7c774dedde9854/azure_mgmt_resource-23.3.0.tar.gz"
    sha256 "fc4f1fd8b6aad23f8af4ed1f913df5f5c92df117449dc354fea6802a2829fea4"
  end

  resource "azure-mgmt-resource-deployments" do
    url "https://files.pythonhosted.org/packages/28/64/80b5e10c21d82c79ee2050ed5d2859c725207617dfa30cf7e72f112ad2fb/azure_mgmt_resource_deployments-1.0.0b1.tar.gz"
    sha256 "7359b42658826e7e7ff13e6dbb0c490e95fcc95dbca224d2b85cf71ad7535f1d"
  end

  resource "azure-mgmt-resource-deploymentscripts" do
    url "https://files.pythonhosted.org/packages/eb/b0/60718c1a96bd4d1c08a7d6bdb620f7fa8740b30f1a0f7796e124d333970d/azure_mgmt_resource_deploymentscripts-1.0.0b1.tar.gz"
    sha256 "566d855953e949bb2b34cb43e1e73054aaa79281c74613b745ffddb82c802375"
  end

  resource "azure-mgmt-resource-deploymentstacks" do
    url "https://files.pythonhosted.org/packages/85/60/870f4fe84574891283b555419b0a45c0828e06d28596fc9bdf3b65692bc0/azure_mgmt_resource_deploymentstacks-1.0.0b1.tar.gz"
    sha256 "49b876e45c0f5bab88ec47d7c56e8fb34fbdfcfe5b831a3a2a21e817f3d9732e"
  end

  resource "azure-mgmt-resource-templatespecs" do
    url "https://files.pythonhosted.org/packages/e6/8d/2b85183b2bef5efef239b96bb33a6a6025593f6617958001d608ff82958a/azure_mgmt_resource_templatespecs-1.0.0b1.tar.gz"
    sha256 "0f9e739ab43db2ad870eae5df1b5c4bfa0500bbea1c6e58aa5e2e9c385facbc5"
  end

  resource "azure-mgmt-search" do
    url "https://files.pythonhosted.org/packages/68/a2/df10a6b0ccf903a2f5a712d0ee49cd863d1c04cb594808627ae4efd4e026/azure_mgmt_search-9.2.0.tar.gz"
    sha256 "a0da0ec332d1f43d0f6acb63b8cfd80085b075e91afcf812f8c769ad9fdcad84"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/25/b2/bbe822bca8dc617ac5fab0eb40e5786a2ed933b484a3238af5b7a19e6deb/azure-mgmt-security-6.0.0.tar.gz"
    sha256 "ceafc1869899067110bd830c5cc98bc9b8f32d8ea840ca1f693b1a5f52a5f8b0"
  end

  resource "azure-mgmt-servicebus" do
    url "https://files.pythonhosted.org/packages/42/c6/2dbb6d6a10665b93f77c815598586efafc5df2a095cf62613babf16ab02d/azure_mgmt_servicebus-10.0.0b1.tar.gz"
    sha256 "bbbc6db9c4bc067fb08271f8eda356129d6051c4538977a8f375120f4e63f79c"
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
    url "https://files.pythonhosted.org/packages/a3/4a/e41603713e2626100e11208cb047799395eb5d89c4162c7b3d20245000eb/azure_mgmt_sql-4.0.0b22.tar.gz"
    sha256 "92edd837d5bd0b2c78cec2b102ce24f7fa1e0d7029ce2daea80511a9aef61f49"
  end

  resource "azure-mgmt-sqlvirtualmachine" do
    url "https://files.pythonhosted.org/packages/8c/9a/b5f0ebf6b82df07a55556bfb18388d09582e50369b6a69e85b0df66dcb02/azure-mgmt-sqlvirtualmachine-1.0.0b5.zip"
    sha256 "6458097e58329d14b1a3e07e56ca38797d4985e5a50d08df27d426ba95f2a4c7"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/fb/42/b01a1c451417ac05229d986f5755a411bec7922c5eb5170d54642c2118df/azure_mgmt_storage-24.0.0.tar.gz"
    sha256 "b1ae225ef87ada85f29c02e406140ab5895285ca64de2bcfe50b631c4818a337"
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
    url "https://files.pythonhosted.org/packages/6c/b9/1baee7b05ece33dcc88e3a2e8b93dbbfec0d848f0e9fcfa1c34bed53d987/azure_mgmt_web-9.0.0.tar.gz"
    sha256 "4455ecd3b498577085c1904e6d17139254e358ba07fe6c4835a891bbaf7b06c2"
  end

  resource "azure-monitor-query" do
    url "https://files.pythonhosted.org/packages/ad/16/fd06cccfc583d8d38d8d99ee92ec1bbc9604cf6e8c62e64ddca5644e0a60/azure-monitor-query-1.2.0.zip"
    sha256 "2c57432443f203069e64e500c7e958ca31650f641950515ffe65555ba134c371"
  end

  resource "azure-multiapi-storage" do
    url "https://files.pythonhosted.org/packages/cb/b0/2f1e20f8ef180b38f48a12c4c41dbcf74c1657653837b029d25754175211/azure_multiapi_storage-1.6.0.tar.gz"
    sha256 "8942e3f4edbeddd23cda19acee796076fbcd1a40e46f9aa1110ffda314e31c55"
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
    url "https://files.pythonhosted.org/packages/17/b6/08aa179e85836089f541b8805e18e9eaca507dc2d8e608f5e9c2e893d4b3/azure_synapse_artifacts-0.21.0.tar.gz"
    sha256 "d7e37516cf8569e03c604d921e3407d7140cf7523b67b67f757caf999e3c8ee7"
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
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "javaproperties" do
    url "https://files.pythonhosted.org/packages/b9/83/7a2afd88fb367a24bc40361d654e54421ea34aaae5a7a32d73542cf9cff3/javaproperties-0.5.2.tar.gz"
    sha256 "68add3438bd24d6e32665cad91f254fc82a51bf905e21f3f424a085c79904fb3"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsondiff" do
    url "https://files.pythonhosted.org/packages/dd/13/2b691afe0a90fb930a32b8fc1b0fd6b5bdeaed459a32c5a58dc6654342da/jsondiff-2.0.0.tar.gz"
    sha256 "2795844ef075ec8a2b8d385c4d59f5ea48b08e7180fce3cb2787be0db00b1fb4"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/0c/5b/7cc69b2941a11bdace4faffef8f023543feefd14ab0222b6e62a318c53b9/knack-0.11.0.tar.gz"
    sha256 "eb6568001e9110b1b320941431c51033d104cc98cda2254a5c2b09ba569fd494"
  end

  resource "microsoft-security-utilities-secret-masker" do
    url "https://files.pythonhosted.org/packages/e8/1a/6fa5c0ba55ed62e17df010af8a3a71ffea701c3d414b4688834c527d5aeb/microsoft_security_utilities_secret_masker-1.0.0b4.tar.gz"
    sha256 "a30bd361ac18c8b52f6844076bc26465335949ea9c7a004d95f5196ec6fdef3e"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/b3/99/b443d095e0e9d4ec7f46cd60c921f9d24904afb889bf884e8550b8326f02/msal-1.34.0b1.tar.gz"
    sha256 "86cdbfec14955e803379499d017056c6df4ed40f717fd6addde94bdeb4babd78"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/2d/38/ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5eb/msal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/7d/15/ad6ce226e8138315f2451c2aeea985bf35ee910afb477bae7477dc3a8f3b/paramiko-3.5.1.tar.gz"
    sha256 "b2c665bc45b2b215bd7d7f039901b14b067da00f3a11e6640995fd58f2664822"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/24/03/e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87/pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "py-deviceid" do
    url "https://files.pythonhosted.org/packages/0c/fe/1beb99282853f4f6fd32af50dc1f77d15e8883627bf5014a14a7eb024963/py_deviceid-0.1.1.tar.gz"
    sha256 "c3e7577ada23666e7f39e69370dfdaa76fe9de79c02635376d6aa0229bfa30e3"
  end

  resource "pycomposefile" do
    url "https://files.pythonhosted.org/packages/60/a3/ac3d9c20fb22216b212a8b2f52e24d5b203c29c80e61dd1348bd18c2ac58/pycomposefile-0.0.34.tar.gz"
    sha256 "933a93b439f8692882b4d50ff744e12a3d996040068e96651a37dd842126a508"
  end

  resource "pygithub" do
    url "https://files.pythonhosted.org/packages/fb/30/203d3420960853e399de3b85d6613cea1cf17c1cf7fc9716f7ee7e17e0fc/PyGithub-1.59.1.tar.gz"
    sha256 "c44e3a121c15bf9d3a5cc98d94c9a047a5132a9b01d22264627f58ade9ddc217"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/10/fc/26467959b83c3f68a8dda16cfd09d856008a5caa66a0f7d726c44023fb8a/scp-0.13.6.tar.gz"
    sha256 "0a72f9d782e968b09b114d5607f96b1f16fe9942857afb355399edd55372fcf1"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sshtunnel" do
    url "https://files.pythonhosted.org/packages/c5/5c/4b320d7ec4b0d5d4d6df1fdf66a5799625b3623d0ce4efe81719c6f8dfb3/sshtunnel-0.1.5.tar.gz"
    sha256 "c813fdcda8e81c3936ffeac47cb69cfb2d1f5e77ad0de656c6dab56aeebd9249"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/0e/e7/e705ead133d21de4be752af4b3a0cb1f02514ff45bf165b3955c1ce22077/websocket-client-1.3.3.tar.gz"
    sha256 "d58c5f284d6a9bf8379dab423259fe8f85b70d5fa5d2916d5791a84594b122b1"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/19/5e5bcd855d808892fe02d49219f97a50f64cd6d8313d75df3494ee97b1a3/wrapt-2.0.0.tar.gz"
    sha256 "35a542cc7a962331d0279735c30995b024e852cf40481e384fd63caaa391cbb9"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/d7/7a/42f705c672e77dc3ce85a6823bb289055323aac30de7c4b9eca1e28b2c17/xmltodict-0.15.1.tar.gz"
    sha256 "3d8d49127f3ce6979d40a36dbcad96f8bab106d232d24b49efdd4bd21716983c"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    venv = virtualenv_create(libexec, "python3.14", system_site_packages: false)
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
