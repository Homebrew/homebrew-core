class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Tool for cloud security assessments, audits, incident response, and more"
  homepage "https://prowler.com/"
  url "https://files.pythonhosted.org/packages/c6/5c/4526e8a5c9d055991d50556d124129c96f1567b7899e9e0088fa527f8982/prowler-5.16.1.tar.gz"
  sha256 "bb485798e6769a4746413553800f2def79d62c039c888fb5b6ff95c33a144f2d"
  license "Apache-2.0"
  revision 4
  head "https://github.com/prowler-cloud/prowler.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7aa71758944a24a7208de2c004dfeb3e59cfb684c0190c9d9df15638b6950803"
    sha256 cellar: :any,                 arm64_sequoia: "48dd3bff721473a2bd82e3f6938606cab73163d15f704d6dbc7e10df3652a4f2"
    sha256 cellar: :any,                 arm64_sonoma:  "1cd04cf91ce7775c6f44517bc7344645728e4612509bea6d6fe72fc3343d3279"
    sha256 cellar: :any,                 sonoma:        "d00f6b17af12f52abb9cbea9ba6274ac7100e65495924d78f4518bc42309080d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abeff548bee011ca49f5265553687e325840f93c109b236b0a301e399b70eaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44191d71417095d9add1baf71fb1ed1bed4db48cf9206552ff8a50ec46d2a182"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python@3.12" # https://github.com/prowler-cloud/prowler/issues/6737

  uses_from_macos "libffi"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "openblas"
  end

  pypi_packages exclude_packages: "certifi"

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/50/42/32cf8e7704ceb4481406eb87161349abb46a57fee3f008ba9cb610968646/aiohttp-3.13.3.tar.gz"
    sha256 "a949eee43d3782f2daae4f4a2819b2cb9b0c5d3b7f7a927067cc84dafdbb9f88"
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
    url "https://files.pythonhosted.org/packages/a0/87/1d7019d23891897cb076b2f7e3c81ab3c2ba91de3bb067196f675d60d34c/alibabacloud-credentials-api-1.0.0.tar.gz"
    sha256 "8c340038d904f0218d7214a8f4088c31912bfcf279af2cbc7d9be4897a97dd2f"
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
    url "https://files.pythonhosted.org/packages/bb/ca/38effb3f7e81f1abc78f0c283ba2d1a19cb9fbdc3a0ad7b8f6300a0a413c/alibabacloud_gateway_sls-0.4.0.tar.gz"
    sha256 "9d2aceb377c9b3ed0558149fda16fe39fa114cc0a22e22a88dc76efdda34633b"
  end

  resource "alibabacloud-gateway-sls-util" do
    url "https://files.pythonhosted.org/packages/c9/ef/590fee606b0ce16e28a0ece8c81338718b87c47d6bb1553f383ec493fafa/alibabacloud_gateway_sls_util-0.4.0.tar.gz"
    sha256 "f8b683a36a2ae3fe9a8225d3d97773ea769bdf9cdf4f4d033eab2eb6062ddd1f"
  end

  resource "alibabacloud-gateway-spi" do
    url "https://files.pythonhosted.org/packages/ab/98/d7111245f17935bf72ee9bea60bbbeff2bc42cdfe24d2544db52bc517e1a/alibabacloud_gateway_spi-0.0.3.tar.gz"
    sha256 "10d1c53a3fc5f87915fbd6b4985b98338a776e9b44a0263f56643c5048223b8b"
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
    url "https://files.pythonhosted.org/packages/97/fc/70941e03c618c41fb434cc3842e334c11e75d9fdf1f1f6355b6209eccc35/alibabacloud_tea_openapi-0.4.1.tar.gz"
    sha256 "2384b090870fdb089c3c40f3fb8cf0145b8c7d6c14abbac521f86a01abb5edaf"
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
    url "https://files.pythonhosted.org/packages/b2/ce/be2bc51121ab88ba9fd9d1f743a5bc2402036a0c4fe88d658d70bf03618e/aliyun_log_fastpb-0.2.0.tar.gz"
    sha256 "91c714e76fb941c9a0db6b1aa1f4c56cb1626254ff5444c1179860f5e5b63d93"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/07/12/3e4389e5920b4c1763390c6d371162f3784f86f85cd6d6c1bfe68eef14e2/apscheduler-3.11.2.tar.gz"
    sha256 "2a9966b052ec805f020c8c4c3ae6e6a06e24b1bf19f2e11d91d8cca0473eef41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
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
    url "https://files.pythonhosted.org/packages/dc/1b/e503e08e755ea94e7d3419c9242315f888fc664211c90d032e40479022bf/azure_core-1.38.0.tar.gz"
    sha256 "8194d2682245a3e4e3151a667c686464c3786fed7918b394d035bdcd61bb5993"
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
    url "https://files.pythonhosted.org/packages/63/65/ddd4f52d138e52c1345c2d2421281a98449a6e4365290477befe06fa649a/boto3-1.39.15.tar.gz"
    sha256 "b4483625f0d8c35045254dee46cd3c851bbc0450814f20b9b25bee1b5c0d8409"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2f/e2/8cd9560e7e44cf977dc0cc2e48da7634e78b7104ae6e47f4e1dfc1093965/botocore-1.39.15.tar.gz"
    sha256 "2aa29a717f14f8c7ca058c2e297aaed0aa10ecea24b91514eee802814d1b7600"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/df/ac/de7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccb/circuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/c3/a4/34847b59150da33690a36da3681d6bbc2ec14ee9a846bc30a6746e5984e4/click_plugins-1.1.1.2.tar.gz"
    sha256 "d7af3984a99d243c131aa1a828331e7630f4a88a9741fd05c927b204bcf92261"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/c7/67/545c79fe50f7af51dbad56d16b23fe33f63ee6a5d956b3cb68ea110cbe64/cryptography-44.0.1.tar.gz"
    sha256 "f51f5705ab27898afda1aaa430f34ad90dc117421057782022edf0600bec5f14"
  end

  resource "darabonba-core" do
    url "https://files.pythonhosted.org/packages/66/d3/a7daaee544c904548e665829b51a9fa2572acb82c73ad787a8ff90273002/darabonba_core-1.0.5-py3-none-any.whl"
    sha256 "671ab8dbc4edc2a8f88013da71646839bb8914f1259efc069353243ef52ea27c"
  end

  resource "dash" do
    url "https://files.pythonhosted.org/packages/db/7c/8569c50a4c07fabee6b2428a1515c0c92247e2127367b438a9f99d69723c/dash-3.1.1.tar.gz"
    sha256 "916b31cec46da0a3339da0e9df9f446126aa7f293c0544e07adf9fe4ba060b18"
  end

  resource "dash-bootstrap-components" do
    url "https://files.pythonhosted.org/packages/49/8d/0f641e7c7878ac65b4bb78a2c7cb707db036f82da13fd61948adec44d5aa/dash_bootstrap_components-2.0.3.tar.gz"
    sha256 "5c161b04a6e7ed19a7d54e42f070c29fd6c385d5a7797e7a82999aa2fc15b1de"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
    sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/4b/ac/ba58cf420640c7bc77ae8e1b31e174d83c9117750c63cf9ea3b5e202e5c4/dulwich-0.23.0.tar.gz"
    sha256 "0aa6c2489dd5e978b27e9b75983b7331a66c999f0efc54ebe37cab808ed322ae"
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
    url "https://files.pythonhosted.org/packages/1d/65/ce7f1b70157833bf3cb851b556a37d4547ceafc158aa9b34b36782f23696/filelock-3.20.3.tar.gz"
    sha256 "18c57ee915c7ec61cff0ecf7f0f869936c7c30191bb0cf406f1341778d0834e1"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/0d/10/05572d33273292bac49c2d1785925f7bc3ff2fe50e3044cf1062c1dde32e/google_api_core-2.29.0.tar.gz"
    sha256 "84181be0f8e6b04006df75ddfe728f24489f0af57c96a529ff7cf45bc28797f7"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/29/9f/535346bb1469ec91139c38f0438ad70bd229a6b11452367065fe49303860/google_api_python_client-2.163.0.tar.gz"
    sha256 "88dee87553a2d82176e2224648bf89272d536c8f04dcdda37ef0a71473886dd7"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/60/3c/ec64b9a275ca22fa1cd3b6e77fefcf837b0732c890aa32d2bd21313d9b33/google_auth-2.47.0.tar.gz"
    sha256 "833229070a9dfee1a353ae9877dcd2dec069a8281a4e72e72f77d4a70ff945da"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/e0/83/7ef576d1c7ccea214e7b001e69c006bc75e058a3a1f2ab810167204b698b/google_auth_httplib2-0.2.1.tar.gz"
    sha256 "5ef03be3927423c87fb69607b42df23a444e434ddb2555b73b3679793187b7de"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
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
    url "https://files.pythonhosted.org/packages/2c/48/71de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8/hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/77/df/6eb1d485a513776bbdbb1c919b72e59b5acc51c5e7ef28ad1cd444e252a3/httplib2-0.31.1.tar.gz"
    sha256 "21591655ac54953624c6ab8d587c71675e379e31e2cfe3147c83c11e9ef41f92"
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
    url "https://files.pythonhosted.org/packages/e8/f8/fc9fa887032fa7e58694915750ec9f13afcaf2dee6f6cbe69a75f1778b17/iamdata-0.1.202601171.tar.gz"
    sha256 "04aacce609692c037dc32fa44768529f8b99f0be4c14dc8c04ec2044e55b0533"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f3/49/3b30cad09e7771a4982d9975a8cbf64f00d4a1ececb53297f1d9a7be1b10/importlib_metadata-8.7.1.tar.gz"
    sha256 "49fef1ae6440c182052f407c8d34a68f72efc36db9ca90dc0113398f2fdde8bb"
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
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/b7/e8/0598f0e8b4af37cd9b10d8b87386cf3173cb8045d834ab5f6ec347a758b3/kubernetes-32.0.1.tar.gz"
    sha256 "42f43d49abd437ada79a79a16bd48a604d3471a117a8347e87db693f2ba0ba28"
  end

  resource "lz4" do
    url "https://files.pythonhosted.org/packages/57/51/f1b86d93029f418033dddf9b9f79c8d2641e7454080478ee2aab5123173e/lz4-4.4.5.tar.gz"
    sha256 "5f0b9e53c1e82e88c10d7c180069363980136b9d7a8306c4dca4f760d60c39f0"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/8d/37/02347f6d6d8279247a5837082ebc26fc0d5aaeaf75aa013fcbb433c777ab/markdown-3.9.tar.gz"
    sha256 "d2900fe1782bd33bdbbd56859defef70c2e78fc46668f8eb9df3128138f2cb6a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
    url "https://files.pythonhosted.org/packages/cf/0e/c857c46d653e104019a84f22d4494f2119b4fe9f896c92b4b864b3b045cc/msal-1.34.0.tar.gz"
    sha256 "76ba83b716ea5a6d75b0279c0ac353a0e05b820ca1f6682c0eb7f45190c43c2f"
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
    url "https://files.pythonhosted.org/packages/7b/3b/e0129b84e981004d5305418119a8c54ad7e75df27215028895716960e09b/msgraph_sdk-1.23.0.tar.gz"
    sha256 "6dd1ba9a46f5f0ce8599fd9610133adbd9d1493941438b5d3632fce9e55ed607"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/47/6d/b57c64e5038a8cf071bce391bb11551657a74558877ac961e7fa905ece27/narwhals-2.15.0.tar.gz"
    sha256 "a9585975b99d95084268445a1fdd881311fa26ef1caa18020d959d5b2ff9a965"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/83/f8/51569ac65d696c8ecbee95938f89d4abf00f47d58d48f6fbabfe8f0baefe/nest_asyncio-1.6.0.tar.gz"
    sha256 "6f172d5449aca15afd6c646851f4e31e02c598d553a667e38cafa997cfec55fe"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/a9/75/10dd1f8116a8b796cb2c737b674e02d02e80454bda953fa7e65d8c12b016/numpy-2.0.2.tar.gz"
    sha256 "883c987dee1880e2a864ab0dc9892292582510604156762362d9326444636e78"

    # Backport fix until prowler uses numpy >= 2.1.2
    patch do
      url "https://github.com/numpy/numpy/commit/5e314c7378b4d1b10aead7f854003f7318d5cb8e.patch?full_index=1"
      sha256 "13371cbe50aded5b0d4ac21a2cb6ce39b2b136b870cc7a55199f5fb2f4189e38"
    end
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/7f/51/3b400abbfe14a91187d80e95f10bc76c8260248b4e4a7b48aa380c2b3ed2/oci-2.160.3.tar.gz"
    sha256 "57514889be3b713a8385d86e3ba8a33cf46e3563c2a7e29a93027fb30b8a2537"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/97/b9/3161be15bb8e3ad01be8be5a968a9237c3027c5be504362ff800fca3e442/opentelemetry_api-1.39.1.tar.gz"
    sha256 "fbde8c80e1b937a2c61f20347e91c0c18a1940cecf012d62e65a7caf08967c9c"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/eb/fb/c76080c9ba07e1e8235d24cdcc4d125ef7aa3edf23eb4e497c2e50889adc/opentelemetry_sdk-1.39.1.tar.gz"
    sha256 "cf4d4563caf7bff906c9f7967e2be22d0d6b349b908be0d90fb21c8e9c995cc6"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/91/df/553f93ed38bf22f4b999d9be9c185adb558982214f33eae539d3b5cd0858/opentelemetry_semantic_conventions-0.60b1.tar.gz"
    sha256 "87c228b5a0669b748c76d76df6c364c369c28f1c465e50f661e39737e84bc953"
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
    url "https://files.pythonhosted.org/packages/e3/4f/8a10a9b9f5192cb6fdef62f1d77fa7d834190b2c50c0cd256bd62879212b/plotly-6.5.2.tar.gz"
    sha256 "7478555be0198562d1435dee4c308268187553cc15516a2f4dd034453699e393"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/01/89/9cbe2f4bba860e149108b683bc2efec21f14d5f7ed6e25562ad86acbc373/proto_plus-1.27.0.tar.gz"
    sha256 "873af56dd0d7e91836aee871e5799e1c6f1bda86ac9a983e0bb9f0c266a568c4"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/53/b8/cda15d9d46d03d4aa3a67cb6bffe05173440ccf86a9541afaf7ac59a1b6b/protobuf-6.33.4.tar.gz"
    sha256 "dc2e61bca3b10470c1912d166fe0af67bfc20eb55971dcef8dfa48ce14f0ed91"
  end

  resource "py-iam-expand" do
    url "https://files.pythonhosted.org/packages/22/99/8d31a30b37825577275bb3663885b55075fba80257fcd6813b85d3aaffa8/py_iam_expand-0.1.0.tar.gz"
    sha256 "5a2884dc267ac59a02c3a80fefc0b34c309dac681baa0f87c436067c6cf53a96"
  end

  resource "py-ocsf-models" do
    url "https://files.pythonhosted.org/packages/b1/25/820201e0fe87dc13f6a039f2c76ddbe453372a9f39a052db08f05b37c6f7/py_ocsf_models-0.5.0.tar.gz"
    sha256 "bf05e955809d1ec3ab1007e4a4b2a8a0afa74b6e744ea8ffbf386e46b3af0a76"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/fe/b6/6e630dff89739fcd427e3f72b3d905ce0acb85a45d4ec3e2678718a3487f/pyasn1-0.6.2.tar.gz"
    sha256 "9b59a2b25ba7e4f8197db7686c09fb33e658b98339fadb826e9512629017833b"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
    sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/69/44/36f1a6e523abc58ae5f928898e4aca2e0ea509b5aa6f6f392a5d882be928/pydantic-2.12.5.tar.gz"
    sha256 "4d351024c75c0f085a9febbb665ce8c0c6ec5d30e903bdb6394b7ede26aebb49"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/71/70/23b021c950c2addd24ec408e9ab05d59b035b39d97cdc1130e1bce647bb6/pydantic_core-2.41.5.tar.gz"
    sha256 "08daa51ea16ad373ffd5e7606252cc32f07bc72b28284b6bc9c6df804816476e"
  end

  resource "pygithub" do
    url "https://files.pythonhosted.org/packages/16/ce/aa91d30040d9552c274e7ea8bd10a977600d508d579a4bb262b95eccf961/pygithub-2.5.0.tar.gz"
    sha256 "e1613ac508a9be710920d26eb18b1905ebd9926aa49398e88151c1b526aad3cf"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/c1/d4/1067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085/pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/33/c1/1d9de9aeaa1b89b0186e5fe23294ff6517fce1bc69149185577cd31016b2/pyparsing-3.3.1.tar.gz"
    sha256 "47fad0f17ac1e2cad3de3b458570fbc9b03560aa029ed5e16ee5554da9a2251c"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/c8/5a/b17e1e257d3e6f2e7758930e1256832c9ddd576f8631781e6a072914befa/retrying-1.4.2.tar.gz"
    sha256 "d102e75d53d8d30b88562d45361d6c6c934da06fab31bd81c0420acb97a8ba39"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/20/af/3f2f423103f1113b36230496629986e0ef7e199d2aa8392452b484b38ced/rpds_py-0.30.0.tar.gz"
    sha256 "dd8ff7cf90014af0c0f787eea34794ebf6415242ee1d6fa91eaba725cc441e84"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/6d/05/d52bf1e65044b4e5e27d4e63e8d1579dbdec54fce685908ae09bc3720030/s3transfer-0.13.1.tar.gz"
    sha256 "c3fdba22ba1bd367922f27ec8032d6a1cf5f10c934fb5d68cf60fd5a23d936cf"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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

  resource "std-uritemplate" do
    url "https://files.pythonhosted.org/packages/93/62/61866776cd32df3f984ff2f79b1428e10700e0a33ca7a7536e3fcba3cf2a/std_uritemplate-2.0.8.tar.gz"
    sha256 "138ceff2c5bfef18a650372a5e8c82fe7f780c87235513de6c342fb5f7e18347"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/65/7b/644fbbb49564a6cb124a8582013315a41148dba2f72209bba14a84242bf0/tldextract-5.3.1.tar.gz"
    sha256 "a72756ca170b2510315076383ea2993478f7da6f897eef1f4a5400735d5057fb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/5a/70/1469ef1d3542ae7c2c7b72bd5e3a4e6ee69d7978fa8a3af05a38eca5becf/werkzeug-3.1.5.tar.gz"
    sha256 "6a548b0e88955dd07ccb25539d7d0cc97417ee9e179677d22c7041c8f078ce67"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/2a/6de8a50cb435b7f42c46126cf1a54b2aab81784e74c8595c8e025e8f36d3/wrapt-2.0.1.tar.gz"
    sha256 "9c9c635e78497cacb81e84f8b11b23e0aacac7a136e73b8e5b2109a1d9fc468f"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/46/2c/c06ef49dc36e7954e55b802a8b231770d286a9758b3d936bd1e04ce5ba88/xlsxwriter-3.2.9.tar.gz"
    sha256 "254b1c37a368c444eac6e2f867405cc9e461b0ed97a3233b2ac1e574efb4140c"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  resource "zstd" do
    url "https://files.pythonhosted.org/packages/49/62/b9c075ad664e7c4cbb3d8d2be7c246506abe1bc7f778eb58d260ef9538c8/zstd-1.5.7.3.tar.gz"
    sha256 "403e5205f4ac04b92e6b0cda654be2f51de268228a0db0067bc087faacf2f495"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "Unable to locate credentials", shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)
    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end
