class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Tool for cloud security assessments, audits, incident response, and more"
  homepage "https://prowler.com/"
  url "https://files.pythonhosted.org/packages/8e/94/832826cce8c69fb8d2e4134c0425b42ae9b33b777ff4eb1cb1a2e96726d8/prowler-5.5.1.tar.gz"
  sha256 "8e9c8b7551cfbcb406f2f05f31a613767200393d3f28125b7298c24a79fe6c1b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20bb2201f0f3ca0cdbefc5a19c7ee12d6190e6f331aaf71a1bf20e515f21765d"
    sha256 cellar: :any,                 arm64_sonoma:  "fa5d9d8b151ad3ba1512d9ace7169cccbc80e0e52abcb4a908946cdf8aec5a89"
    sha256 cellar: :any,                 arm64_ventura: "fff62c2eae4dab8945fbf84192e6926d76ea5f04c68bf62b7435ccb60bbd2b7d"
    sha256 cellar: :any,                 sonoma:        "cfcc63b46022032210a29608cef0514d323dd4acf8276bcfc1de40a5f74d6c3a"
    sha256 cellar: :any,                 ventura:       "ab566ec9ad1248c327cd5580c2a83f2edff9fe2426c6fa3db096a7d452a7269e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436745b1a22a0b2d8ad338dc9ebb6f3fe137e06cc4d1ac3db292787e3efdf49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2568a6ebd5699ba7ff1a6d73b15f00d5bec3b5e9c770060528ce6bd6420e0391"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.12" # https://github.com/prowler-cloud/prowler/blob/master/pyproject.toml#L68

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/63/e7/fa1a8c00e2c54b05dc8cb5d1439f627f7c267874e3f7bb047146116020f9/aiohttp-3.11.18.tar.gz"
    sha256 "ae856e1138612b7e412db63b7708735cff4d38d0399f6a5435d3dac2669f558a"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ba/b5/6d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473d/aiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/28/66/c2c1e6674b3b7202ce529cf7d9971c93031e843b8e0c86a85f693e6185b8/alive-progress-3.2.0.tar.gz"
    sha256 "ede29d046ff454fe56b941f686f89dd9389430c4a5b7658e445cb0b80e0e4deb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "awsipranges" do
    url "https://files.pythonhosted.org/packages/19/2e/6efa95f995369da828715f41705686cd214b9259ed758266942553d40441/awsipranges-0.3.3.tar.gz"
    sha256 "4f0b3f22a9dc1163c85b513bed812b6c92bdacd674e6a7b68252a3c25b99e2c0"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/75/aa/7c9db8edd626f1a7d99d09ef7926f6f4fb34d5f9fa00dc394afdfe8e2a80/azure_core-1.33.0.tar.gz"
    sha256 "f367aa07b5e3005fec2c1e184b882b0b039910733907d001c20fb08ebb8c0eb9"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/b5/a1/f1a683672e7a88ea0e3119f57b6c7843ed52650fdcac8bfa66ed84e86e40/azure_identity-1.21.0.tar.gz"
    sha256 "ea22ce6e6b0f429bc1b8d9212d5b9f9877bd4c82f1724bfa910760612c07a9a6"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/56/f9/85c95072c4f396126a8ae145ffb45fb3e7bea660b6cb8ff8b2f702944a57/azure_keyvault_keys-4.10.0.tar.gz"
    sha256 "511206ae90aec1726a4d6ff5a92d754bd0c0f1e8751891368d30fb70b62955f1"
  end

  resource "azure-mgmt-applicationinsights" do
    url "https://files.pythonhosted.org/packages/e7/8b/f3c8886ecd90d440458c4cc2b1db4ff47215f189cc3c0ba3cf11b7d4d64e/azure_mgmt_applicationinsights-4.1.0.tar.gz"
    sha256 "15531390f12ce3d767cd3f1949af36aa39077c145c952fec4d80303c86ec7b6c"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/fe/3f/72e09a6f9a12d8afed8f56c929e8e142de21be9c19c27e4b2b94d60eb73a/azure_mgmt_compute-34.0.0.tar.gz"
    sha256 "58cd01d025efa02870b84dbfb69834a3b23501a135658c03854d2434e8dfee1e"
  end

  resource "azure-mgmt-containerregistry" do
    url "https://files.pythonhosted.org/packages/70/be/5806085a314e314ca5a53f5fa7ac87de55aad9bcde4c417b12d515edec8e/azure_mgmt_containerregistry-12.0.0.tar.gz"
    sha256 "f19f8faa7881deaf2b5015c0eb050a92e2380cd9d18dee33cdb5f27d44a06c03"
  end

  resource "azure-mgmt-containerservice" do
    url "https://files.pythonhosted.org/packages/31/b0/a5a2d6c2b2f9f7404f86732d400786d7cd996a155467f47ecaf786ce56d9/azure_mgmt_containerservice-34.1.0.tar.gz"
    sha256 "637a6cf8f06636c016ad151d76f9c7ba75bd05d4334b3dd7837eb8b517f30dbe"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/48/9a/9bdc35295a16fe9139a1f99c13d9915563cbc4f30b479efaa40f8694eaf7/azure_mgmt_core-1.5.0.tar.gz"
    sha256 "380ae3dfa3639f4a5c246a7db7ed2d08374e88230fd0da3eb899f7c11e5c441a"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/74/2a/3240e83aff38443d334a17467d32a46bab269164ab9477bb17d2277b32f8/azure_mgmt_cosmosdb-9.7.0.tar.gz"
    sha256 "b5072d319f11953d8f12e22459aded1912d5f27e442e1d8b49596a85005410a1"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/6f/c9/c9cd047729de3996656da854e361636dafa4f5e9b35af449abe23ec75582/azure-mgmt-keyvault-10.3.1.tar.gz"
    sha256 "34b92956aefbdd571cae5a03f7078e037d8087b2c00cfa6748835dc73abb5a30"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/e4/31/ebabafe0be1a177428880a8ec0fc44d681ac9dc1ae66a70d859cb5c7fbc3/azure-mgmt-monitor-6.0.2.tar.gz"
    sha256 "5ffbf500e499ab7912b1ba6d26cef26480d9ae411532019bb78d72562196e07b"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/19/a3/8d2fa6e33107354c8cd2abcca4e0f02138bda4c6024984ae5fce5cf23b27/azure_mgmt_network-28.1.0.tar.gz"
    sha256 "8c84bffb5ec75c6e0244e58ecf07c00d5fc421d616b0cb369c6fe585af33cf87"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/51/3c/c1e03a11cf3dc2567ba947cc196d695d125d0d0e86af6731a7c067c5404a/azure-mgmt-rdbms-10.1.0.zip"
    sha256 "a87d401c876c84734cdd4888af551e4a1461b4b328d9816af60cb8ac5979f035"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/a7/28/e950da2d89e55e2315ff0f4de075da4ac0fed4c27a489f7c774dedde9854/azure_mgmt_resource-23.3.0.tar.gz"
    sha256 "fc4f1fd8b6aad23f8af4ed1f913df5f5c92df117449dc354fea6802a2829fea4"
  end

  resource "azure-mgmt-search" do
    url "https://files.pythonhosted.org/packages/63/b7/b9431f1ab621f83849f3ace5ba9d2820c731409fce8466b5f06d330d19f4/azure-mgmt-search-9.1.0.tar.gz"
    sha256 "53bc6eeadb0974d21f120bb21bb5e6827df6d650e17347460fd83e2d68883599"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/3d/90/13186657355452bdce44f27db6b194b99f78f8c185301b47624fff6d9531/azure-mgmt-security-7.0.0.tar.gz"
    sha256 "5912eed7e9d3758fdca8d26e1dc26b41943dc4703208a1184266e2c252e1ad66"
  end

  resource "azure-mgmt-sql" do
    url "https://files.pythonhosted.org/packages/3f/af/398c57d15064ea23475076cd087b1a143b66d33a029e6e47c4688ca32310/azure-mgmt-sql-3.0.1.zip"
    sha256 "129042cc011225e27aee6ef2697d585fa5722e5d1aeb0038af6ad2451a285457"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/2f/e7/1f6a1384a77513c0d636ae411e169d22433a07fd146c8b8b7d6027f90dbb/azure_mgmt_storage-22.1.1.tar.gz"
    sha256 "25aaa5ae8c40c30e2f91f8aae6f52906b0557e947d5c1b9817d4ff9decc11340"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-mgmt-web" do
    url "https://files.pythonhosted.org/packages/3a/55/5a24bc2d98830f0dc224e2baaf28b0091b7b646b390dc35c8234ae2f4830/azure_mgmt_web-8.0.0.tar.gz"
    sha256 "c8d9c042c09db7aacb20270a9effed4d4e651e365af32d80897b84dc7bf35098"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/aa/ff/f6e81d15687510d83a06cafba9ac38d17df71a2bb18f35a0fb169aee3af3/azure_storage_blob-12.24.1.tar.gz"
    sha256 "052b2a1ea41725ba12e2f4f17be85a54df1129e13ea0321f5a2fcc851cbf47d4"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f7/99/3e8b48f15580672eda20f33439fc1622bd611f6238b6d05407320e1fb98c/boto3-1.35.99.tar.gz"
    sha256 "e0abd794a7a591d90558e92e29a9f8837d25ece8e3c120e530526fe27eba5fca"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/7c/9c/1df6deceee17c88f7170bad8325aa91452529d683486273928eecfd946d8/botocore-1.35.99.tar.gz"
    sha256 "1eab44e969c39c5f3d9a3104a0836c24715579a455f12b3979a31d7cde51b3c3"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dash" do
    url "https://files.pythonhosted.org/packages/cf/ae/dfd8c42c83cad1b903e4e3e7be7042074d5d7d16be97eaede6656b8ead95/dash-2.18.2.tar.gz"
    sha256 "20e8404f73d0fe88ce2eae33c25bbc513cbe52f30d23a401fa5f24dbb44296c8"
  end

  resource "dash-bootstrap-components" do
    url "https://files.pythonhosted.org/packages/a6/1e/59da44351adaaa2a747eb00993c498cadbe0f642b44ced7e7aabf368eaf6/dash_bootstrap_components-1.6.0.tar.gz"
    sha256 "960a1ec9397574792f49a8241024fa3cecde0f5930c971a3fc81f016cbeb1095"
  end

  resource "dash-core-components" do
    url "https://files.pythonhosted.org/packages/41/55/ad4a2cf9b7d4134779bd8d3a7e5b5f8cc757f421809e07c3e73bb374fdd7/dash_core_components-2.0.0.tar.gz"
    sha256 "c6733874af975e552f95a1398a16c2ee7df14ce43fa60bb3718a3c6e0b63ffee"
  end

  resource "dash-html-components" do
    url "https://files.pythonhosted.org/packages/14/c6/957d5e83b620473eb3c8557a253fb01c6a817b10ca43d3ff9d31796f32a6/dash_html_components-2.0.0.tar.gz"
    sha256 "8703a601080f02619a6390998e0b3da4a5daabe97a1fd7a9cebc09d015f26e50"
  end

  resource "dash-table" do
    url "https://files.pythonhosted.org/packages/3a/81/34983fa0c67125d7fff9d55e5d1a065127bde7ca49ca32d04dedd55f9f35/dash_table-5.0.0.tar.gz"
    sha256 "18624d693d4c8ef2ddec99a6f167593437a7ea0bf153aa20f318c170c5bc7308"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
    sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/31/e9/f49c4e7fccb77fa5c43c2480e09a857a78b41e7331a75e128ed5df45c56b/durationpy-0.9.tar.gz"
    sha256 "fd3feb0a69a0057d582ef643c355c40d2fa1c942191f914d12203b1a01ac722a"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/48/ce/13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1/email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/ee/f4/d744cba2da59b5c1d88823cf9e8a6c74e4659e2b27604ed973be2a0bf5ab/frozenlist-1.6.0.tar.gz"
    sha256 "b99655c32c1c8e06d111e7f41c06c29a5318cb1835df23a45518e02a47c63b68"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/6a/a2/7950df7fbb8ab1b7afb286ab374df2f5b3ea107b5d18224eac4e81bd2a69/google_api_core-2.25.0rc0.tar.gz"
    sha256 "38d9d6a67673473457adbbef1ccca27d9ebb755e377c05e8a9b88f89eecab9ad"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/29/9f/535346bb1469ec91139c38f0438ad70bd229a6b11452367065fe49303860/google_api_python_client-2.163.0.tar.gz"
    sha256 "88dee87553a2d82176e2224648bf89272d536c8f04dcdda37ef0a71473886dd7"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/cb/8e/8f45c9a32f73e786e954b8f9761c61422955d23c45d1e8c347f9b4b59e8e/google_auth-2.39.0.tar.gz"
    sha256 "73222d43cdc35a3aeacbfdcaf73142a97839f10de930550d89ebfe1d0a00cde7"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "grapheme" do
    url "https://files.pythonhosted.org/packages/ce/e7/bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bf/grapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/1b/38/d7f80fd13e6582fb8e0df8c9a653dcc02b03ca34f4d72f34869298c5baf8/h2-4.2.0.tar.gz"
    sha256 "c8a52129695e88b1a0578d8d2cc6842bbd79128ac685463b887ee278126ad01f"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/2c/48/71de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8/hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/08/c1395a292bb23fd03bdf572a1357c5a733d3eecbab877641ceacab23db6e/importlib_metadata-8.6.1.tar.gz"
    sha256 "310b41d755445d74569f993ccfc22838295d9fe005425094fad953d7f15c8580"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/b7/e8/0598f0e8b4af37cd9b10d8b87386cf3173cb8045d834ab5f6ec347a758b3/kubernetes-32.0.1.tar.gz"
    sha256 "42f43d49abd437ada79a79a16bd48a604d3471a117a8347e87db693f2ba0ba28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/fa/42/e9ddbdf6c2c772651e09ad74bd28dbf1c11e3f54bbb7cdb88ce57959f7c3/microsoft_kiota_abstractions-1.9.2.tar.gz"
    sha256 "29cdafe8d0672f23099556e0b120dca6231c752cca9393e1e0092fa9ca594572"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/97/bc/91b07dd6923f351afaa3121d12eab99a49f4da8128975fc8eefc1d1bef9b/microsoft_kiota_authentication_azure-1.9.2.tar.gz"
    sha256 "171045f522a93d9340fbddc4cabb218f14f1d9d289e82e535b3d9291986c3d5a"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/5d/f3/4738613a6711917a1b4f829c962f3ce09a286c12a1037dc0fd666a9f4ad7/microsoft_kiota_http-1.9.2.tar.gz"
    sha256 "2ba3d04a3d1d5d600736eebc1e33533d54d87799ac4fbb92c9cce4a97809af61"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/5d/51/ddbed9c6a3d7197c94d03d5a71bd01181fa0e6051b5919ca81e116061a30/microsoft_kiota_serialization_form-1.9.2.tar.gz"
    sha256 "badfbe65d8ec3369bd58b01022d13ef590edf14babeef94188efe3f4ec24fe41"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/7d/ea/fee81f1cb68d5163573294935311a9c45d7da7dc08aa4acd86690ddafdcb/microsoft_kiota_serialization_json-1.9.2.tar.gz"
    sha256 "19f7beb69c67b2cb77ca96f77824ee78a693929e20237bb5476ea54f69118bf1"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/d0/10/a8ea0a0f58bbc79c5f22bf868f10eac9f505f092e3f72ba1f050ab13316c/microsoft_kiota_serialization_multipart-1.9.2.tar.gz"
    sha256 "b1851409205668d83f5c7a35a8b6fca974b341985b4a92841e95aaec93b7ca0a"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/81/20/aac457a8a0ce90510dc82ca5ba0d80484aeaf87d75d08ebefcbb81373683/microsoft_kiota_serialization_text-1.9.2.tar.gz"
    sha256 "4289508ebac0cefdc4fa21c545051769a9409913972355ccda9116b647f978f2"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/3f/90/81dcc50f0be11a8c4dcbae1a9f761a26e5f905231330a7cacc9f04ec4c61/msal-1.32.3.tar.gz"
    sha256 "5eea038689c78a5a70ca8ecbe1245458b55a857bd096efb6989c69ba15985d35"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/d7/9a/f078f7d0ea8f55ba5c85fa53487bd6ffec2403542c117bf5b2a8b86f11a5/msgraph_core-1.3.3.tar.gz"
    sha256 "a3226b08b4cf9b6dbb16b868be21d5f82d8ee514ae8e46d9f0cad896159ef8d3"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/aa/26/95dd0fce22456ea26c8ab0a8f4e9b56d2ece772ab6f7fe3dc23b827a2e68/msgraph_sdk-1.18.0.tar.gz"
    sha256 "ef49166ada7b459b5a843ceb3d253c1ab99d8987ebf3112147eb6cbcaa101793"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/da/2c/e367dfb4c6538614a0c9453e510d75d66099edf1c4e69da1b5ce691a1931/multidict-6.4.3.tar.gz"
    sha256 "3ada0b058c9f213c5f95ba301f922d402ac234f1111a7d8fd70f1b99f3c281ec"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/65/92/503f99e2244a271aacd6c2588e0af1b59232292b217708748cdb30214dc3/narwhals-1.36.0.tar.gz"
    sha256 "7cd860e7e066609bd8a042bb5b8e4193275532114448210a91cbd5c622b6e5eb"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/42/40/2359245cd33641c2736a0136a50813352d72f3fc209de28fb226950db4a1/opentelemetry_api-1.32.1.tar.gz"
    sha256 "a5be71591694a4d9195caf6776b055aa702e964d961051a0715d05f8632c32fb"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/a3/65/2069caef9257fae234ca0040d945c741aa7afbd83a7298ee70fc0bc6b6f4/opentelemetry_sdk-1.32.1.tar.gz"
    sha256 "8ef373d490961848f525255a42b193430a0637e064dd132fd2a014d94792a092"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/5e/b6/3c56e22e9b51bcb89edab30d54830958f049760bbd9ab0a759cece7bca88/opentelemetry_semantic_conventions-0.53b1.tar.gz"
    sha256 "4c5a6fede9de61211b2e9fc1e02e8acacce882204cd770177342b6a3be682992"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/9c/d6/9f8431bacc2e19dca897724cd097b1bb224a6ad5433784a44b587c7c13af/pandas-2.2.3.tar.gz"
    sha256 "4f18ba62b61d7e192368b84517265a99b4d7ee8912f8708660fb4a366cc82667"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/c7/cc/e41b5f697ae403f0b50e47b7af2e36642a193085f553bf7cc1169362873a/plotly-6.0.1.tar.gz"
    sha256 "dd8400229872b6e3c964b099be699f8d00c489a974f2cfccfad5e8240873366b"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/07/c8/fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40/propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c8/8c/cf2ac658216eebe49eaedf1e06bc06cbf6a143469236294a1171a51357c3/protobuf-6.30.2.tar.gz"
    sha256 "35c859ae076d8c56054c25b59e5e59638d86545ed6e2b6efac6be0b6ea3ba048"
  end

  resource "py-ocsf-models" do
    url "https://files.pythonhosted.org/packages/f7/b7/2810026d92c92f1b5b5c56553f941b6b40beab564957cc708d4a47e25eb6/py_ocsf_models-0.3.1.tar.gz"
    sha256 "60defd2cc86e8882f42dc9c6dacca6dc16d6bc05f9477c2a3486a0d4b5882b94"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/c3/e9/d99a2c4f8f6d7c711f39f6ecf485b7f3bba66189bbbad505d24eb0106922/pydantic-1.10.21.tar.gz"
    sha256 "64b48e2b609a6c22178a56c408ee1215a7206077ecb8a193e2fda31858b2362a"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5f/57/df1c9157c8d5a05117e455d66fd7cf6dbc46974f832b1058ed4856785d8a/pytz-2025.1.tar.gz"
    sha256 "c2db42be2a2518b28e65f9207c4d05e6ff547d1efa4086469ef855e4ab70178e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/ce/70/15ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9dd/retrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/0b/b3/52b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41/rpds_py-0.24.0.tar.gz"
    sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/c0/0a/1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069/s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/d4/01/0ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecd/schema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/bb/71/b6365e6325b3290e14957b2c3a804a529968c77a049b2ed40c095f749707/setuptools-79.0.1.tar.gz"
    sha256 "128ce7b8f33c3079fd1b067ecbb4051a66e8526e7b65f6cec075dfc650ddfa88"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c5/06/c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28/shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "slack-sdk" do
    url "https://files.pythonhosted.org/packages/6e/ff/6eb67fd5bd179fa804dbd859d88d872d3ae343955e63a319a73a132d406f/slack_sdk-3.34.0.tar.gz"
    sha256 "ff61db7012160eed742285ea91f11c72b7a38a6500a7f6c5335662b4bc6b853d"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/d8/dd/7b24308aa0a35d14d3f87a54d7c74307e0efbe08c9af092960bd25d83419/std_uritemplate-2.0.3.tar.gz"
    sha256 "ad4cb1d671bcf4a3608b3598c687be4b0929867c53a2d69c105989da6a5a2d4c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/97/78/182641ea38e3cfd56e9c7b3c0d48a53d432eea755003aa544af96403d4ac/tldextract-5.3.0.tar.gz"
    sha256 "b3d2b70a1594a0ecfa6967d57251527d58e00bb5a91a74387baa0d87a0678609"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/d4/f9/0ba83eaa0df9b9e9d1efeb2ea351d0677c37d41ee5d0f91e98423c7281c9/werkzeug-3.0.6.tar.gz"
    sha256 "a8dd59d4de28ca70471a34cba79bed5f7ef2e036a76b3ab0835474246eb41f8d"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/a7/d1/e026d33dd5d552e5bf3a873dee54dad66b550230df8290d79394f09b2315/xlsxwriter-3.2.3.tar.gz"
    sha256 "ad6fd41bdcf1b885876b1f6b7087560aecc9ae5a9cc2ba97dcac7ab2e210d3d5"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/62/51/c0edba5219027f6eab262e139f73e2417b0f4efffa23bf562f6e18f76ca5/yarl-1.20.0.tar.gz"
    sha256 "686d51e51ee5dfe62dec86e4866ee0e9ed66df700d55c828a615640adc885307"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    # Multiple resources require `setuptools`, so it must be installed first
    venv = virtualenv_install_with_resources without: "plotly", start_with: "setuptools"
    venv.pip_install resource("plotly"), build_isolation: false
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "Unable to locate credentials", shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)
    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end
