class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/55/b5/19e0d916a1e2294148b1cb617e9530821092c4e67d3c3d35edce931524be/dstack-0.20.4.tar.gz"
  sha256 "3d5b95de0feec41038b9625e4280a60792d91bbd99edd67891c5833002e73d1b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3cfb523162759066df26aa91299659c73568dc7bb64caaef696357d529d652e"
    sha256 cellar: :any,                 arm64_sequoia: "53838eef0a757cfdd265b2dec0fa29de6c088f50bdc973976efee905e4c6007e"
    sha256 cellar: :any,                 arm64_sonoma:  "db8cdd5846d49aaf0b9ac2ffc5b09d6ecf46150a25d41c3e9549d1477813d16b"
    sha256 cellar: :any,                 sonoma:        "96274dea5dd244522aa27075f75feea45181e578aab9aba6133e8eb2bfc0ddb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "702ef0572d2d49648e0b82800dfc3bed79751d234c40903fea25a2b44a7f2db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dccbc40586fa226926a5aa6b0a9b03393f05410134f8fd024355f5b2db5b475"
  end

  # `pkgconf` and `rust` are for bcrypt.
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.13" # Pydantic v1 is incompatible with Python 3.14, upstream issue, https://github.com/dstackai/dstack/issues/1844
  depends_on "rpds-py" => :no_linkage

  pypi_packages package_name:     "dstack[aws,azure,gcp,lambda]",
                exclude_packages: ["certifi", "cryptography", "rpds-py"]

  resource "aiocache" do
    url "https://files.pythonhosted.org/packages/7a/64/b945b8025a9d1e6e2138845f4022165d3b337f55f50984fbc6a4c0a1e355/aiocache-0.12.3.tar.gz"
    sha256 "f528b27bf4d436b497a1d0d1a8f59a542c153ab1e37c3621713cb376d44c4713"
  end

  resource "aiorwlock" do
    url "https://files.pythonhosted.org/packages/c5/bf/d1ddcd676be027a963b3b01fdf9915daf4590b4dfd03bf1c8c2858aac7e3/aiorwlock-1.5.0.tar.gz"
    sha256 "b529da24da659bdedcf68faf216595bde00db228c905197ac554773620e7fd2f"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/49/cc/aca263693b2ece99fa99a09b6d092acb89973eb2bb575faef1777e04f8b4/alembic-1.18.1.tar.gz"
    sha256 "83ac6b81359596816fb3b893099841a0862f2117b2963258e965d70dc62fb866"
  end

  resource "alembic-postgresql-enum" do
    url "https://files.pythonhosted.org/packages/58/04/e465cb5c051fb056b7fadda7667b3e1fb4d32d7f19533e3bbff071c73788/alembic_postgresql_enum-1.8.0.tar.gz"
    sha256 "132cd5fdc4a2a0b6498f3d89ea1c7b2a5ddc3281ddd84edae7259ec4c0a215a0"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/07/12/3e4389e5920b4c1763390c6d371162f3784f86f85cd6d6c1bfe68eef14e2/apscheduler-3.11.2.tar.gz"
    sha256 "2a9966b052ec805f020c8c4c3ae6e6a06e24b1bf19f2e11d91d8cca0473eef41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "asyncpg" do
    url "https://files.pythonhosted.org/packages/fe/cc/d18065ce2380d80b1bcce927c24a2642efd38918e33fd724bc4bca904877/asyncpg-0.31.0.tar.gz"
    sha256 "c989386c83940bfbd787180f2b1519415e2d3d6277a70d9d0f0145ac73500735"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
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
    url "https://files.pythonhosted.org/packages/06/8d/1a6c41c28a37eab26dc85ab6c86992c700cd3f4a597d9ed174b0e9c69489/azure_identity-1.25.1.tar.gz"
    sha256 "87ca8328883de6036443e1c37b40e8dc8fb74898240f61071e09d2e369361456"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/d3/bc/6fa430dcf5b6b312d91669444edfe167e72eab03b216034c136ccaf19864/azure_mgmt_compute-37.1.0.tar.gz"
    sha256 "57aed44f84c2a53323e11c3731485dd7be99aee0dd1a74f5fa77df607943d34a"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/3e/99/fa9e7551313d8c7099c89ebf3b03cd31beb12e1b498d575aa19bb59a5d04/azure_mgmt_core-1.6.0.tar.gz"
    sha256 "b26232af857b021e61d813d9f4ae530465255cb10b3dde945ad3743f7a58e79c"
  end

  resource "azure-mgmt-msi" do
    url "https://files.pythonhosted.org/packages/f8/83/f2e8eeca619905ffc48205664ad10e7cdfc168be522a06d04bea54e41556/azure_mgmt_msi-7.1.0.tar.gz"
    sha256 "1a01a089f1f66cb0d4b2886603d5ba415f360eff0be6f685737ecdd59c78225b"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/bf/aa/bf464fd70eefa8f13f5e5b45d021416d5c9c8d79eabb96f4a673fe91346d/azure_mgmt_network-27.0.0.tar.gz"
    sha256 "5c1c61d8bb13ad40f788a26fd7569c1d9d60eb2e4cb19c2a1b5d9c02ae862316"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/50/4c/b27a3dfbedebbcc8e346a956a803528bd94a19fdf14b1de4bd781b03a6cc/azure_mgmt_resource-24.0.0.tar.gz"
    sha256 "cf6b8995fcdd407ac9ff1dd474087129429a1d90dbb1ac77f97c19b96237b265"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "backports-entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/fc/25/dae014b114397a6f60578d7358bf5fcb103f71556e5363a50d7b42e9bc51/backports.entry_points_selectable-1.3.0.tar.gz"
    sha256 "17a8b44ae700fba548686dd274ddc91c060371565cd63806c20a1d33911746e6"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a4/da/d81abc51bd35c2d2154f1caa0040843ada7df1689ea17d51c116c793b8f0/boto3-1.42.31.tar.gz"
    sha256 "b2038fc5dbcd6746a16ada8d55fe73659b8cf95c7b6aeb63fe782e831485edaa"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ab/78/4fd91ed2f9d4b500680f33c714b7716fc37690083a8c8d3e94177cbc811e/botocore-1.42.31.tar.gz"
    sha256 "62f2c31e229df625612dd4d7c72618948e4064436d71a647102f36fcddfa0f4d"
  end

  resource "cached-classproperty" do
    url "https://files.pythonhosted.org/packages/ea/63/fbc7b92eb9514c399d24f31b93d036fd5475961ca57d3945a03c25a77e4e/cached_classproperty-1.1.0.tar.gz"
    sha256 "f012b314d6a797270ebab9df1b1869596d7bf12ec37d7e60d03976224bfbcefd"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/bc/1d/ede8680603f6016887c062a2cf4fc8fdba905866a3ab8831aa8aa651320c/cachetools-6.2.4.tar.gz"
    sha256 "82c5c05585e70b6ba2d3ae09ea60b79548872185d2f24ae1f2709d37299fd607"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/17/71/2df15009fb4bdd522a069d2fbca6007c6c5487fce5cb965be00fc335f1d1/fastapi-0.125.0.tar.gz"
    sha256 "16b532691a33e2c5dee1dac32feb31dc6eb41a3dd4ff29a95f9487cb21c054c0"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1d/65/ce7f1b70157833bf3cb851b556a37d4547ceafc158aa9b34b36782f23696/filelock-3.20.3.tar.gz"
    sha256 "18c57ee915c7ec61cff0ecf7f0f869936c7c30191bb0cf406f1341778d0834e1"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/df/b5/59d16470a1f0dfe8c793f9ef56fd3826093fc52b3bd96d6b9d6c26c7e27b/gitpython-3.1.46.tar.gz"
    sha256 "400124c7d0ef4ea03f7310ac2fbf7151e09ff97f2a3288d64a440c584a29c37f"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/0d/10/05572d33273292bac49c2d1785925f7bc3ff2fe50e3044cf1062c1dde32e/google_api_core-2.29.0.tar.gz"
    sha256 "84181be0f8e6b04006df75ddfe728f24489f0af57c96a529ff7cf45bc28797f7"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/a8/d7/14613c7efbab5b428b400961f5dbac46ad9e019c44e1f3fd14d67c33111c/google_api_python_client-2.188.0.tar.gz"
    sha256 "5c469db6614f071009e3e5bb8b6aeeccae3beb3647fa9c6cd97f0d551edde0b6"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/60/3c/ec64b9a275ca22fa1cd3b6e77fefcf837b0732c890aa32d2bd21313d9b33/google_auth-2.47.0.tar.gz"
    sha256 "833229070a9dfee1a353ae9877dcd2dec069a8281a4e72e72f77d4a70ff945da"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/d5/ad/c1f2b1175096a8d04cf202ad5ea6065f108d26be6fc7215876bde4a7981d/google_auth_httplib2-0.3.0.tar.gz"
    sha256 "177898a0175252480d5ed916aeea183c2df87c1f9c26705d74ae6b951c268b0b"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/65/38/89317773c64b5a7e9b56b9aecb2e39ac02d8d6d09fb5b276710c6892e690/google_cloud_appengine_logging-1.8.0.tar.gz"
    sha256 "84b705a69e4109fc2f68dfe36ce3df6a34d5c3d989eee6d0ac1b024dda0ba6f5"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/c7/d2/ad96950410f8a05e921a6da2e1a6ba4aeca674bbb5dda8200c3c7296d7ad/google_cloud_audit_log-0.4.0.tar.gz"
    sha256 "8467d4dcca9f3e6160520c24d71592e49e874838f174762272ec10e7950b6feb"
  end

  resource "google-cloud-billing" do
    url "https://files.pythonhosted.org/packages/04/b6/a75a0bce72b9064a8e7ef011aadebc7ae9a0d9bf378f9f815d020de02c9d/google_cloud_billing-1.18.0.tar.gz"
    sha256 "20682047285e9dadb31eaa824f86defbdd600bcf837d7195187b9044dd27b1f9"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/12/66/7cf77a3fe251974a2cab4dbfdcbe2f52cb6615afe5f685a4f4886d798e1b/google_cloud_compute-1.42.0.tar.gz"
    sha256 "08b1dbc5758baa5491087bcefb574e59d911520b714eda79b4ebf1cb429d8d98"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/a6/03/ef0bc99d0e0faf4fdbe67ac445e18cdaa74824fd93cd069e7bb6548cb52d/google_cloud_core-2.5.0.tar.gz"
    sha256 "7c1b7ef5c92311717bd05301aa1a91ffbc565673d3b0b4163a52d8413a186963"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/7f/47/31ef0261802fe8b37c221392e1d6ff01d30b03dce5e20e77fc7d57ddf8a3/google_cloud_logging-3.13.0.tar.gz"
    sha256 "3aae0573b1a1a4f59ecdf4571f4e7881b5823bd129fe469561c1c49a7fa8a4c1"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/a8/90/4398cecc2704cb066bc7dee6111a5c93c59bcd6fb751f0541315655774a8/google_cloud_storage-3.8.0.tar.gz"
    sha256 "cc67952dce84ebc9d44970e24647a58260630b7b64d72360cedaf422d6727f28"
  end

  resource "google-cloud-tpu" do
    url "https://files.pythonhosted.org/packages/30/95/df27840b4607307c997baa08abc64eb97c522af7e6e7d126b2b320a13eb7/google_cloud_tpu-1.25.0.tar.gz"
    sha256 "00e8114b05f7f9afcc17949e54c0ab788ea3b8df4048880eb59bd99e29fb6c2b"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/03/41/4b9c02f99e4c5fb477122cd5437403b552873f014616ac1d19ac8221a58d/google_crc32c-1.8.0.tar.gz"
    sha256 "a428e25fb7691024de47fecfbff7ff957214da51eddded0da0ae0e0f03a2cf79"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/64/d7/520b62a35b23038ff005e334dba3ffc75fcf583bee26723f1fd8fd4b6919/google_resumable_media-2.8.0.tar.gz"
    sha256 "f1157ed8b46994d60a1bc432544db62352043113684d4e030ee02e77ebe9a1ae"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/a2/a0/a096fd7cbd75a49ce606fe6c02ffdb2f60e7fc133be232c32e89e861eedd/gpuhunt-0.1.16.tar.gz"
    sha256 "0b5cfe20cd5540aa1c72535d3cd9ef6c535267c9003ea6a2a38b17cb4eef79c9"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/c7/e5/40dbda2736893e3e53d25838e0f19a2b417dfc122b9989c91918db30b5d3/greenlet-3.3.0.tar.gz"
    sha256 "a82bb225a4e9e4d653dd2fb7b8b2d36e4fb25bc0165422a11e48b88e9e6f78fb"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/76/1e/1011451679a983f2f5c6771a1682542ecb027776762ad031fd0d7129164b/grpc_google_iam_v1-0.14.3.tar.gz"
    sha256 "879ac4ef33136c5491a6300e27575a9ec760f6cdf9a2518798c1b8977a5dc389"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/b6/e0/318c1ce3ae5a17894d5791e87aea147587c9e702f24122cc7a5c8bbaeeb1/grpcio-1.76.0.tar.gz"
    sha256 "7be78388d6da1a25c0d5ec506523db58b18be22d9c37d8d3a32c08be4987bd73"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/3f/46/e9f19d5be65e8423f886813a2a9d0056ba94757b0c5007aa59aed1a961fa/grpcio_status-1.76.0.tar.gz"
    sha256 "25fcbfec74c15d1a1cb5da3fab8ee9672852dc16a5a9eeb5baf7d7a9952943cd"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/77/df/6eb1d485a513776bbdbb1c919b72e59b5acc51c5e7ef28ad1cd444e252a3/httplib2-0.31.1.tar.gz"
    sha256 "21591655ac54953624c6ab8d587c71675e379e31e2cfe3147c83c11e9ef41f92"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/b5/46/120a669232c7bdedb9d52d4aeae7e6c7dfe151e99dc70802e2fc7a5e1993/httptools-0.7.1.tar.gz"
    sha256 "abd72556974f8e7c74a259655924a717a2365b236c882c3f6f8a45fe94703ac9"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/5a/c1/39cfd73def936e6c9c06ae6227b314c90f7a57d725cf1cd15e3f576906c6/ignore_python-0.3.1.tar.gz"
    sha256 "a9c691ca0f5002391fc10c7d8c29859d38594b4751a5eb43f95b5a9f7bda30bc"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f3/49/3b30cad09e7771a4982d9975a8cbf64f00d4a1ececb53297f1d9a7be1b10/importlib_metadata-8.7.1.tar.gz"
    sha256 "49fef1ae6440c182052f407c8d34a68f72efc36db9ca90dc0113398f2fdde8bb"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
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
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/cf/0e/c857c46d653e104019a84f22d4494f2119b4fe9f896c92b4b864b3b045cc/msal-1.34.0.tar.gz"
    sha256 "76ba83b716ea5a6d75b0279c0ac353a0e05b820ca1f6682c0eb7f45190c43c2f"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/97/b9/3161be15bb8e3ad01be8be5a968a9237c3027c5be504362ff800fca3e442/opentelemetry_api-1.39.1.tar.gz"
    sha256 "fbde8c80e1b937a2c61f20347e91c0c18a1940cecf012d62e65a7caf08967c9c"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/04/b8/333fdb27840f3bf04022d21b654a35f58e15407183aeb16f3b41aa053446/orjson-3.11.5.tar.gz"
    sha256 "82393ab47b4fe44ffd0a7659fa9cfaacc717eb617c93cde83795f14af5c2e9d5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/f0/58/a794d23feb6b00fc0c72787d7e87d872a6730dd9ed7c7b3e954637d8f280/prometheus_client-0.24.1.tar.gz"
    sha256 "7e0ced7fbbd40f7b84962d5d2ab6f17ef88a72504dcf7c0b40737b43b2a461f9"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/01/89/9cbe2f4bba860e149108b683bc2efec21f14d5f7ed6e25562ad86acbc373/proto_plus-1.27.0.tar.gz"
    sha256 "873af56dd0d7e91836aee871e5799e1c6f1bda86ac9a983e0bb9f0c266a568c4"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/53/b8/cda15d9d46d03d4aa3a67cb6bffe05173440ccf86a9541afaf7ac59a1b6b/protobuf-6.33.4.tar.gz"
    sha256 "dc2e61bca3b10470c1912d166fe0af67bfc20eb55971dcef8dfa48ce14f0ed91"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/fe/b6/6e630dff89739fcd427e3f72b3d905ce0acb85a45d4ec3e2678718a3487f/pyasn1-0.6.2.tar.gz"
    sha256 "9b59a2b25ba7e4f8197db7686c09fb33e658b98339fadb826e9512629017833b"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/7b/da/fd89f987a376c807cd81ea0eff4589aade783bbb702637b4734ef2c743a2/pydantic-1.10.26.tar.gz"
    sha256 "8c6aa39b494c5af092e690127c283d84f363ac36017106a9e66cb33a22ac412e"
  end

  resource "pydantic-duality" do
    url "https://files.pythonhosted.org/packages/9e/64/da9e9525f68803d75dca8b693097c666e53f2268cddaa51d6ec2335fe331/pydantic_duality-1.2.4.tar.gz"
    sha256 "34bdbf102c004f009619c2b6682143fa6f14c04bf947f0ba72d75b04e84a65c7"
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
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "python-dxf" do
    url "https://files.pythonhosted.org/packages/ed/55/4b4fd31f5e5f7dc559a36c75e98b37670d6ddbd2b6b259e3a2bc8694cc2f/python_dxf-12.1.1.tar.gz"
    sha256 "2f5fd883599f8553872e1f7a67b8d278744ab574f55feb9790c93a347520dd9d"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/29/bf/eca6a3d43db1dae7070f70e160ab20b807627ba953663ba07928cdd3dc58/python_json_logger-4.0.0.tar.gz"
    sha256 "f58e68eb46e1faed27e0f574a55a0455eecd7b8a5b88b85a784519ba3cff047f"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/78/96/804520d0850c7db98e5ccb70282e29208723f0964e88ffd9d0da2f52ea09/python_multipart-0.0.21.tar.gz"
    sha256 "7137ebd4d3bbf70ea1622998f902b97a29434a9e8dc40eb203bbcf7c2a2cba92"
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

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/4c/f7/1c65e0245d4c7009a87ac92908294a66e7e7635eccf76a68550f40c6df80/rich_argparse-1.7.2.tar.gz"
    sha256 "64fd2e948fc96e8a1a06e0e72c111c2ce7f3af74126d75c0f5f63926e7289cd1"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/15/8a/3c4f53d32c21012e9870913544e56bfa9e931aede080779a0f177513f534/sentry_sdk-2.50.0.tar.gz"
    sha256 "873437a989ee1b8b25579847bae8384515bf18cfed231b06c591b735c1781fe3"
  end

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/d8/80/f0f10b4045628645a841d3d98b584a8699005ee03a211fc7c45f6c6f0e99/simple_term_menu-1.6.6.tar.gz"
    sha256 "9813d36f5749d62d200a5599b1ec88469c71378312adc084c00c00bfbb383893"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/be/f9/5e4491e5ccf42f5d9cfc663741d261b3e6e1683ae7812114e7636409fcc6/sqlalchemy-2.0.45.tar.gz"
    sha256 "1632a4bda8d2d25703fdad6363058d882541bdaaee0e5e3ddfa0cd3229efce88"
  end

  resource "sqlalchemy-utils" do
    url "https://files.pythonhosted.org/packages/0f/7d/eb9565b6a49426552a5bf5c57e7c239c506dc0e4e5315aec6d1e8241dc7c/sqlalchemy_utils-0.42.1.tar.gz"
    sha256 "881f9cd9e5044dc8f827bccb0425ce2e55490ce44fc0bb848c55cc8ee44cc02e"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/ba/b8/73a0e6a6e079a9d9cfa64113d771e421640b6f679a52eeb9b32f72d871a1/starlette-0.50.0.tar.gz"
    sha256 "a2a17b22203254bcbc2e1f926d2d55f3f9497f769416b3190768befe598fa3ca"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
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

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c3/d1/8f3c683c9561a4e6689dd3b1d345c815f10f86acd044ee1fb9a4dcd0b8c5/uvicorn-0.40.0.tar.gz"
    sha256 "839676675e87e73694518b5574fd0f24c9d97b46bea16df7b8c05ea1a51071ea"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c2/c9/8869df9b2a2d6c59d79220a4db37679e74f807c559ffe5265e08b227a210/watchfiles-1.1.1.tar.gz"
    sha256 "a173cb5c16c4f40ab19cecf48a534c409f7ea983ab8fed0741304a1c0a31b3f2"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  resource "www-authenticate" do
    url "https://files.pythonhosted.org/packages/a7/2d/5567291a8274ef5d9b6495a1ec341394ab68933e2396936755b157f87b43/www-authenticate-0.9.2.tar.gz"
    sha256 "cf75fc2ea5effb0f9342d7de7619b736f2a7d4b223331a53e296863a286e9dcb"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dstack", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dstack --version")
    expected = "Git repo not found:"
    assert_match expected, shell_output("#{bin}/dstack init 2>&1", 1)
  end
end
