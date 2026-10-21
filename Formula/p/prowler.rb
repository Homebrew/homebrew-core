class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Tool for cloud security assessments, audits, incident response, and more"
  homepage "https://prowler.com/"
  url "https://files.pythonhosted.org/packages/c1/aa/f042c697023e943743e3ef8ccb0e52a6ee43a4deec27b094e2fb62f2b2bb/prowler-5.45.0.tar.gz"
  sha256 "ee9c7dc193c9376ce0ec5b5fac0c0f3e360d6f5beee387029b5fa4ee4ed44a34"
  license "Apache-2.0"
  head "https://github.com/prowler-cloud/prowler.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "630ab370ef13947104a272b272f5620b9a884705bc4582a202ecc731ae4102c0"
    sha256 cellar: :any, arm64_tahoe:       "c2589182bb18a53244e8e6f48905f0c7d9becab4809964cc900b1303af8c2c2d"
    sha256 cellar: :any, arm64_sequoia:     "51051a2fb391cb3e7f1be844f772c15c0a608f767d4abc08db8b752c81ae923d"
    sha256 cellar: :any, arm64_linux:       "d60c7c1a941085dc870849161581c2df6ddf1245c37e9613fc170694885ca32f"
    sha256 cellar: :any, x86_64_linux:      "a1bfd8523ff77618d6026d2740cd299ff859f62e2c603f72f7460ef8c1c61927"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "kingfisher" # replaces the kingfisher-bin PyPI package
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "openssl@3" # TODO: use `openssl@4` with python 3.14+
  depends_on "python@3.13" # TODO: https://github.com/prowler-cloud/prowler/issues/12649

  uses_from_macos "libffi"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "openblas"
  end

  pypi_packages exclude_packages: %w[certifi kingfisher-bin]

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
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
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
    url "https://files.pythonhosted.org/packages/a7/62/5ad776035482fddb8831459c7072f25463f2cb06e5b8b1e93eb537c2a43e/alibabacloud_darabonba_encode_util-0.0.3.tar.gz"
    sha256 "f293ed5f5933e97061a51d80aeb4bdc4d38bc67f6e0aca6eda7c5d7814b21c46"
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
    url "https://files.pythonhosted.org/packages/ed/13/6f32d792c1180b57b0f26153a1943483536d543cc24fe5be844d65d22cab/alibabacloud_gateway_oss-0.0.29.tar.gz"
    sha256 "7ec8ea2f7f83bc7201326d6c2360c78fd092bc1931c5824d368b46d4d8779bee"
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
    url "https://files.pythonhosted.org/packages/ab/34/1918a2d780676494365c7f945bfab397ecddb988054d78025bd26f438977/alibabacloud_tea_openapi-0.4.6.tar.gz"
    sha256 "dafc32401712f5b21c12dc3d05ba887a91ad156d9b49a7662279f9fd90526fb2"
  end

  resource "alibabacloud-tea-util" do
    url "https://files.pythonhosted.org/packages/01/22/d3ce00317d9ba963bcc48234210bd718c42425267ecb05881cbb189b1c76/alibabacloud_tea_util-0.3.15.tar.gz"
    sha256 "79f78e596f6be03fb9565e34ac45420f3730e52888376cc9713bd07432a4c6cc"
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

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/8c/6b/eeff360196bb20b312c9e762a820fd1b2c6d809466c755ef57863478e454/apscheduler-3.11.3.tar.gz"
    sha256 "cd2fcc9330039a81a5893472ad49facf23a6d5604cbe1d918c835c6de7834d5a"
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

  resource "azure-mgmt-cognitiveservices" do
    url "https://files.pythonhosted.org/packages/fa/8e/9fcfdd507413a2536c5458b40942705ea8d74fe4e17f05fd1c32bb0225a9/azure_mgmt_cognitiveservices-14.1.0.tar.gz"
    sha256 "915191374d0adb443863c20aaea2c9f3b9d558a849ac2b78f152249262fdcaf8"
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

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
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

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/de/41/6cbdcf9142d00fe82836fbb51e503e58088575cf7a0fe1dbff6695bf0840/cryptography-50.0.0.tar.gz"
    sha256 "eeac2acb5a20ed25e0ad6d1df9891a520b78b404266b6d11778f25d5d691a6c9"
  end

  resource "darabonba-core" do
    url "https://files.pythonhosted.org/packages/49/72/a1ae02a243be50e48aeedcaa089c153227300ed419880b99ac68bc4a259f/darabonba_core-1.0.9.tar.gz"
    sha256 "1026c965b4c2b48f89995eadad7ab780a03959812c8f8de4670eb44c48e5b179"
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
    url "https://files.pythonhosted.org/packages/f7/9c/16649913bf14c73e0a9453782e148362ff2657067deff6aa9c7ebcddcc31/deprecated-3.0.0.tar.gz"
    sha256 "16850204d3a1e6bb0acd06bff48d96e8b0a0d25d1c52f71705405a0f4894192d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ef/4a/50822184bd67cc6493f0fb6a880749158fcd31ab3fa07409acfd91f9fc85/dnspython-2.9.0.tar.gz"
    sha256 "b44dc6b18f07a8b1c56676a19fbfdb5209415b046a9cece286baafa87ff3f7f1"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/de/17/0a0fa2b998cd9a852b1aa901e3f6145f13a4334f64b91564847e5880968d/dulwich-1.2.9.tar.gz"
    sha256 "b395466b78eb5c36baf34381b8b831fd26da8a44b428a2eea1d57ba53f68a234"
  end

  resource "durationpy" do
    url "https://files.pythonhosted.org/packages/b0/5d/5f8571bd5dedc80863191621ac4be001f3f3dd8315d2ec078705dab7dec1/durationpy-0.11.tar.gz"
    sha256 "181898e1ae282e288f0a2291829656bf1b6b3aadf30a97993b85db4943642905"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/48/ce/13508a1ec3f8bb981ae4ca79ea40384becc868bfae97fd1c942bb3a001b1/email_validator-2.2.0.tar.gz"
    sha256 "cb690f344c617a714f22e66ae771445a1ceb46821152df8e165c5f9a364582b7"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f4/a9/1af41b37c3279712b22cdc63aac78a52432202b6fe1f9666a2a3d2831fb4/filelock-4.2.0.tar.gz"
    sha256 "7a60906c75227cf04d0c273afadc8219400f11aeb13cc69591d4f6cdc6c8036e"
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
    url "https://files.pythonhosted.org/packages/ac/aa/2aa84799e6920216f8aa2866d3b43daa20f7060dcb6efc8f0449e8be0ab0/google_api_core-2.42.0.tar.gz"
    sha256 "82cf5daa2ef1b456d4e29ff1de1a5c2995c7be3ccf4fc608184326e03390c1ee"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/29/9f/535346bb1469ec91139c38f0438ad70bd229a6b11452367065fe49303860/google_api_python_client-2.163.0.tar.gz"
    sha256 "88dee87553a2d82176e2224648bf89272d536c8f04dcdda37ef0a71473886dd7"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/f5/b9/4b2528f30114b106e3c3a7298ba38d85e682fd1f83fe7c4a5b77c7677082/google_auth-2.62.0.tar.gz"
    sha256 "0bef0ce54bdf9ce226c5d66e4264413bd918141c31bbe49fb52eac882f513d69"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/8d/2b/6ce81972d5c8cab9705fddce3153be63222d9e12fd96f8baba5038a744dd/googleapis_common_protos-1.75.5.tar.gz"
    sha256 "c7a866fc34ed29a3b10af627a4b9b1dc2433313ca6e959f0ae4feb132047ed72"
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
    url "https://files.pythonhosted.org/packages/84/f5/ccf58de92d61e3ad921119668f54ed36ca1d0cf5dcc5c1657dfb164fd78b/httplib2-0.32.0.tar.gz"
    sha256 "48a0ef30a42db65d8f3399045e1d09ab0ba66e3b9efc360d07f80ea55d286025"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huaweicloudsdkcore" do
    url "https://files.pythonhosted.org/packages/e4/f5/65e90764ea3bbfef50fb68cd5e12340acf1f51e9276b11745fbf5feb7e0e/huaweicloudsdkcore-3.1.204-py3-none-any.whl"
    sha256 "9ae17744795ebdc8ce9291373a3a27bf72e90aa98677cfce0ea9394376875a95"
  end

  resource "huaweicloudsdkcts" do
    url "https://files.pythonhosted.org/packages/58/32/d06328e35375d4aa606719a27856cdf57b1f7fb0c49d4dfd22a9609dba19/huaweicloudsdkcts-3.1.204-py3-none-any.whl"
    sha256 "9def561aa784a6ee13b46bfc96888cd1df5bfc42f8a89e60b42c91c608bf6d60"
  end

  resource "huaweicloudsdkecs" do
    url "https://files.pythonhosted.org/packages/88/66/f8e4a3b9ca70d3ea79c4d200f928ed9ffdf4910ac01be4864967408c8f18/huaweicloudsdkecs-3.1.204-py3-none-any.whl"
    sha256 "dc5715d782c0260b901c793d009d5e632257acb04257b6f2c6631e415c589343"
  end

  resource "huaweicloudsdkelb" do
    url "https://files.pythonhosted.org/packages/34/4b/9bdc7e2066419d967e9b812cfacfb9c4996a8e977dc39853309a3c1ac9e2/huaweicloudsdkelb-3.1.204-py3-none-any.whl"
    sha256 "620247c2b2a7f20e7da8b18fe9c64e29972055f015bc35270fb5b43243dc4830"
  end

  resource "huaweicloudsdkevs" do
    url "https://files.pythonhosted.org/packages/f7/cf/531dc55fd9d0f3bbd3eef24c7e4d78c6a1ba8eb80fa506e3574d72bcc98a/huaweicloudsdkevs-3.1.204-py3-none-any.whl"
    sha256 "9118ac4c576e54aa7eaa926949e2b6824c5f038a2274b51d9a304d37fc0d7e2f"
  end

  resource "huaweicloudsdkiam" do
    url "https://files.pythonhosted.org/packages/f7/9a/7da0fbe9b83bc7a7f6d586366b81e829ed355a57419d2184b7dd51f8c2a3/huaweicloudsdkiam-3.1.204-py3-none-any.whl"
    sha256 "0021e204f81ceef2640017e517adb72ba56c9ced03f071a0265b10bc9759badf"
  end

  resource "huaweicloudsdkkms" do
    url "https://files.pythonhosted.org/packages/28/3a/7392617d585cb2005f7d9ade0b0e0e493a7a88daf56e8dc39e4e219cc5d0/huaweicloudsdkkms-3.1.204-py3-none-any.whl"
    sha256 "378986f33113ce99f445ef318d1c7dda89e361d16c008e5ef9793981d8385376"
  end

  resource "huaweicloudsdkobs" do
    url "https://files.pythonhosted.org/packages/af/49/28a09e1e33d1c039be22ee4171efaa739351653c7aa88d3a2f7a78d90217/huaweicloudsdkobs-3.1.204-py3-none-any.whl"
    sha256 "8c5830fa30293185964d98e524887fc510c8e17ca2fadb4563dad10910f37b13"
  end

  resource "huaweicloudsdkrds" do
    url "https://files.pythonhosted.org/packages/18/7d/721f162c46e3de604a73674223bf6c6bc6cf7ade25b3751a71288f4dd122/huaweicloudsdkrds-3.1.204-py3-none-any.whl"
    sha256 "a790b5b3c457a608e5679c101f463b4d037dd9a8a66f6e46144a9e5a4b37780f"
  end

  resource "huaweicloudsdksmn" do
    url "https://files.pythonhosted.org/packages/e9/5d/c0de47d011f1932c9c0ddf669c238d9fad01653d438d38203703526799d7/huaweicloudsdksmn-3.1.204-py3-none-any.whl"
    sha256 "b0818ea9293e27458c8fa1d2da021c98006cbf9ce01cf17a0f1df598c4da3a6c"
  end

  resource "huaweicloudsdkvpc" do
    url "https://files.pythonhosted.org/packages/de/b5/4baa27c3a275ea92806068e35e06f249a30add8dd57c777bb45841f63406/huaweicloudsdkvpc-3.1.204-py3-none-any.whl"
    sha256 "c57d6b6d2f70deca91e86f7956b33fc9ac4991b431f0d608c3632231119f8970"
  end

  resource "huaweicloudsdkwaf" do
    url "https://files.pythonhosted.org/packages/9e/21/01590dce200be487756451f5e9efb99da7810688062d177e4b58d6062465/huaweicloudsdkwaf-3.1.204-py3-none-any.whl"
    sha256 "b2355276e0029808f45e2d1bd3eb14b37d2da9417e61e642ffe0e2b748ca8283"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "iamdata" do
    url "https://files.pythonhosted.org/packages/cf/7f/dee8d309e45cbfba9ceef9767efa2d7be4f6453d08121f21d99285324243/iamdata-0.1.202610151.tar.gz"
    sha256 "30f4d3766c843299e252f90394539bb4f996077c84974e8b55cb2590047cf91e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/6f/7e/1e7e8dc30634b93ebb3d58a3dea569ad146e656218d3960ab04f62047b29/importlib_metadata-9.0.1.tar.gz"
    sha256 "ab830580bc0ef3db61ce8fae716389e5462b67e033018bab6d8f80ef17172f99"
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
    url "https://files.pythonhosted.org/packages/df/f8/48a6033ebdd5013a58b5a79402eacb15ffb6e208f244c1c17f6f1e3b29c2/jsonpatch-1.35.tar.gz"
    sha256 "679ad08672b4663c7ef1e5f3331d940f5e7786661b9acc1530104be1638e7a4f"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/33/a2/c92f0a7ed439c490d2c8ad712fdb074c311afa4f77870987826a3b1483ba/jsonpointer-3.2.1.tar.gz"
    sha256 "47c846513b3a4ec46eecef1105207fba075e2a3659048e362bd7daff0fc33342"
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
    url "https://files.pythonhosted.org/packages/13/8f/e802d77957903483129813ce6fa01a72a906f9cdd454039d1ec1e6d1e44a/jwcrypto-1.6.1.tar.gz"
    sha256 "a1e1570da5c2e35dbcd375ec1d2891a24de8eb35ee2c1fe8e91978efb72cfe90"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/04/af/268e14554c6bd4a2614872fb2b8431e466ce01415a9783b260ce7fb7ae5c/keystoneauth1-5.18.1.tar.gz"
    sha256 "8970f9d103f335c39151366d70c001d1bb99b00d73845f03d47825e8dc35ff78"
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
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "microsoft-kiota-abstractions" do
    url "https://files.pythonhosted.org/packages/45/e1/39de28380fc0eddf12f66099469fb7561bc38f577ea06e3a074751ebbcd9/microsoft_kiota_abstractions-1.9.10.tar.gz"
    sha256 "8eb62d64c35ad0eeb4e8bcdbb143c0b308dc4a494e757f8e44cb959d34f44ecf"
  end

  resource "microsoft-kiota-authentication-azure" do
    url "https://files.pythonhosted.org/packages/d5/53/7760f979c141ec590f0c1cfcb92b3e410eb2909cc19feb42f3fce78db171/microsoft_kiota_authentication_azure-1.9.10.tar.gz"
    sha256 "b9f10a9fa86e36114abfee448d2dab91a502d6a55d349a306e2e41a1218fe1ad"
  end

  resource "microsoft-kiota-http" do
    url "https://files.pythonhosted.org/packages/a7/e5/20972b620bd8cca086c284e97b285d437c108a23fee122ad7b92bd246c1a/microsoft_kiota_http-1.9.10.tar.gz"
    sha256 "af1838d091f76426c974897357093ed977ce66f1d808cb161c190de873bb5833"
  end

  resource "microsoft-kiota-serialization-form" do
    url "https://files.pythonhosted.org/packages/56/90/7e1a090a2099acae1a1baa9a0762214b73b63d9268369b510994f75f54e4/microsoft_kiota_serialization_form-1.9.10.tar.gz"
    sha256 "4c6655d8cd479d1ada63fdfe6a272e50d87d7c8369dbc8e13833ba4787fc798b"
  end

  resource "microsoft-kiota-serialization-json" do
    url "https://files.pythonhosted.org/packages/67/0e/55afd533a764ba77da988b7ca4242c84867a3a25f2ff0bf4c2b24b5e8fca/microsoft_kiota_serialization_json-1.9.10.tar.gz"
    sha256 "6063028f30dd67afa2db20a72d9bde5e5d26d468f8bdedadd1445cf7c7630e17"
  end

  resource "microsoft-kiota-serialization-multipart" do
    url "https://files.pythonhosted.org/packages/24/34/eadc15c2a3131e2a76126f3112c32b73502cb5a335e2e40cac2877e5d843/microsoft_kiota_serialization_multipart-1.9.10.tar.gz"
    sha256 "8f2da4f93e79b09f9738b6889685e47acfafcca870db94ab1d4cd233d69e4268"
  end

  resource "microsoft-kiota-serialization-text" do
    url "https://files.pythonhosted.org/packages/74/a6/28a4a8d5c01f08e363135fc9585cab3c02d1b1a69c3c16032e6abb35dfed/microsoft_kiota_serialization_text-1.9.10.tar.gz"
    sha256 "cfc433c2a95ea3c3ec43c8b09002fbf65c998c5c0571205df161fe0e9d5d8de7"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/85/747d28986a44b715cc51cf57aa021c8fd94e9614064261ceec77320e8b0b/msal-1.39.0.tar.gz"
    sha256 "6ab7de335e6d7f5717e2c7e1dbf86e4dda2f6acf3c56773b78dc53ebc6395b5f"
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
    url "https://files.pythonhosted.org/packages/f9/79/84ddb5ba16c4eb2c69c71db76ae3c579fe546e511f7170c7e27eedbab7c1/multidict-7.1.0.tar.gz"
    sha256 "61a4e5d81b8d4e4ad61964b230129e7a2b914793d96289029078fc9009f074ec"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/bf/21/f64d6b2dbea7bf3f8c38cdc786dcc6ef012ca3d173ad208c782c9a7bedf6/narwhals-2.27.1.tar.gz"
    sha256 "aed93076a3ea42d9c32c88e4eb5ea422a21937011cbe1f480f9572a523c82094"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/76/21/7d2a95e4bba9dc13d043ee156a356c0a8f0c6309dff6b21b4d71a073b8a8/numpy-2.2.6.tar.gz"
    sha256 "e29554e2bef54a90aa5cc07da6ce955accb83f21ab5de01a62c8478897b264fd"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/7a/d8/a1bcc8ba112a627f8ffbdc212a78ce18d3ac07e91a5ca65d27918eee25a1/oauthlib-4.0.0.tar.gz"
    sha256 "efb274799819440f95b4ab3b818869f1ce9ae26c5beacba0201d1a1b76b54f86"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/74/2d/fa5368cfabb868f4111c6978e8b5f66aa3a55076c40c1a59ac3081b0227b/oci-2.184.1.tar.gz"
    sha256 "617dad69caf8dd6e521d224dbc3e8a8bc289906943a0214fd2c3419094e26435"
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
    url "https://files.pythonhosted.org/packages/2e/02/6e0ae9cc61bd3169d401077b507b3ebc344745171e1051ab430be012dcd9/opentelemetry_api-1.45.1.tar.gz"
    sha256 "aa38ed19bcc084ba42782a73255b3582283eced7ad6dddbd6695189e69adfb75"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/a1/79/7392e21a1c8f0c61d90b223e31c7e48cb9d452e91a6b820ad24cca5f23c4/opentelemetry_sdk-1.45.1.tar.gz"
    sha256 "63d24a6ca645019a631e6a51999c73e93adcac1196ca640b8ae78a7cc4762bf3"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/46/e4/dbbfb2a010c4db2224a5114638acede6fe563d33cc20fb1752cebcbe6298/opentelemetry_semantic_conventions-0.66b1.tar.gz"
    sha256 "497ca63bf383723411e8eaf60c8779e9877633c936bb641080adab59d0eb6ec8"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/86/ae/fe7ac23155ae0b4b9779e06e9c5bb4070f2315dc4ca886a88fa3230d344b/os_service_types-1.9.0.tar.gz"
    sha256 "1f2e5fb71d1f6f4ff31d8992674f2368465bc2f25cd94018015c3ddbfc5c617f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/9c/d6/9f8431bacc2e19dca897724cd097b1bb224a6ad5433784a44b587c7c13af/pandas-2.2.3.tar.gz"
    sha256 "4f18ba62b61d7e192368b84517265a99b4d7ee8912f8708660fb4a366cc82667"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/6b/8d/ce438c28c7958e33184e8ac851ea2225b47a41e5e9e708fa3bddba631135/pbr-7.1.3.tar.gz"
    sha256 "9a4a85b84e906337708009af0b5f5cdabeeb72d4dc213c9e97974da54fd9acc5"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/49/c3/72b369f5ed7701b04ab0ea3dcf83e9bbce71c0b3bc6f07f87568550d09ea/plotly-7.1.0.tar.gz"
    sha256 "f860166a4a3d78c69cb1f4a15f28a5c8283eade98a282a698f3bb853a449ace5"
  end

  resource "polling" do
    url "https://files.pythonhosted.org/packages/8f/c5/4249317962180d97ec7a60fe38aa91f86216533bd478a427a5468945c5c9/polling-0.3.2.tar.gz"
    sha256 "3afd62320c99b725c70f379964bf548b302fc7f04d4604e6c315d9012309cc9a"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/46/70/783e33ffbb4466cc154a94f79b869b92a451e2bd45605054e68ff68b7af6/proto_plus-1.29.0.tar.gz"
    sha256 "cfb4e62ad7e13dd18f346cabbda00cab39930d36a05791fd81ddb074d6ee884f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
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
    url "https://files.pythonhosted.org/packages/70/d6/f0787cbe953e3cf6ef4430f3cc7d66cbbaabe4b20cb82cc27cc2d21e622a/py_ocsf_models-0.10.0.tar.gz"
    sha256 "29abaa5a3d4ebba0e2a21757508a4848fa5e1d57da233af57e580f97f0223c59"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/da/a8/c5fdbeee588bb8ada9458774f43adf1bdd30bd59157055142183e769a024/pycparser-3.11.tar.gz"
    sha256 "d875f09c3507d00e1aba0eecc6dcadc1352f30fff09dc6bff2f1c2935e97c2bc"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f4/e7/50e72301e32acb73a314e663c2014e1ddefc019d5f434ff14ec89861d664/pycryptodomex-3.24.1.tar.gz"
    sha256 "09081666ffc599976c0b8b29caf2cf82212c0f05bed233c8f8ed53e4f6e1d356"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/69/44/36f1a6e523abc58ae5f928898e4aca2e0ea509b5aa6f6f392a5d882be928/pydantic-2.12.5.tar.gz"
    sha256 "4d351024c75c0f085a9febbb665ce8c0c6ec5d30e903bdb6394b7ede26aebb49"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/71/70/23b021c950c2addd24ec408e9ab05d59b035b39d97cdc1130e1bce647bb6/pydantic_core-2.41.5.tar.gz"
    sha256 "08daa51ea16ad373ffd5e7606252cc32f07bc72b28284b6bc9c6df804816476e"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/ae/49/45cd795ce88bde203c7b4cfd7c911c9078b32582afa3b9af579824d8789d/pydash-8.1.0.tar.gz"
    sha256 "30914c3e9d377ea2cd0d3c0a4f252889b08392f730a5eb4d117e5b598cdf1d52"
  end

  resource "pygithub" do
    url "https://files.pythonhosted.org/packages/94/a3/cd19cd08ddd34f35040d8ab9577262b296f014856089c821d677061e5bd1/pygithub-2.8.0.tar.gz"
    sha256 "72f5f2677d86bc3a8843aa720c6ce4c1c42fb7500243b136e3d5e14ddb5c3386"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/22/f5/c0c6732fbd358b75a07e17d7e588fd23d481b9812ca96ceeff90bbf879fc/pymongo-4.15.1.tar.gz"
    sha256 "b9f379a4333dc3779a6bf7adfd077d4387404ed1561472743486a9c58286f705"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
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

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/c8/5a/b17e1e257d3e6f2e7758930e1256832c9ddd576f8631781e6a072914befa/retrying-1.4.2.tar.gz"
    sha256 "d102e75d53d8d30b88562d45361d6c6c934da06fab31bd81c0420acb97a8ba39"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/42/68/3bd46b8a5e01d3c2ebdf9c5e9497912e3fe0cde02bac21a7130ca866e403/rpds_py-2026.9.1.tar.gz"
    sha256 "4793ef7f78268b124b73fa933440f01d258bbae01de9fa53e9080c9ab0425a12"
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
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/c5/06/c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28/shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/2f/f0/ea064bba6c9afda0168ddb834f1c75a93351031e25aee35c046108e7f292/simplejson-4.2.0.tar.gz"
    sha256 "55b121b70a560f4610bd3a355ab2015aca4f39978f6a82353f24d2013fe85861"
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

  resource "stackit-ske" do
    url "https://files.pythonhosted.org/packages/cd/9e/df3ad585cb96d028354f4253568e9879d81bb9395d5ebfa268fa9350e2df/stackit_ske-1.12.0.tar.gz"
    sha256 "62814279f3b7fb2387648f92d14453a8905ad60115c07579f2741ddb7d1fcc94"
  end

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/7a/f8/8f2b708394a6371e9b0e1cabdaf1be314f6b28c3697786a0a7e5f31ee9bf/std_uritemplate-2.0.12.tar.gz"
    sha256 "c245e6d9c6804e435c45fa94ee4a3c8a57e08aeeb45af261101cb0d513964534"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/fd/5d/45ece871390ccc985f821353543165bcf3784fa97d8484fd0ca5f2726612/tldextract-5.4.0.tar.gz"
    sha256 "6c9223212c15c25c0da2bf7313893c14f175cb36b64a0c42da67a468e0c61ee3"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/a3/26/b09b8010994eccc3c09092e6b34058f36a460eea2d4c3e8b910c695975a0/typing_inspection-0.4.4.tar.gz"
    sha256 "547274fa6b0a561ccf549cc9524b999a578e737d015d8709d021f9d0d13bea47"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/d9/68/f1b440335057bfce71b6e50a9d09445aa2ecbd08359a337976627b8409e7/tzdata-2026.5.tar.gz"
    sha256 "8cc73c0a0bfca7dbfa59235d60b2eff82231dee33f53d206db1acd9173cfc0a7"
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
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uuid6" do
    url "https://files.pythonhosted.org/packages/2c/56/2560a9f1ccab9e12b1b3478a3c870796cf4d8ee5652bb19b61751cced14a/uuid6-2024.7.10.tar.gz"
    sha256 "2d29d7f63f593caaeea0e0d0dd0ad8129c9c663b29e19bdf882e864bedf18fb0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/d8/cb/a5abcc2891249f393827c650c6296660ce40374ac22d99ab9aea41f9d2a2/websocket_client-1.9.2.tar.gz"
    sha256 "0fcb57545848be86992e128218fd96dd87a6769ffdb1a968dff79632b85604d0"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/a4/34/4dd12fc8bb7d61c91467ec3efe415ffa7d5456f799954b40c5bbaeae470e/werkzeug-3.1.9.tar.gz"
    sha256 "55ca7c70a75689be937aa27f8ff4b018f06ff4838fc73045560bf0f5a1291060"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/04/22/89e2f3bdae5cb34e0cab0cd86d7172dbf418de4b46c9b17b9c7a560dfa44/wrapt-2.5.1.tar.gz"
    sha256 "f595bb0185aab3e9dc31950c95d914f56ea8278810c3b928f3426e12ed6d27bc"
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
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/dc/23/655a1802fe8041302c959774ca7c80b53bc24737ff3ef45cb50ef11bd96c/zipp-4.1.1.tar.gz"
    sha256 "7ebb7a44c021b29fd8dbd7cce6812d0d7b5b454521f93cc71af6ccd155aaa70b"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  resource "zstd" do
    url "https://files.pythonhosted.org/packages/0f/78/9a476e09c825304df47b98be80d1ffe223733b03550af71325415028f615/zstd-1.5.7.2.tar.gz"
    sha256 "6d8684c69009be49e1b18ec251a5eb0d7e24f93624990a8a124a1da66a92fc8a"
  end

  def openssl = deps.map(&:name).find { |dep| dep.start_with?("openssl@") }

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)
    # Keep keg-only `aws-lc` headers (via `kingfisher`) from shadowing OpenSSL for `openssl-sys`
    ENV.prepend_path "HOMEBREW_INCLUDE_PATHS", formula_opt_include(openssl)
    ENV.O0

    venv = virtualenv_install_with_resources

    # Shim for kingfisher-bin, which only ships prebuilt binaries
    (venv.site_packages/"kingfisher.py").write <<~PYTHON
      def get_binary_path():
          return "#{formula_opt_bin("kingfisher")}/kingfisher"
    PYTHON
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "Unable to locate credentials", shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)
    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end
