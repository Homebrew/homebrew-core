class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/59/08/854aedf7c5892fdc9d21886a8943463241828c33322ef39adf547d337d32/dstack-0.20.13.tar.gz"
  sha256 "b5da5e206955fedd713518f5d1a3e3b73032bf4f7d3a671410f6a26116dc64e2"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e1fd1b150e56f1d8b90de7c6879751e7dc84227553082ac8d4660a289c1baa3f"
    sha256 cellar: :any,                 arm64_sequoia: "7412f4224f298af401582005b8541c5ff362c342f34f77479bd11ad73b2cec1b"
    sha256 cellar: :any,                 arm64_sonoma:  "4abf2258d185f8eb2cfb324ce7c70e658fe09975dbd52c2ac5e5135e68846eeb"
    sha256 cellar: :any,                 sonoma:        "21c1d9789dc35061e39c0de648cbbb161cff029a08435db580b27bd29fdcb209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f0d1102429b6c3d3a753c098223a0929473626945e84f0c41c7833cd47e9919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb09385d3cea0f0fa23f8b87aff1c10488298e9255e1acbd858c94f2d8e56e06"
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
    url "https://files.pythonhosted.org/packages/6b/65/316cdc82c1b92953235ced1c71a3763f0cd9273c3bec5db60bdb5ad59bfe/aiorwlock-1.5.1.tar.gz"
    sha256 "2729c77ec736c8d85ec305aa3827a50394fd8c6d823f4404d301cc8c59a4b7f5"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/94/13/8b084e0f2efb0275a1d534838844926f798bd766566b1375174e2448cd31/alembic-1.18.4.tar.gz"
    sha256 "cb6e1fd84b6174ab8dbb2329f86d631ba9559dd78df550b57804d607672cedbc"
  end

  resource "alembic-postgresql-enum" do
    url "https://files.pythonhosted.org/packages/63/cf/b5147b926441e7cdc12f306465dac488ff22364b1467a09a5d43743b8cfc/alembic_postgresql_enum-1.10.0.tar.gz"
    sha256 "ea23481de3d6a00d68d369f92a46ff4fa27b2575e39c583145f1e23ea9c7511d"
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
    url "https://files.pythonhosted.org/packages/c8/29/9641b73248745774a52c7ce7f965ed1febbdea787ec21caad3ae6891d18a/azure_core-1.38.3.tar.gz"
    sha256 "a7931fd445cb4af8802c6f39c6a326bbd1e34b115846550a8245fa656ead6f8e"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/e2/e3/c887e27260754014dc63fc33bf612f1c7f1751f74e80d1aaa32491af3ffa/azure_mgmt_compute-37.2.0.tar.gz"
    sha256 "23499d4d5ad2b2bf40a4c59df2684cc4c9cef0f9672a4e842bb9a1cf6b62f628"
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
    url "https://files.pythonhosted.org/packages/d7/7e/b3f9d544a94782be9c5ab8123d2fa7fb20cbdf3f5a16b883f308865e1406/azure_mgmt_resource-25.0.0.tar.gz"
    sha256 "dc123a9f6509c37299d7716c9090cff0a9d73309b228cc094ea950ce3cca3603"
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
    url "https://files.pythonhosted.org/packages/04/7c/d7a533916d1afc9e17f8594203a85799d42f7c5751464fbdb25ead8db9d2/boto3-1.42.70.tar.gz"
    sha256 "d060b0d83d2832e403671b9a895e73c3b025df8bb5896d89e401b0678705aac4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/66/54/b80e1fcee4f732e0e9314bbb8679be9d5690caa1566c4a4cd14e9724d2dd/botocore-1.42.70.tar.gz"
    sha256 "9ee17553b7febd1a0c1253b3b62ab5d79607eb6163c8fb943470a8893c31d4fa"
  end

  resource "cached-classproperty" do
    url "https://files.pythonhosted.org/packages/ea/63/fbc7b92eb9514c399d24f31b93d036fd5475961ca57d3945a03c25a77e4e/cached_classproperty-1.1.0.tar.gz"
    sha256 "f012b314d6a797270ebab9df1b1869596d7bf12ec37d7e60d03976224bfbcefd"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/af/dd/57fe3fdb6e65b25a5987fd2cdc7e22db0aef508b91634d2e57d22928d41b/cachetools-7.0.5.tar.gz"
    sha256 "0cd042c24377200c1dcd225f8b7b12b0ca53cc2c961b43757e774ebe190fd990"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
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
    url "https://files.pythonhosted.org/packages/94/b8/00651a0f559862f3bb7d6f7477b192afe3f583cc5e26403b44e59a55ab34/filelock-3.25.2.tar.gz"
    sha256 "b64ece2b38f4ca29dd3e810287aa8c48182bbecd1ae6e9ae126c9b35f1382694"
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
    url "https://files.pythonhosted.org/packages/22/98/586ec94553b569080caef635f98a3723db36a38eac0e3d7eb3ea9d2e4b9a/google_api_core-2.30.0.tar.gz"
    sha256 "02edfa9fab31e17fc0befb5f161b3bf93c9096d99aed584625f38065c511ad9b"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/90/f4/e14b6815d3b1885328dd209676a3a4c704882743ac94e18ef0093894f5c8/google_api_python_client-2.193.0.tar.gz"
    sha256 "8f88d16e89d11341e0a8b199cafde0fb7e6b44260dffb88d451577cbd1bb5d33"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/ea/80/6a696a07d3d3b0a92488933532f03dbefa4a24ab80fb231395b9a2a1be77/google_auth-2.49.1.tar.gz"
    sha256 "16d40da1c3c5a0533f57d268fe72e0ebb0ae1cc3b567024122651c045d879b64"
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
    url "https://files.pythonhosted.org/packages/1b/3d/3511c167269ca7871de1b5438088749a46d5d60f65d22bef0dd4403e2301/google_cloud_compute-1.46.0.tar.gz"
    sha256 "8b0f8d5a1115e8beae5fafdc7050f1ad15e922a5cdf6c634e5a745e47cb49281"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/a6/03/ef0bc99d0e0faf4fdbe67ac445e18cdaa74824fd93cd069e7bb6548cb52d/google_cloud_core-2.5.0.tar.gz"
    sha256 "7c1b7ef5c92311717bd05301aa1a91ffbc565673d3b0b4163a52d8413a186963"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/9d/ce/0d3539008dc33b436e7c5c644abc8f8a7ec5900911d14a8e34e145f0ebe5/google_cloud_logging-3.14.0.tar.gz"
    sha256 "361e83cd692fecc7da10351f641c474591f586f234fc49394db4ba5c8c5994a7"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/f7/b1/4f0798e88285b50dfc60ed3a7de071def538b358db2da468c2e0deecbb40/google_cloud_storage-3.9.0.tar.gz"
    sha256 "f2d8ca7db2f652be757e92573b2196e10fbc09649b5c016f8b422ad593c641cc"
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
    url "https://files.pythonhosted.org/packages/99/96/a0205167fa0154f4a542fd6925bdc63d039d88dab3588b875078107e6f06/googleapis_common_protos-1.73.0.tar.gz"
    sha256 "778d07cd4fbeff84c6f7c72102f0daf98fa2bfd3fa8bea426edc545588da0b5a"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/0e/f8/d3d8ac15ea7aa2c5dfbbf6151104bfa5d9fe21bfc106f819b1665196f817/gpuhunt-0.1.19.tar.gz"
    sha256 "7db86fa1a98c918e9b346ac7e1cb468e291419384318334a0782ae7a2874a199"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/a3/51/1664f6b78fc6ebbd98019a1fd730e83fa78f2db7058f72b1463d3612b8db/greenlet-3.3.2.tar.gz"
    sha256 "2eaf067fc6d886931c7962e8c6bede15d2f01965560f3359b27c80bde2d151f2"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/76/1e/1011451679a983f2f5c6771a1682542ecb027776762ad031fd0d7129164b/grpc_google_iam_v1-0.14.3.tar.gz"
    sha256 "879ac4ef33136c5491a6300e27575a9ec760f6cdf9a2518798c1b8977a5dc389"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/06/8a/3d098f35c143a89520e568e6539cc098fcd294495910e359889ce8741c84/grpcio-1.78.0.tar.gz"
    sha256 "7382b95189546f375c174f53a5fa873cef91c4b8005faa05cc5b3beea9c4f1c5"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/8a/cd/89ce482a931b543b92cdd9b2888805518c4620e0094409acb8c81dd4610a/grpcio_status-1.78.0.tar.gz"
    sha256 "a34cfd28101bfea84b5aa0f936b4b423019e9213882907166af6b3bddc59e189"
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
    url "https://files.pythonhosted.org/packages/c1/1f/e86365613582c027dda5ddb64e1010e57a3d53e99ab8a72093fa13d565ec/httplib2-0.31.2.tar.gz"
    sha256 "385e0869d7397484f4eab426197a4c020b606edd43372492337c0b4010ae5d24"
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
    url "https://files.pythonhosted.org/packages/f4/4a/37928a560a345c6efb207452cf81d3c14f25a6d83df0fa5a00752c0c912b/ignore_python-0.3.3.tar.gz"
    sha256 "dc80ac80ace112da6d02f44681b6beb2ccecb68d6ac2b5e1b82d7f84347e1cf6"
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
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
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
    url "https://files.pythonhosted.org/packages/3c/aa/5a646093ac218e4a329391d5a31e5092a89db7d2ef1637a90b82cd0b6f94/msal-1.35.1.tar.gz"
    sha256 "70cac18ab80a053bff86219ba64cfe3da1f307c74b009e2da57ef040eb1b5656"
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
    url "https://files.pythonhosted.org/packages/2c/1d/4049a9e8698361cc1a1aa03a6c59e4fa4c71e0c0f94a30f988a6876a2ae6/opentelemetry_api-1.40.0.tar.gz"
    sha256 "159be641c0b04d11e9ecd576906462773eb97ae1b657730f0ecf64d32071569f"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/53/45/b268004f745ede84e5798b48ee12b05129d19235d0e15267aa57dcdb400b/orjson-3.11.7.tar.gz"
    sha256 "9b1a67243945819ce55d24a30b59d6a168e86220452d2c96f4d1f093e71c0c49"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/f0/58/a794d23feb6b00fc0c72787d7e87d872a6730dd9ed7c7b3e954637d8f280/prometheus_client-0.24.1.tar.gz"
    sha256 "7e0ced7fbbd40f7b84962d5d2ab6f17ef88a72504dcf7c0b40737b43b2a461f9"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/3a/02/8832cde80e7380c600fbf55090b6ab7b62bd6825dbedde6d6657c15a1f8e/proto_plus-1.27.1.tar.gz"
    sha256 "912a7460446625b792f6448bade9e55cd4e41e6ac10e27009ef71a7f317fa147"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/ba/25/7c72c307aafc96fa87062aa6291d9f7c94836e43214d43722e86037aac02/protobuf-6.33.5.tar.gz"
    sha256 "6ddcac2a081f8b7b9642c09406bc6a4290128fce5f471cddd165960bb9119e5c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
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
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
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
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
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
    url "https://files.pythonhosted.org/packages/94/01/979e98d542a70714b0cb2b6728ed0b7c46792b695e3eaec3e20711271ca3/python_multipart-0.0.22.tar.gz"
    sha256 "7340bef99a7e0032613f56dc36027b959fd3b30a787ed62d310e951f7c3a3a58"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
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
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/4c/f7/1c65e0245d4c7009a87ac92908294a66e7e7635eccf76a68550f40c6df80/rich_argparse-1.7.2.tar.gz"
    sha256 "64fd2e948fc96e8a1a06e0e72c111c2ce7f3af74126d75c0f5f63926e7289cd1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/e9/b8/285293dc60fc198fffc3fcdbc7c6d4e646e0f74e61461c355d40faa64ceb/sentry_sdk-2.55.0.tar.gz"
    sha256 "3774c4d8820720ca4101548131b9c162f4c9426eb7f4d24aca453012a7470f69"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/1f/73/b4a9737255583b5fa858e0bb8e116eb94b88c910164ed2ed719147bde3de/sqlalchemy-2.0.48.tar.gz"
    sha256 "5ca74f37f3369b45e1f6b7b06afb182af1fd5dde009e4ffd831830d98cbe5fe7"
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
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
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
    url "https://files.pythonhosted.org/packages/e3/ad/4a96c425be6fb67e0621e62d86c402b4a17ab2be7f7c055d9bd2f638b9e2/uvicorn-0.42.0.tar.gz"
    sha256 "9b1f190ce15a2dd22e7758651d9b6d12df09a13d51ba5bf4fc33c383a48e1775"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c2/c9/8869df9b2a2d6c59d79220a4db37679e74f807c559ffe5265e08b227a210/watchfiles-1.1.1.tar.gz"
    sha256 "a173cb5c16c4f40ab19cecf48a534c409f7ea983ab8fed0741304a1c0a31b3f2"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
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
