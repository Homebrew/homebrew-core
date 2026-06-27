class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Tool for cloud security assessments, audits, incident response, and more"
  homepage "https://prowler.com/"
  url "https://files.pythonhosted.org/packages/c9/e4/ee40eb7be35c374b696166a6fcec565a39fa8f762ba1398a153b96172255/prowler-5.31.1.tar.gz"
  sha256 "4118b758a90c2d92eb3a7bc941331b21e8374a9aa44b135060060045b7aa47c9"
  license "Apache-2.0"
  head "https://github.com/prowler-cloud/prowler.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "31df6e563a69c640e6c59d5bbabf72e710cef0fded872f8d7ddf9fb3b7350007"
    sha256 cellar: :any, arm64_sequoia: "dec8c0301c61071edf69b89b04a704e2345c440e1cbd3df1e6947d380e1d30b6"
    sha256 cellar: :any, arm64_sonoma:  "6ffb8a9716675b0eb6887466c59b8c2839852aab50e358d2fce141f4ec187254"
    sha256 cellar: :any, sonoma:        "10215f4f573d7d9e0b8fd020523d202d4f2d05d944dd1e82ae1e0c68af3f3a29"
    sha256 cellar: :any, arm64_linux:   "a1318eea8fe7f03db41bea153fd4f24dcd9ea84ffd817b84995ea7f655cb3fbf"
    sha256 cellar: :any, x86_64_linux:  "93137994f62b4c6eb8d7d61c8c0780762dbd1c63b1d0a899dfcd58dbf03d0f6a"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "numpy" => :no_linkage
  depends_on "openssl@3"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libffi"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "openblas"
  end

  pypi_packages exclude_packages: %w[certifi cryptography numpy pydantic rpds-py]

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "aenum" do
    url "https://files.pythonhosted.org/packages/07/e9/8b283567c1fef7c24d1f390b37daede8b61593d8cdaffb8e95d571699e83/aenum-3.1.17.tar.gz"
    sha256 "a969a4516b194895de72c875ece355f17c0d272146f7fda346ef74f93cf4d5ba"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/33/c6/61a2d7b7572279226bb2e7f61d7a19ca7c90da0329c93fa0d560cbf288d8/aiohappyeyeballs-2.6.2.tar.gz"
    sha256 "e202810ee718bd01fc6ef49e8ea53d023d5cb6b581076d7925aa499fa55dbe64"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/82/78/8ea7308cac6934de8c74a14f3d5f65d1c89287426688be79538d0e5c013d/aiohttp-3.14.1.tar.gz"
    sha256 "307f2cff90a764d329e77040603fa032db89c5c24fdad50c4c15334cba744035"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "alibabacloud-actiontrail20200706" do
    url "https://files.pythonhosted.org/packages/dd/97/ce0fb7ee2507fa9e6d41c8bc5bbc224d15af6c3c47047af6c1254b17b969/alibabacloud_actiontrail20200706-2.4.1.tar.gz"
    sha256 "b65c6b37a96443fbe625dd5a4dd1be52a7476006a411db75206908b11588ffa8"
  end

  resource "alibabacloud-credentials" do
    url "https://files.pythonhosted.org/packages/df/82/45ec98bd19387507cf058ce47f62d6fea288bf0511c5a101b832e13d3edd/alibabacloud-credentials-1.0.3.tar.gz"
    sha256 "9d8707e96afc6f348e23f5677ed15a21c2dfce7cfe6669776548ee4c80e1dfaf"
  end

  resource "alibabacloud-credentials-api" do
    url "https://files.pythonhosted.org/packages/89/7e/6145e2d132752f0de72701df556304c59dda311405a252a598ad6fd9b4de/alibabacloud_credentials_api-1.0.1.tar.gz"
    sha256 "8ea0668a6558f6956b8d20b2e561d19a80ea29c22cf56a3004d434b24a981b36"
  end

  resource "alibabacloud-cs20151215" do
    url "https://files.pythonhosted.org/packages/05/51/6a6aa2c0c1e392e137fbde77c1d5f6bf16e665b3d5e6e3ab747664e67cdf/alibabacloud_cs20151215-6.1.0.tar.gz"
    sha256 "5b3d99306701bf499ddd57cd9f2905b7721cb1bb4bb38ffe4d051f7b4e80e355"
  end

  resource "alibabacloud-darabonba-array" do
    url "https://files.pythonhosted.org/packages/50/be/1813d7553e11e20a1422ffaaead392cfa7239a855c7e67c6a6b5776cfa64/alibabacloud_darabonba_array-0.1.0.tar.gz"
    sha256 "7f9a7c632518ff4f0cebb0d4e825a48c12e7cf0b9016ea25054dd73732e155aa"
  end

  resource "alibabacloud-darabonba-encode-util" do
    url "https://files.pythonhosted.org/packages/b6/d8/22543b2ade9aa68fef028a9f0c4154bfdb970926f918f63d7b85bae527a9/alibabacloud_darabonba_encode_util-0.0.2.tar.gz"
    sha256 "f1c484f276d60450fa49b4b2987194e741fcb2f7faae7f287c0ae65abc85fd4d"
  end

  resource "alibabacloud-darabonba-map" do
    url "https://files.pythonhosted.org/packages/d5/bc/f11d56adffffade9a0d33ccca155ce82ca950b97cdce27a75228715c4639/alibabacloud_darabonba_map-0.0.1.tar.gz"
    sha256 "adb17384658a1a8f72418f1838d4b6a5fd2566bfd392a3ef06d9dbb0a595a23f"
  end

  resource "alibabacloud-darabonba-signature-util" do
    url "https://files.pythonhosted.org/packages/13/09/2118a2df631eaa06a291013ea61f31e449ba7a3cc3d6061477a43420e93a/alibabacloud_darabonba_signature_util-0.0.4.tar.gz"
    sha256 "71d79b2ae65957bcfbf699ced894fda782b32f9635f1616635533e5a90d5feb0"
  end

  resource "alibabacloud-darabonba-string" do
    url "https://files.pythonhosted.org/packages/f9/d4/3d22bd2ff88985f970a10f8cedf2ea326d11d4d95e244f7665dc83d26465/alibabacloud-darabonba-string-0.0.4.tar.gz"
    sha256 "ec6614c0448dadcbc5e466485838a1f8cfdd911135bea739e20b14511270c6f7"
  end

  resource "alibabacloud-darabonba-time" do
    url "https://files.pythonhosted.org/packages/44/df/33a239384353130eef51af14cec1fa99058b2c5f4c7f3d0b283e5f17b874/alibabacloud_darabonba_time-0.0.1.tar.gz"
    sha256 "0ad9c7b0696570d1a3f40106cc7777f755fd92baa0d1dcab5b7df78dde5b922d"
  end

  resource "alibabacloud-ecs20140526" do
    url "https://files.pythonhosted.org/packages/c8/f1/721627d499eb8ed5f8ad3ba0dbf57a0da10ff01deaf64f3536f70edbab8c/alibabacloud_ecs20140526-7.2.5.tar.gz"
    sha256 "2abbe630ce42d69061821f38950b938c5982cc31902ccd7132d05be328765a55"
  end

  resource "alibabacloud-endpoint-util" do
    url "https://files.pythonhosted.org/packages/92/7d/8cc92a95c920e344835b005af6ea45a0db98763ad6ad19299d26892e6c8d/alibabacloud_endpoint_util-0.0.4.tar.gz"
    sha256 "a593eb8ddd8168d5dc2216cd33111b144f9189fcd6e9ca20e48f358a739bbf90"
  end

  resource "alibabacloud-gateway-oss" do
    url "https://files.pythonhosted.org/packages/da/c3/4172567b96d885117d93b5ac7b849dda7f0421af7410e074f3ccf3469357/alibabacloud_gateway_oss-0.0.17.tar.gz"
    sha256 "8c4b66c8c7dd285fc210ee232ab3f062b5573258752804d19382000746531e29"
  end

  resource "alibabacloud-gateway-oss-util" do
    url "https://files.pythonhosted.org/packages/e2/1e/caf81e07d285dbef4dc62e63763448cc84a9b483a69b1a1a576efbbe8795/alibabacloud_gateway_oss_util-0.0.3.tar.gz"
    sha256 "5eb7fa450dc7350d5c71577974b9d7f489479e5c5ec7efc1c5376385e8c1c0a5"
  end

  resource "alibabacloud-gateway-sls" do
    url "https://files.pythonhosted.org/packages/e7/de/c4330d6e12f2392df1e66bd6e1a528135e1a35911fab5b06edb9a185de08/alibabacloud_gateway_sls-0.4.2.tar.gz"
    sha256 "106685a23b49ab2f0682ee2c3e160da9b50ea466de531b4e9259bc8c0583d61e"
  end

  resource "alibabacloud-gateway-sls-util" do
    url "https://files.pythonhosted.org/packages/56/fe/da368a15bf1df742cf7dc5dd6842e08dce3892c0737a43d0ee09964b3904/alibabacloud_gateway_sls_util-0.4.1.tar.gz"
    sha256 "289f302e0e07456be5f811be9b9b526445576ae3b91f125f15870d335a211234"
  end

  resource "alibabacloud-gateway-spi" do
    url "https://files.pythonhosted.org/packages/cd/67/7cd36a36bf0ec53efd3fe31eaf398713f375b7b1cdcd32c51b6c0fdc09e2/alibabacloud_gateway_spi-0.0.4.tar.gz"
    sha256 "73d6e20d65b54eed26d89c19640d3a7572e18c45ecada627f806f5dbe8ed2130"
  end

  resource "alibabacloud-openapi-util" do
    url "https://files.pythonhosted.org/packages/f6/51/be5802851a4ed20ac2c6db50ac8354a6e431e93db6e714ca39b50983626f/alibabacloud_openapi_util-0.2.4.tar.gz"
    sha256 "87022b9dcb7593a601f7a40ca698227ac3ccb776b58cb7b06b8dc7f510995c34"
  end

  resource "alibabacloud-oss-util" do
    url "https://files.pythonhosted.org/packages/02/7c/d7e812b9968247a302573daebcfef95d0f9a718f7b4bfcca8d3d83e266be/alibabacloud_oss_util-0.0.6.tar.gz"
    sha256 "d3ecec36632434bd509a113e8cf327dc23e830ac8d9dd6949926f4e334c8b5d6"
  end

  resource "alibabacloud-oss20190517" do
    url "https://files.pythonhosted.org/packages/9c/d7/2f9ad0b13bd196b0f45bdb4a0d1ecc14d1723ad1685e37d975cfbb566919/alibabacloud_oss20190517-1.0.6.tar.gz"
    sha256 "7cd0fb16af613ceb38d2e0e529aa1f58038c7cf59eb67c8c8775ae44ea717852"
  end

  resource "alibabacloud-ram20150501" do
    url "https://files.pythonhosted.org/packages/b3/fd/5b18adb76bbe55fc6da2913f22f4862f296eea8ed84c605f106aaff50daa/alibabacloud_ram20150501-1.2.0.tar.gz"
    sha256 "6253513c8880769f4fd5b36fedddb362a9ca628ad9ae9c05c0eeacf5fbc95b42"
  end

  resource "alibabacloud-rds20140815" do
    url "https://files.pythonhosted.org/packages/78/6d/167b4e285f74f2426ea137388220f484e41263bbc21f42c8280cfa95cb0d/alibabacloud_rds20140815-12.0.0.tar.gz"
    sha256 "e7421d94f18a914c0a06b0e7fad0daff557713f1c97d415d463a78c1270e9b98"
  end

  resource "alibabacloud-sas20181203" do
    url "https://files.pythonhosted.org/packages/81/c4/7cdd75a2f7afceecc6652ca3c35c6ec3a4a095cd84d02b07749c52317814/alibabacloud_sas20181203-6.1.0.tar.gz"
    sha256 "e49ffd53e630274a8bf5a8299ca753023ad118510c80f6d9c6fb018b7479bf37"
  end

  resource "alibabacloud-sls20201230" do
    url "https://files.pythonhosted.org/packages/53/09/49043ef5074e1127b81d133ab606f581f206135541e734b6dccb99b0d66f/alibabacloud_sls20201230-5.9.0.tar.gz"
    sha256 "bea830b64fbc7ed1719ba386ceeefb120f08d705f03eb0e02409dc6f12a291da"
  end

  resource "alibabacloud-sts20150401" do
    url "https://files.pythonhosted.org/packages/62/94/3b360c5051d4e4c3f2f410b7631e4a8bf7e508a498acc15be6ec7bf58594/alibabacloud_sts20150401-1.1.6.tar.gz"
    sha256 "c2529b41e0e4531e21cb393e4df346e19fd6d54cc6337d1138dbcd2191438d4c"
  end

  resource "alibabacloud-tea" do
    url "https://files.pythonhosted.org/packages/9a/7d/b22cb9a0d4f396ee0f3f9d7f26b76b9ed93d4101add7867a2c87ed2534f5/alibabacloud-tea-0.4.3.tar.gz"
    sha256 "ec8053d0aa8d43ebe1deb632d5c5404339b39ec9a18a0707d57765838418504a"
  end

  resource "alibabacloud-tea-openapi" do
    url "https://files.pythonhosted.org/packages/30/93/138bcdc8fc596add73e37cf2073798f285284d1240bda9ee02f9384fc6be/alibabacloud_tea_openapi-0.4.4.tar.gz"
    sha256 "1b0917bc03cd49417da64945e92731716d53e2eb8707b235f54e45b7473221ce"
  end

  resource "alibabacloud-tea-util" do
    url "https://files.pythonhosted.org/packages/e9/ee/ea90be94ad781a5055db29556744681fc71190ef444ae53adba45e1be5f3/alibabacloud_tea_util-0.3.14.tar.gz"
    sha256 "708e7c9f64641a3c9e0e566365d2f23675f8d7c2a3e2971d9402ceede0408cdb"
  end

  resource "alibabacloud-tea-xml" do
    url "https://files.pythonhosted.org/packages/32/eb/5e82e419c3061823f3feae9b5681588762929dc4da0176667297c2784c1a/alibabacloud_tea_xml-0.0.3.tar.gz"
    sha256 "979cb51fadf43de77f41c69fc69c12529728919f849723eb0cd24eb7b048a90c"
  end

  resource "alibabacloud-vpc20160428" do
    url "https://files.pythonhosted.org/packages/f1/27/1d8dcfd832d5a21390347002cc69999adfb5c7e0a832345209c56e9f504c/alibabacloud_vpc20160428-6.13.0.tar.gz"
    sha256 "daf00679a83d422799f9fcf263739fe1f360641675843cbfbe623833fc8b1681"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/9a/26/d43128764a6f8fe1668c4f87aba6b1fe52bea81d05a35c84a70d3c70b6f7/alive-progress-3.3.0.tar.gz"
    sha256 "457dd2428b48dacd49854022a46448d236a48f1b7277874071c39395307e830c"
  end

  resource "aliyun-log-fastpb" do
    url "https://files.pythonhosted.org/packages/23/e5/9e4a969351b35c824d0f137589309ca1ec71daed50ce8bac512265b9d901/aliyun_log_fastpb-0.3.0.tar.gz"
    sha256 "746e3fb55c7e6eb9715e852a75cac5724e998778c09ad17e022b28eb76b1a741"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/3b/72/5562aabb8dd7181e8e860622a38bea08d17842b99ecd4c91f84ac95251b0/anyio-4.14.1.tar.gz"
    sha256 "8d648a3544c1a700e3ff78615cd679e4c5c3f149904287e73687b2596963629e"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/07/12/3e4389e5920b4c1763390c6d371162f3784f86f85cd6d6c1bfe68eef14e2/apscheduler-3.11.2.tar.gz"
    sha256 "2a9966b052ec805f020c8c4c3ae6e6a06e24b1bf19f2e11d91d8cca0473eef41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/b5/a1/f1a683672e7a88ea0e3119f57b6c7843ed52650fdcac8bfa66ed84e86e40/azure_identity-1.21.0.tar.gz"
    sha256 "ea22ce6e6b0f429bc1b8d9212d5b9f9877bd4c82f1724bfa910760612c07a9a6"
  end

  resource "azure-keyvault-keys" do
    url "https://files.pythonhosted.org/packages/56/f9/85c95072c4f396126a8ae145ffb45fb3e7bea660b6cb8ff8b2f702944a57/azure_keyvault_keys-4.10.0.tar.gz"
    sha256 "511206ae90aec1726a4d6ff5a92d754bd0c0f1e8751891368d30fb70b62955f1"
  end

  resource "azure-mgmt-apimanagement" do
    url "https://files.pythonhosted.org/packages/25/e4/3e536f0374bccb203886ef7aeb1148e063de6be31187034179ddcbf1adff/azure_mgmt_apimanagement-5.0.0.tar.gz"
    sha256 "0ab7fe17e70fe3154cd840ff47d19d7a4610217003eaa7c21acf3511a6e57999"
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
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
  end

  resource "azure-mgmt-cosmosdb" do
    url "https://files.pythonhosted.org/packages/74/2a/3240e83aff38443d334a17467d32a46bab269164ab9477bb17d2277b32f8/azure_mgmt_cosmosdb-9.7.0.tar.gz"
    sha256 "b5072d319f11953d8f12e22459aded1912d5f27e442e1d8b49596a85005410a1"
  end

  resource "azure-mgmt-databricks" do
    url "https://files.pythonhosted.org/packages/ef/6d/b5e549a1287a4a0a2a194dcc4578c81af66111b8b18a73f4dbd434539b07/azure-mgmt-databricks-2.0.0.zip"
    sha256 "70d11362dc2d17f5fb1db0cfe65c1af55b8f136f1a0db9a5b51e7acf760cf5b9"
  end

  resource "azure-mgmt-keyvault" do
    url "https://files.pythonhosted.org/packages/6f/c9/c9cd047729de3996656da854e361636dafa4f5e9b35af449abe23ec75582/azure-mgmt-keyvault-10.3.1.tar.gz"
    sha256 "34b92956aefbdd571cae5a03f7078e037d8087b2c00cfa6748835dc73abb5a30"
  end

  resource "azure-mgmt-loganalytics" do
    url "https://files.pythonhosted.org/packages/8d/66/99802a1711cadb1c41e322dd42aaa3acfb58c70aba13e0f0cdbead21e6c4/azure-mgmt-loganalytics-12.0.0.zip"
    sha256 "da128a7e0291be7fa2063848df92a9180cf5c16d42adc09d2bc2efd711536bfb"
  end

  resource "azure-mgmt-monitor" do
    url "https://files.pythonhosted.org/packages/e4/31/ebabafe0be1a177428880a8ec0fc44d681ac9dc1ae66a70d859cb5c7fbc3/azure-mgmt-monitor-6.0.2.tar.gz"
    sha256 "5ffbf500e499ab7912b1ba6d26cef26480d9ae411532019bb78d72562196e07b"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/19/a3/8d2fa6e33107354c8cd2abcca4e0f02138bda4c6024984ae5fce5cf23b27/azure_mgmt_network-28.1.0.tar.gz"
    sha256 "8c84bffb5ec75c6e0244e58ecf07c00d5fc421d616b0cb369c6fe585af33cf87"
  end

  resource "azure-mgmt-postgresqlflexibleservers" do
    url "https://files.pythonhosted.org/packages/53/03/c3dacaff6551fdd482a13f4e4b3628ab9fdada888159ab9547ebc1763d7c/azure_mgmt_postgresqlflexibleservers-1.1.0.tar.gz"
    sha256 "9ede9d8ba63e9d2879cb74adc903c649af3bc5460a02787287b0cd18d754af14"
  end

  resource "azure-mgmt-rdbms" do
    url "https://files.pythonhosted.org/packages/51/3c/c1e03a11cf3dc2567ba947cc196d695d125d0d0e86af6731a7c067c5404a/azure-mgmt-rdbms-10.1.0.zip"
    sha256 "a87d401c876c84734cdd4888af551e4a1461b4b328d9816af60cb8ac5979f035"
  end

  resource "azure-mgmt-recoveryservices" do
    url "https://files.pythonhosted.org/packages/df/52/b1b2047ffa71cda33250e5f2286966ed805feeff58f763e771fbd855a1e6/azure_mgmt_recoveryservices-3.1.0.tar.gz"
    sha256 "7f2db98401708cf145322f50bc491caf7967bec4af3bf7b0984b9f07d3092687"
  end

  resource "azure-mgmt-recoveryservicesbackup" do
    url "https://files.pythonhosted.org/packages/72/28/99997bb991c8d1d53ec1164a4f07adc520e3c10c55b7e0b814f6e6c6043e/azure_mgmt_recoveryservicesbackup-9.2.0.tar.gz"
    sha256 "c402b3e22a6c3879df56bc37e0063142c3352c5102599ff102d19824f1b32b29"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/50/4c/b27a3dfbedebbcc8e346a956a803528bd94a19fdf14b1de4bd781b03a6cc/azure_mgmt_resource-24.0.0.tar.gz"
    sha256 "cf6b8995fcdd407ac9ff1dd474087129429a1d90dbb1ac77f97c19b96237b265"
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

  resource "azure-monitor-query" do
    url "https://files.pythonhosted.org/packages/04/c0/e5c760f38224575f1eba35c319842f2be30fab599854ba9bd0b19d39c261/azure_monitor_query-2.0.0.tar.gz"
    sha256 "7b05f2fcac4fb67fc9f77a7d4c5d98a0f3099fb73b57c69ec1b080773994671b"
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
    url "https://files.pythonhosted.org/packages/ed/f9/6ef8feb52c3cce5ec3967a535a6114b57ac7949fd166b0f3090c2b06e4e5/boto3-1.40.61.tar.gz"
    sha256 "d6c56277251adf6c2bdd25249feae625abe4966831676689ff23b4694dea5b12"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/28/a3/81d3a47c2dbfd76f185d3b894f2ad01a75096c006a2dd91f237dca182188/botocore-1.40.61.tar.gz"
    sha256 "a2487ad69b090f9cccd64cf07c7021cd80ee9c0655ad974f87045b02f3ef52cd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/c3/a4/34847b59150da33690a36da3681d6bbc2ec14ee9a846bc30a6746e5984e4/click_plugins-1.1.1.2.tar.gz"
    sha256 "d7af3984a99d243c131aa1a828331e7630f4a88a9741fd05c927b204bcf92261"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/5d/48/e481c0a9b9010a5c41b5ca78ff9fbe00dc8a9a4d39da5af610a4ec49c7f7/cloudflare-4.3.1.tar.gz"
    sha256 "b1e1c6beeb8d98f63bfe0a1cba874fc4e22e000bcc490544f956c689b3b5b258"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "darabonba-core" do
    url "https://files.pythonhosted.org/packages/06/d9/076bfec3ef28b39d04a9c5e48ef56f20f1a62ed9f684f857a7c503b362b6/darabonba_core-1.0.7.tar.gz"
    sha256 "c2de2ee260682b4c08c9ec67793de66a2bdf316363b9165f152b9acaa16b4dc3"
  end

  resource "dash" do
    url "https://files.pythonhosted.org/packages/db/7c/8569c50a4c07fabee6b2428a1515c0c92247e2127367b438a9f99d69723c/dash-3.1.1.tar.gz"
    sha256 "916b31cec46da0a3339da0e9df9f446126aa7f293c0544e07adf9fe4ba060b18"
  end

  resource "dash-bootstrap-components" do
    url "https://files.pythonhosted.org/packages/49/8d/0f641e7c7878ac65b4bb78a2c7cb707db036f82da13fd61948adec44d5aa/dash_bootstrap_components-2.0.3.tar.gz"
    sha256 "5c161b04a6e7ed19a7d54e42f070c29fd6c385d5a7797e7a82999aa2fc15b1de"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
    sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/7f/85/ceb8ecff5cdeee4ceeebb86b599476dee559041dacc6c2c50cc0d4711549/dulwich-1.2.5.tar.gz"
    sha256 "0395b2c8924c3424bafe2d9c1edd5348cc4b21ce9c1d6655bf01f9a5c47164c8"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/9d/a4/e44218c2b394e31a6dd0d6b095c4e1f32d0be54c2a4b250032d717647bab/durationpy-0.10.tar.gz"
    sha256 "1fa6893409a6e739c9c72334fc65cca1f355dbdd93405d30f726deb5bde42fba"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/48/ce/13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1/email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/dc/be6cbe99670cd6e4ad387123647cb08e0c32975e223f82551e914c5568a6/filelock-3.29.4.tar.gz"
    sha256 "10cdb3656fc44541cdf30652a93fb10ec6b05325620eb316bd26893e4201538a"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c6/22/155cadf1d49272a9cf48f3168c0f3874fa13397297e611a5ea00cd093880/google_api_core-2.31.0.tar.gz"
    sha256 "2be84ee0f584c48e6bde1b36766e23348b361fb7e55e56135fc76ce1c397f9c2"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/29/9f/535346bb1469ec91139c38f0438ad70bd229a6b11452367065fe49303860/google_api_python_client-2.163.0.tar.gz"
    sha256 "88dee87553a2d82176e2224648bf89272d536c8f04dcdda37ef0a71473886dd7"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/81/1c/70b23fc52b2bb3c70b379f3bd05c4a60ab3a873e30c6bd21c57e0154848a/google_auth-2.55.0.tar.gz"
    sha256 "fcd3a130f575fa36403d38774af1c64a4fbfbca09215f0589d2372b5119697cb"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "graphemeu" do
    url "https://files.pythonhosted.org/packages/76/20/d012f71e7d00e0d5bb25176b9a96c5313d0e30cf947153bfdfa78089f4bb/graphemeu-0.7.2.tar.gz"
    sha256 "42bbe373d7c146160f286cd5f76b1a8ad29172d7333ce10705c5cc282462a4f8"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/1d/17/afa56379f94ad0fe8defd37d6eb3f89a25404ffc71d4d848893d270325fc/h2-4.3.0.tar.gz"
    sha256 "6c59efe4323fa18b47a632221a1888bd7fde6249819beda254aeca909f221bf1"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c1/1f/e86365613582c027dda5ddb64e1010e57a3d53e99ab8a72093fa13d565ec/httplib2-0.31.2.tar.gz"
    sha256 "385e0869d7397484f4eab426197a4c020b606edd43372492337c0b4010ae5d24"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "iamdata" do
    url "https://files.pythonhosted.org/packages/c1/5c/da5634cfad2360319f2ba8391634b32eff5135cbbc8ead3a04b90b4c6abc/iamdata-0.1.202606251.tar.gz"
    sha256 "f9d6a73bd7d8e85b847e29bd1febddc0684f9791a2bdb73cf516d2f9c1e12e3f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a9/01/15bb152d77b21318514a96f43af312635eb2500c96b55398d020c93d86ea/importlib_metadata-9.0.0.tar.gz"
    sha256 "a4f57ab599e6a2e3016d7595cfd72eb4661a5106e787a95bcc90c7105b831efc"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
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
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "jwcrypto" do
    url "https://files.pythonhosted.org/packages/de/7e/53c14813521693e931e420d9db00efe317419ff194495903bce03402275e/jwcrypto-1.5.8.tar.gz"
    sha256 "c3d7114b6f6e65b52f6b7da817eb8cb8423e1da31e1ef13508447c81ecbdcc34"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/02/d9/a01a3898657626cbcca9fa0e8fa58facb4632e172bdac622d47950f7e12a/keystoneauth1-5.14.0.tar.gz"
    sha256 "7b942084d3db27dd285c13253cdfee10b05be0436db1c01e15dc744902197a7f"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/b7/e8/0598f0e8b4af37cd9b10d8b87386cf3173cb8045d834ab5f6ec347a758b3/kubernetes-32.0.1.tar.gz"
    sha256 "42f43d49abd437ada79a79a16bd48a604d3471a117a8347e87db693f2ba0ba28"
  end

  resource "linode-api4" do
    url "https://files.pythonhosted.org/packages/b2/b5/fce03d9b81008dcc0fe4961ce10e140ac3ae5ab17f2cdd659763e4964c0d/linode_api4-5.45.0.tar.gz"
    sha256 "af8a0a5638345ad467447112dcf5d58ec47e7dd192b89ce0c8537a1e5c435d04"
  end

  resource "lz4" do
    url "https://files.pythonhosted.org/packages/57/51/f1b86d93029f418033dddf9b9f79c8d2641e7454080478ee2aab5123173e/lz4-4.4.5.tar.gz"
    sha256 "5f0b9e53c1e82e88c10d7c180069363980136b9d7a8306c4dca4f760d60c39f0"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/8f/94/37315b82a1bcc08145e5bc2af7396a4be8160ac138ec269611c3b9589b7a/microsoft_kiota_abstractions-1.9.9.tar.gz"
    sha256 "5df9a8e0517a4568726c2cac6d9789284cc6ffa66043b68eba42ae55749fb861"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/ca/ce/5ae8b37ee4a50f0ed5e092c2d0105d60b592e6102a190959f76658a0994c/microsoft_kiota_authentication_azure-1.9.9.tar.gz"
    sha256 "aca5e7dc8a0a28224f9025a479349ac2f9aaf166bfd6bc707f232658b45eec28"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/5d/3f/fc18eb0d1d845daf6355fd54fd990af7f7e10043ef6a6da39b9e5981cbaf/microsoft_kiota_http-1.9.9.tar.gz"
    sha256 "ae672b145df71b644f8da0951767a12a4ce47a40576d86eba19b7c22d9e160f9"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/ee/b4/18e9fce60a30c8b6ea0a6278fb81cf352127340d48df2d7c52ff1b579488/microsoft_kiota_serialization_form-1.9.9.tar.gz"
    sha256 "3cdc8b172baec5b5282af72f2ce02715edcd23252ce0b5af96075256edd75114"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/b8/2f/d36eba916c00136da122d1701acb862c5b1f2e22b6dc6fa4e0f4abda2786/microsoft_kiota_serialization_json-1.9.9.tar.gz"
    sha256 "9b27479427f49bbac15ead8e8ff0176e47fcdf81153611acc408f5f399342079"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/5f/44/24087f0fac7c5682c13c7fb61468a0c5a5185b9f243de3a99309aa6fcaa7/microsoft_kiota_serialization_multipart-1.9.9.tar.gz"
    sha256 "f8730be6da5f6c63a6bf4ea310a9723b9998a47a04745887dc156d08f119a829"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/a3/3c/d244ad08e03003134871698aa54de8243bcc61c0faf3ab114293bb76d6ad/microsoft_kiota_serialization_text-1.9.9.tar.gz"
    sha256 "18bc0764dda4078a4c953300253344e05d0cdb9c17136f1a2f695d438cedb402"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/9a/99/d840198ecf6e8057bbc937f129ae940404485d736cda73253bbff9537f01/msal-1.37.0.tar.gz"
    sha256 "1b1672a33ee467c1d70b341bb16cafd51bb3c817147a95b93263794b03971bec"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/68/4e/123f9530ec43b306c597bb830c62bedab830ffa76e0edf33ea88a26f756e/msgraph_core-1.3.8.tar.gz"
    sha256 "6e883f9d4c4ad57501234749e07b010478c1a5f19550ef4cf005bbcac4a63ae7"
  end

  resource "msgraph-sdk" do
    url "https://files.pythonhosted.org/packages/10/44/0b5a188addf6341b3da10dd207e444417de255f7c1651902ba72016a2843/msgraph_sdk-1.55.0.tar.gz"
    sha256 "6df691a31954a050d26b8a678968017e157d940fb377f2a8a4e17a9741b98756"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/62/3c/c4ef2164a71c1a63d7f1ae411c4082c5fa872405106db60a4b7114989ad7/narwhals-2.22.1.tar.gz"
    sha256 "d62920805a0a43b7ff8b54b0c0d3142d796f8a9301836ada37e573d6a33cbcd9"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/11/f4/3c2eddccc75dd06a692dbb3290f20f4bc733d99dc60de21f22d65efdeae4/oci-2.169.0.tar.gz"
    sha256 "f3c5fff00b01783b5325ea7b13bf140053ec1e9f41da20bfb9c8a349ee7662fa"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/c9/58/f38bc707e51c7ca6b745c87ff7eacf1c2cf4591582062eea5d5700b00837/okta-3.4.2.tar.gz"
    sha256 "b05201056f3f028c5d2d16394f9b47024a689080f5a993c11d4d80f0e1b5ba1e"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/ca/64/e1a90090a5e892f272b73bec5069b676a422bac9ff24193bdac4b868daa6/openstacksdk-4.2.0.tar.gz"
    sha256 "5cb9450dcce8054a2caf89d8be9e55057ddfa219a954e781032241eb29280445"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/ae/cc/e4c9584181f86494df0f6bdec1a4f3280c50db44704dc2a407e994fc87bb/opentelemetry_api-1.43.0.tar.gz"
    sha256 "107d0d03857ea8fc7c5fcbbbd83f800c281f0d560553d61c1d675fccfd1761c1"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/3e/eb/5041074274ac0956b03637cc039d434569112468e875eddfcc9a0674ce06/opentelemetry_sdk-1.43.0.tar.gz"
    sha256 "d8187c81c162df9913e4003dd6485f7390d9a24fc17026ec7387b8b8218b08e9"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/5a/30/5f26df29509eccd86b99b481ac9ffa39da49ba9577cc69071c552ae30447/opentelemetry_semantic_conventions-0.64b0.tar.gz"
    sha256 "72f76fb2d1582d9d033dd1fcd84532e961e6ff3d90d24ba6fabc72975a83864c"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/51/62/31e39aa8f2ac5bff0b061ce053f0610c9fe659e12aeca20bfb26d1665024/os_service_types-1.8.2.tar.gz"
    sha256 "ab7648d7232849943196e1bb00a30e2e25e600fa3b57bb241d15b7f521b5b575"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/9c/d6/9f8431bacc2e19dca897724cd097b1bb224a6ad5433784a44b587c7c13af/pandas-2.2.3.tar.gz"
    sha256 "4f18ba62b61d7e192368b84517265a99b4d7ee8912f8708660fb4a366cc82667"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/94/fd/d72c292d78aadb93d1a9bcd76bf3c678271040c7cf10abe5788b33040a39/plotly-6.8.0.tar.gz"
    sha256 "e088e7ddc68d4f70e3d66659224727a45296d71d2b8284181862d3d8f1f0d88f"
  end

  resource "polling" do
    url "https://files.pythonhosted.org/packages/8f/c5/4249317962180d97ec7a60fe38aa91f86216533bd478a427a5468945c5c9/polling-0.3.2.tar.gz"
    sha256 "3afd62320c99b725c70f379964bf548b302fc7f04d4604e6c315d9012309cc9a"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/c9/56/e647b0c675392d2da368da7b6f158f7368b18542fd6f7d7400a2f39de000/proto_plus-1.28.0.tar.gz"
    sha256 "38e5696342835b08fc116f30a25665b29531cda9d5d5643e9b81fc312385abd9"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/da/01/9ef0afd7999eb9badb3a768b4aedd78c86d4c65cfaf1958ab276199e76b4/protobuf-7.35.1.tar.gz"
    sha256 "ce115a26fe0c39a2c29973d914d327e516a6455464489fe3cd1e51a1b354f81a"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "py-iam-expand" do
    url "https://files.pythonhosted.org/packages/a3/08/f6e11a029b81f0bec4b7b1f18704aadf509a882cc386c90ef1ac043c18cc/py_iam_expand-0.3.0.tar.gz"
    sha256 "4ccfe25f40ba0633a152c4f86b49cde8972ee3d4b6009b017a4310cc4b9e64c7"
  end

  resource "py-ocsf-models" do
    url "https://files.pythonhosted.org/packages/f5/70/61e2f9ce3d7e83aa5339ed6ae17e473c15c7a36f161c6dbea0e939e3af0c/py_ocsf_models-0.8.1.tar.gz"
    sha256 "c9045237857f951e073c9f9d1f57954c90d86875b469260725292d47f7a7d73c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/75/c1/1c55272f49d761cec38ddb80be9817935b9c91ebd6a8988e10f532868d56/pydash-8.0.6.tar.gz"
    sha256 "b2821547e9723f69cf3a986be4db64de41730be149b2641947ecd12e1e11025a"
  end

  resource "pygithub" do
    url "https://files.pythonhosted.org/packages/94/a3/cd19cd08ddd34f35040d8ab9577262b296f014856089c821d677061e5bd1/pygithub-2.8.0.tar.gz"
    sha256 "72f5f2677d86bc3a8843aa720c6ce4c1c42fb7500243b136e3d5e14ddb5c3386"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/1a/51/27a5ad5f939d08f690a326ef9582cda7140555180db71695f6fb747d6a36/pyopenssl-26.2.0.tar.gz"
    sha256 "8c6fcecd1183a7fc897548dfe388b0cdb7f37e018200d8409cf33959dbe35387"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
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
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/c8/5a/b17e1e257d3e6f2e7758930e1256832c9ddd576f8631781e6a072914befa/retrying-1.4.2.tar.gz"
    sha256 "d102e75d53d8d30b88562d45361d6c6c934da06fab31bd81c0420acb97a8ba39"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "scaleway" do
    url "https://files.pythonhosted.org/packages/64/ce/774eea10c35fb0f028d0ae2e45d404bc16d83ac5cdd12f410d348e6dd6a4/scaleway-2.10.3.tar.gz"
    sha256 "b1f9dd1b1450767205234c6f5a345e5e25dc039c780253d698893b5c344ce594"
  end

  resource "scaleway-core" do
    url "https://files.pythonhosted.org/packages/61/6a/9f53cc92ad2332f96b48bd4975e53e15b8099a148a4e7386d64d393538d5/scaleway_core-2.10.3.tar.gz"
    sha256 "56432f755d694669429de51d51c1d0b3361b28dc2f939b28e4cb954610ee76be"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
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
    url "https://files.pythonhosted.org/packages/b6/dd/645f3eb93fce38eadbb649e85684730b1fc3906c2674ca59bddc2ca2bd2e/slack_sdk-3.39.0.tar.gz"
    sha256 "6a56be10dc155c436ff658c6b776e1c082e29eae6a771fccf8b0a235822bbcb1"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "stackit-core" do
    url "https://files.pythonhosted.org/packages/24/90/20f9ec7387eec4067cfd3d29055d0e2b5e1e0322c601a7f48125fd8ea35f/stackit_core-0.2.0.tar.gz"
    sha256 "b8af91877cdb060d6969a303d8cf20bc0b33b345afd91f679c44a987381e2d47"
  end

  resource "stackit-iaas" do
    url "https://files.pythonhosted.org/packages/52/07/24e65278300d5c3cb19cb1660bff924c80812cf8aad3e715f826bae5aa80/stackit_iaas-1.4.0.tar.gz"
    sha256 "93523b23442350c7ebefd9129485c4c2a539f694a9c36a0f8edfaba9862057ea"
  end

  resource "stackit-objectstorage" do
    url "https://files.pythonhosted.org/packages/90/80/b790756af40a5c6d979dd688b2557394ac54b594eb4c08edc33157ba890f/stackit_objectstorage-1.4.0.tar.gz"
    sha256 "4a3812b4de102b199f061706a802909f9e53ae9b0858769d5bd720f814c8bdbe"
  end

  resource "stackit-resourcemanager" do
    url "https://files.pythonhosted.org/packages/23/2d/f458f18e48ed2b1c83df52cff7dbdfd5dd904fb2980ffd9385876e47bbd9/stackit_resourcemanager-0.8.0.tar.gz"
    sha256 "f44542beab4130857f5a7f465cf02defeef657bdf63c1beeb3102f0ba3c003fe"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/74/45/575604653c42b26eb693a6564cfbcf38ea8eb1feaa0a1f85df1a0d995a4b/std_uritemplate-2.0.10.tar.gz"
    sha256 "35048a322217aed9766fdffe5a69f0632f7319577a4a265268761cd4ffa3205e"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/e9/88/35e4d27d9177d7df76d060e0a18f69c6c5794c96960c94042e20a12c8ba2/stevedore-5.8.0.tar.gz"
    sha256 "b49867b32ca3016e94100e68dbf26e72aa7b8708d0a3f73c08aeb220370ac715"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/65/7b/644fbbb49564a6cb124a8582013315a41148dba2f72209bba14a84242bf0/tldextract-5.3.1.tar.gz"
    sha256 "a72756ca170b2510315076383ea2993478f7da6f897eef1f4a5400735d5057fb"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uuid6" do
    url "https://files.pythonhosted.org/packages/2c/56/2560a9f1ccab9e12b1b3478a3c870796cf4d8ee5652bb19b61751cced14a/uuid6-2024.7.10.tar.gz"
    sha256 "2d29d7f63f593caaeea0e0d0dd0ad8129c9c663b29e19bdf882e864bedf18fb0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/fe/a4/282c8e64300a59fc834518a54bf0afabb4ff9218b5fa76958b450459a844/wrapt-2.2.2.tar.gz"
    sha256 "0788e321027c999bf221b667bd4a54aaefd1a36283749a860ac3eb77daed0302"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/46/2c/c06ef49dc36e7954e55b802a8b231770d286a9758b3d936bd1e04ce5ba88/xlsxwriter-3.2.9.tar.gz"
    sha256 "254b1c37a368c444eac6e2f867405cc9e461b0ed97a3233b2ac1e574efb4140c"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/79/12/1e8f37460ea0f7eb59c221fdaf0ed75e7ac43e97f8093b9c6f411df50a78/yarl-1.24.2.tar.gz"
    sha256 "9ac374123c6fd7abf64d1fec93962b0bd4ee2c19751755a762a72dd96c0378f8"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/b9/d8/eab98a517c14134c0b2eb4e2387bc5f457334293ec5d2dd3857ec2966802/zipp-4.1.0.tar.gz"
    sha256 "4cb57381f544315db7688e976e922a2b18cdb513d21cc194eb42232ba2a3e602"
  end

  resource "zstd" do
    url "https://files.pythonhosted.org/packages/49/62/b9c075ad664e7c4cbb3d8d2be7c246506abe1bc7f778eb58d260ef9538c8/zstd-1.5.7.3.tar.gz"
    sha256 "403e5205f4ac04b92e6b0cda654be2f51de268228a0db0067bc087faacf2f495"
  end

  def install
    ENV.O0

    virtualenv_install_with_resources
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "Unable to locate credentials", shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)
    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end
