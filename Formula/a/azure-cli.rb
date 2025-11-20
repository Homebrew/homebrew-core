class AzureCli < Formula
  include Language::Python::Virtualenv

  desc "Microsoft Azure CLI 2.0"
  homepage "https://docs.microsoft.com/cli/azure/overview"
  url "https://github.com/Azure/azure-cli/archive/refs/tags/azure-cli-2.80.0.tar.gz"
  sha256 "6bd1234b77a9b8981fa3ec733569ea83e54bb0cdb3c81cec0dba9b2595e64eaa"
  license "MIT"
  head "https://github.com/Azure/azure-cli.git", branch: "dev"

  livecheck do
    url :stable
    regex(/azure-cli[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14192e77542e83a3fd6f74a9db50464e534496afe738a7cf343cd0d66ba50978"
    sha256 cellar: :any,                 arm64_sequoia: "7367a5f35711d2e539296baa81763e2fc5e3ef269baebc044e748a6e4f03e827"
    sha256 cellar: :any,                 arm64_sonoma:  "aedc4ec7795e852a318a6e1532ac4dc61beaceab52e222ef581817bb3ab21886"
    sha256 cellar: :any,                 sonoma:        "ed0b870224c7230c37297da8772bbb4e83c81b7bd848a0a12600035773d0efe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19460f9744ae2acaf90aaadd8a5f49d5842ab2d14e697f3324ae6396a697a722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c304cf39938bab577556e939cdcb894dbffd1d0bf681d898db016d4dd0c021"
  end

  # `pkgconf`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "PyGithub" do
    url "https://files.pythonhosted.org/packages/98/36/386d282903c572b18abc36de68aaf4146db4659c82dceee009ef88a86b67/PyGithub-1.55.tar.gz"
    sha256 "1bbfff9372047ff3f21d5cd8e07720f3dbfdaf6462fcaed9d815f528f1ba7283"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
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

  resource "azure-ai-projects" do
    url "https://files.pythonhosted.org/packages/dd/95/9c04cb5f658c7f856026aa18432e0f0fa254ead2983a3574a0f5558a7234/azure_ai_projects-1.0.0.tar.gz"
    sha256 "b5f03024ccf0fd543fbe0f5abcc74e45b15eccc1c71ab87fc71c63061d9fd63c"
  end

  resource "azure-ai-agents" do
    url "https://files.pythonhosted.org/packages/39/98/bbe2e9e5b0a934be1930545025bf7018ebc4cc33b10134cc3314d6487076/azure_ai_agents-1.1.0.tar.gz"
    sha256 "eb9d7226282d03206c3fab3f3ee0a2fc71e0ad38e52d2f4f19a92c56ed951aea"
  end

  resource "azure-appconfiguration" do
    url "https://files.pythonhosted.org/packages/2c/ff/cd3804d1aa1789f393a3174ca2b701edf7f0092c615ab384fd065afd4433/azure-appconfiguration-1.7.1.tar.gz"
    sha256 "3ebe41e9be3f4ae6ca61e5dbc42c4b7cc007a01054a8506501a26dfc199fd3ec"
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
    url "https://files.pythonhosted.org/packages/ce/89/f53968635b1b2e53e4aad2dd641488929fef4ca9dfb0b97927fa7697ddf3/azure_core-1.35.0.tar.gz"
    sha256 "c0be528489485e9ede59b6971eb63c1eaacf83ef53001bfe3904e475e972be5c"
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
    url "https://files.pythonhosted.org/packages/b9/8d/0b681fc3be71de2e46bb2d4a16e6375eb1f65b65f4f240d1af056929c4dd/azure-mgmt-botservice-2.0.0b3.zip"
    sha256 "5d919039e330f2eb32435b65f23e7b7d9deea8bb21a261d8f633bfadba503af3"
  end

  resource "azure-mgmt-cdn" do
    url "https://files.pythonhosted.org/packages/d7/fc/48310b510043223c42ea2f9ac1e91a9a88b7438c0882d4c32db9f0b9fb0c/azure-mgmt-cdn-12.0.0.zip"
    sha256 "b7c3ee2189234b4af51ace2924927c5fd733f3de748a642d6d5040067c8c9ddd"
  end

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/fa/8e/9fcfdd507413a2536c5458b40942705ea8d74fe4e17f05fd1c32bb0225a9/azure_mgmt_cognitiveservices-14.1.0.tar.gz"
    sha256 "915191374d0adb443863c20aaea2c9f3b9d558a849ac2b78f152249262fdcaf8"
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
    url "https://files.pythonhosted.org/packages/c2/c5/b85f3b1e1432cc031fd1cd22b5963a648ddee88c637e57c43936be39d369/azure_mgmt_containerservice-40.1.0.tar.gz"
    sha256 "89a6caf507d340df472dc8dcfe217c1e098cdd8e71353db892efc284330e2f8e"
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
    url "https://files.pythonhosted.org/packages/9e/9e/50b30ad35c0038ce93ccf80535d2052967dc0dedae0eee84d2dc81458614/azure-mgmt-iotcentral-10.0.0b1.zip"
    sha256 "d42899b935d88486fbe1e1906542471f3a2f60d9e755ddd876ed540b2d81bb4d"
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
    url "https://files.pythonhosted.org/packages/f1/da/4007e21ff82e645d8bfd600f470bf020a83bdb4eba4d5dda1d749c09c270/azure_mgmt_monitor-7.0.0b1.tar.gz"
    sha256 "591e1864cc389e3925a40464ba3b119ddea7c1367c339bd715ccbd01f2fda23e"
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

  resource "azure-mgmt-resource-templatespecs" do
    url "https://files.pythonhosted.org/packages/e6/8d/2b85183b2bef5efef239b96bb33a6a6025593f6617958001d608ff82958a/azure_mgmt_resource_templatespecs-1.0.0b1.tar.gz"
    sha256 "0f9e739ab43db2ad870eae5df1b5c4bfa0500bbea1c6e58aa5e2e9c385facbc5"
  end

  resource "azure-mgmt-resource-deploymentstacks" do
    url "https://files.pythonhosted.org/packages/85/60/870f4fe84574891283b555419b0a45c0828e06d28596fc9bdf3b65692bc0/azure_mgmt_resource_deploymentstacks-1.0.0b1.tar.gz"
    sha256 "49b876e45c0f5bab88ec47d7c56e8fb34fbdfcfe5b831a3a2a21e817f3d9732e"
  end

  resource "azure-mgmt-resource-deploymentscripts" do
    url "https://files.pythonhosted.org/packages/eb/b0/60718c1a96bd4d1c08a7d6bdb620f7fa8740b30f1a0f7796e124d333970d/azure_mgmt_resource_deploymentscripts-1.0.0b1.tar.gz"
    sha256 "566d855953e949bb2b34cb43e1e73054aaa79281c74613b745ffddb82c802375"
  end

  resource "azure-mgmt-resource-deployments" do
    url "https://files.pythonhosted.org/packages/28/64/80b5e10c21d82c79ee2050ed5d2859c725207617dfa30cf7e72f112ad2fb/azure_mgmt_resource_deployments-1.0.0b1.tar.gz"
    sha256 "7359b42658826e7e7ff13e6dbb0c490e95fcc95dbca224d2b85cf71ad7535f1d"
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

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/36/7c/2fd872e11a88163f208b9c92de273bf64bb22d0eef9048cc6284d128a77a/azure_storage_blob-12.27.1.tar.gz"
    sha256 "a1596cc4daf5dac9be115fcb5db67245eae894cf40e4248243754261f7b674a6"
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
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c2/02/a95f2b11e207f68bc64d7aae9666fed2e2b3f307748d5123dffb72a1bbea/certifi-2024.7.4.tar.gz"
    sha256 "5a1e7645bc0ec61a09e26c36f6106dd4cf40c6db3a1fb6352b0244e7fb057c7b"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
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
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
    sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
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
    url "https://files.pythonhosted.org/packages/fe/6e/74a3f0179a4a73a53d66ce57fdb4de0080a8baa1de0063de206d6167acc2/pip-25.3.tar.gz"
    sha256 "8d0538dbbd7babbd207f261ed969c65de439f6bc9e5dbd3b3b9a77f25d95f343"
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
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
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
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8d/12/cd10d050f7714ccc675b486cdcbbaed54c782a5b77da2bb82e5c7b31fb40/websocket-client-1.3.1.tar.gz"
    sha256 "6278a75065395418283f887de7c3beafb3aa68dada5cacbe4b214e8d26da499b"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/2a/6de8a50cb435b7f42c46126cf1a54b2aab81784e74c8595c8e025e8f36d3/wrapt-2.0.1.tar.gz"
    sha256 "9c9c635e78497cacb81e84f8b11b23e0aacac7a136e73b8e5b2109a1d9fc468f"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    venv = virtualenv_create(libexec, "python3.13", system_site_packages: false)
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
