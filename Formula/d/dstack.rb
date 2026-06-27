class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/10/a2/d8eb5a64439b3932a223f6c8902ee4470a90566f4bd5706bc436aaab865b/dstack-0.20.26.tar.gz"
  sha256 "71de5ae64f82e04e0b8dabea6f786f97335cb4d2abdf9033ae68e0313b04e1f9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6589ea61c038cc30a9155fa55eb1c57d112299dd49a30bdbfd79794b7aff3ef"
    sha256 cellar: :any, arm64_sequoia: "17f63de7bcef3c4d06b5eff2851dda171bf0f88b4f4512b099ff70ba32cdc20b"
    sha256 cellar: :any, arm64_sonoma:  "9bb0c9f9f38b7a8e019f6d4a221010df3e903ad266ea4f96c640a7c7eaafb46e"
    sha256 cellar: :any, sonoma:        "cb28f3846e87ad310105c7016c2fa59fd5f54b6d03eacb0405ba7a63b96a0aa4"
    sha256 cellar: :any, arm64_linux:   "a0a701c41a79b986315eaff2e1ce1724c804e7f587f59826ef85da4a63029c40"
    sha256 cellar: :any, x86_64_linux:  "5854a3de54f311773f669f250eec8d5e2bc26ce78744310c5ee062caa00f5fea"
  end

  # `pkgconf` and `rust` are for bcrypt
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
    url "https://files.pythonhosted.org/packages/1a/cc/ac0bed8e562e7407fe55c3ba85a4dce86e6dbd8730887bd1e406a6c5c18a/alembic-1.18.5.tar.gz"
    sha256 "1554982221dd17e9a749b53902407578eb305e453f71999e8c7f0a48389fff8e"
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
    url "https://files.pythonhosted.org/packages/3b/72/5562aabb8dd7181e8e860622a38bea08d17842b99ecd4c91f84ac95251b0/anyio-4.14.1.tar.gz"
    sha256 "8d648a3544c1a700e3ff78615cd679e4c5c3f149904287e73687b2596963629e"
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
    url "https://files.pythonhosted.org/packages/c5/0e/3a63efb48aa4a5ae2cfca61ee152fbcb668092134d3eb8bfda472dd5c617/azure_identity-1.25.3.tar.gz"
    sha256 "ab23c0d63015f50b630ef6c6cf395e7262f439ce06e5d07a64e874c724f8d9e6"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/71/74/d756dbdcc8d43a53950c5d8b1ae7745223ba46205ba6037ec9d448f50062/azure_mgmt_compute-38.1.0.tar.gz"
    sha256 "dbbe8355472bf58e9b358041d0124ca6b0fffff79d60aa6d0f094d8644ccffe5"
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
    url "https://files.pythonhosted.org/packages/61/e1/c6196381cc6bb3eff9e24f5bf31b7fd962651ddbd6120bc2a4c482a7af16/azure_mgmt_resource-26.0.0.tar.gz"
    sha256 "54227c5db06d3be4dd4b77ad885b273e9eb2606d1de653c5b534066cfbb60c0c"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ff/9f/897287e955db0f50b12fd69ef45956e4fd2c7ddb48c736872f7ea2314443/boto3-1.43.36.tar.gz"
    sha256 "587d7ee92a12e440ad12b0e7f11f3358f0c4d65b19f64726efc94aaf194aff28"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/7c/37/da9e7f6ca73ac73afd7f0bb7f238aa5daba35c081e98d7f48a7c399599c0/botocore-1.43.36.tar.gz"
    sha256 "4cae47d1b2d426316b85a0087d9e69e048f13bc003b5177d74639fe9dfd28205"
  end

  resource "cached-classproperty" do
    url "https://files.pythonhosted.org/packages/ea/63/fbc7b92eb9514c399d24f31b93d036fd5475961ca57d3945a03c25a77e4e/cached_classproperty-1.1.0.tar.gz"
    sha256 "f012b314d6a797270ebab9df1b1869596d7bf12ec37d7e60d03976224bfbcefd"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/76/7b/1755ed2c6bfabd1d98b37ae73152f8dcf94aa40fee119d163c19ed484704/cachetools-7.0.6.tar.gz"
    sha256 "e5d524d36d65703a87243a26ff08ad84f73352adbeafb1cde81e207b456aaf24"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
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
    url "https://files.pythonhosted.org/packages/e6/dc/be6cbe99670cd6e4ad387123647cb08e0c32975e223f82551e914c5568a6/filelock-3.29.4.tar.gz"
    sha256 "10cdb3656fc44541cdf30652a93fb10ec6b05325620eb316bd26893e4201538a"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/33/f6/354ae6491228b5eb40e10d89c4d13c651fe1cf7556e35ebdded50cff57ce/gitpython-3.1.50.tar.gz"
    sha256 "80da2d12504d52e1f998772dc5baf6e553f8d2fcfe1fcc226c9d9a2ee3372dcc"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/c6/22/155cadf1d49272a9cf48f3168c0f3874fa13397297e611a5ea00cd093880/google_api_core-2.31.0.tar.gz"
    sha256 "2be84ee0f584c48e6bde1b36766e23348b361fb7e55e56135fc76ce1c397f9c2"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/6b/53/0cd38e3a29d72ce45e27feba2ce1cd8049d69af9c48cb14fb164f1be9133/google_api_python_client-2.198.0.tar.gz"
    sha256 "dfe3e16fb241af6e9c460a33f65085b3450e05cea09364f6b5d8997fb7e43e2a"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/81/1c/70b23fc52b2bb3c70b379f3bd05c4a60ab3a873e30c6bd21c57e0154848a/google_auth-2.55.0.tar.gz"
    sha256 "fcd3a130f575fa36403d38774af1c64a4fbfbca09215f0589d2372b5119697cb"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/1c/b3/f192c8bc7e41e0ebdbd95afcae4783417a34b6a6af62d22daf22c3fd38fc/google_auth_httplib2-0.4.0.tar.gz"
    sha256 "d5b030a204b7a4b4d553ba9ca701b62481ee2b74419325580be70f7d85ffed35"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/7f/b9/fcafc8d2dc68975a65cdff74807547cff9b2a7b00e738d3f5ff0bd112867/google_cloud_appengine_logging-1.10.0.tar.gz"
    sha256 "b5563e76010a36e6adf1cc489620c29ee4fb3b986b006d237e9a061eb0f0abb7"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/01/46/b971191224557091cc865b47d527e61da180e33b9397904bdefdae1dcacd/google_cloud_audit_log-0.6.0.tar.gz"
    sha256 "4dd343683c0bb31187ebef3426803f13159e950fbea3fe60a864855cfed959b8"
  end

  resource "google-cloud-billing" do
    url "https://files.pythonhosted.org/packages/30/c1/6f6e9762e8e89edc21267062456d851da02773eceb8250583cee44f89ceb/google_cloud_billing-1.20.0.tar.gz"
    sha256 "155824147381d3ed0303092540992bde50214a29177529458e3c4cc3de2b588f"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/85/f8/d0b8f06dd2509e4006ef27bb07f17f9fcc15aedf5093c3fe22574e45eae0/google_cloud_compute-1.48.0.tar.gz"
    sha256 "670efbc2c5718cb86d3e8cb618afae9fb0c1ea8769c792fb960aabe075ba9e79"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/a8/dd/1eef226e470369b26824a505c34482c0b493bc35fe8e0c6b003b5feca21a/google_cloud_core-2.6.0.tar.gz"
    sha256 "e76149739f90fac1fc6757c09f47eaccb3145b54adbd7759b0f7c4b235f46c83"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/9b/ba/e749846f13c8d1c6c01eb6317e8b09abc130fe67b5d72081a48d1bf96971/google_cloud_logging-3.16.0.tar.gz"
    sha256 "08a3076b8f0f724219d6f73b2a242ef69d51e8bce226133aebe41a25f23f5400"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/58/72/86f94e1639a8bcd9d33e8e01b49afcaa1c3a13bda7683c681717e0901e15/google_cloud_storage-3.12.0.tar.gz"
    sha256 "03ae9847c6babb368f35f054126b8a08cbc0e3266efb990eb17b9926a45cf3be"
  end

  resource "google-cloud-tpu" do
    url "https://files.pythonhosted.org/packages/d5/4a/1cd9c4afa464df17dd1ba231e099ea7e5ddd7460af325f5954de87f0ab3f/google_cloud_tpu-1.27.0.tar.gz"
    sha256 "9c7abbf299f4fa6d421cf094268b795ad6fb99ec02b31af152160469db383c4e"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/03/41/4b9c02f99e4c5fb477122cd5437403b552873f014616ac1d19ac8221a58d/google_crc32c-1.8.0.tar.gz"
    sha256 "a428e25fb7691024de47fecfbff7ff957214da51eddded0da0ae0e0f03a2cf79"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/48/f8/1ca5781d6be9cb9f73f7d40f4958c4bd1226a60598e3e39e1d6aaf838c4b/google_resumable_media-2.10.0.tar.gz"
    sha256 "e324bc9d0fdae4c52a08ae90456edc4e71ece858399e1217ac0eb3a51d6bc6ee"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/55/3e/e7b21b3a34d08920ccebe55dd01f353cdc9d84ed25c3d62f0c9b778814de/gpuhunt-0.1.25.tar.gz"
    sha256 "e2357c769ac4a6e5eec65ad5b0260eced1b243bf5d79566579c9e6ab5c35322a"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/dd/8b/befc3cb36965f397d87e86fb3b00e3ec0dc67c1ecb0986d7f54ee528f018/greenlet-3.5.2.tar.gz"
    sha256 "c1b906220d83c140361cdd12eef970fb5881a168b98ee58a43786426173da14c"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/44/4f/d098419ad0bfc06c9ce440575f05aa22d8973b6c276e86ac7890093d3c37/grpc_google_iam_v1-0.14.4.tar.gz"
    sha256 "392b3796947ed6334e61171d9ab06bf7eb357f554e5fc7556ad7aab6d0e17038"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/b0/b5/1ff353970a87eda4c98251e34d2dfd214abd4982dc89119c9252a2a482d2/grpcio-1.81.1.tar.gz"
    sha256 "6fa10a767143a5e82e8eaab53918af0cd8909a57a27f8cb2288b80a613ac671b"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/32/26/0aa9168c87882381fd810d140c279a2490ed6aee655f0515d6f56c5ca404/grpcio_status-1.81.1.tar.gz"
    sha256 "9389a03e746017b10f0630c064289201458f3ce01f5d7ef4b0bebc1ef6cf82ad"
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
    url "https://files.pythonhosted.org/packages/43/e5/d471fcb0e14523fe1c3f4ba58ca52480e7bd70ad7109a3846bc75892f7fb/httptools-0.8.0.tar.gz"
    sha256 "6b2a32f18d97e16e90827d7a819ffa8dbd8cc245fc4e1fa9d1095b54ef4bd999"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/f4/4a/37928a560a345c6efb207452cf81d3c14f25a6d83df0fa5a00752c0c912b/ignore_python-0.3.3.tar.gz"
    sha256 "dc80ac80ace112da6d02f44681b6beb2ccecb68d6ac2b5e1b82d7f84347e1cf6"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
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
    url "https://files.pythonhosted.org/packages/00/62/791b31e69ae182791ec67f04850f2f062716bbd205483d63a215f3e062d3/mako-1.3.12.tar.gz"
    sha256 "9f778e93289bd410bb35daadeb4fc66d95a746f0b75777b942088b7fd7af550a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
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
    url "https://files.pythonhosted.org/packages/9a/99/d840198ecf6e8057bbc937f129ae940404485d736cda73253bbff9537f01/msal-1.37.0.tar.gz"
    sha256 "1b1672a33ee467c1d70b341bb16cafd51bb3c817147a95b93263794b03971bec"
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
    url "https://files.pythonhosted.org/packages/ae/cc/e4c9584181f86494df0f6bdec1a4f3280c50db44704dc2a407e994fc87bb/opentelemetry_api-1.43.0.tar.gz"
    sha256 "107d0d03857ea8fc7c5fcbbbd83f800c281f0d560553d61c1d675fccfd1761c1"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/7e/0c/964746fcafbd16f8ff53219ad9f6b412b34f345c75f384ad434ceaadb538/orjson-3.11.9.tar.gz"
    sha256 "4fef17e1f8722c11587a6ef18e35902450221da0028e65dbaaa543619e68e48f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/62/93/dcc25d52f49022ae6175d15e6bd751f1acc99b98bc61fc55e5155a7be2e7/paramiko-5.0.0.tar.gz"
    sha256 "36763b5b95c2a0dcfdf1abc48e48156ee425b21efe2f0e787c2dd5a95c0e5e79"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/1b/fb/d9aa83ffe43ce1f19e557c0971d04b90561b0cfd50762aafb01968285553/prometheus_client-0.25.0.tar.gz"
    sha256 "5e373b75c31afb3c86f1a52fa1ad470c9aace18082d39ec0d2f918d11cc9ba28"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
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
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
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
    url "https://files.pythonhosted.org/packages/f7/ff/3cc9165fd44106973cd7ac9facb674a65ed853494592541d339bdc9a30eb/python_json_logger-4.1.0.tar.gz"
    sha256 "b396b9e3ed782b09ff9d6e4f1683d46c83ad0d35d2e407c09a9ebbf038f88195"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
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
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/22/80/44636b363e75af7f5e6ac0571137466fec66e47016179139d0019a453ab7/requests_unixsocket-0.4.1.tar.gz"
    sha256 "b2596158c356ecee68d27ba469a52211230ac6fb0cde8b66afb19f0ed47a1995"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/6a/e5/1064c43203a357d668cd42435f7a15fe6af51512d85b2104fecb937aa861/rich_argparse-1.8.0.tar.gz"
    sha256 "679df3d832fa94ad6e4bdb07ded088cd7ea2dddc58ae9b2b46346a40b06cbc0c"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/f6/94/dcdaeb1713cab9c84def276cfac7388b17c7d9855bbcfe88d77e4dbafd44/s3transfer-0.19.0.tar.gz"
    sha256 "ce436931687addc4c1712d52d40b32f53e88315723f107ffa20ba82b05a0f685"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/ba/c8/b3c970a5b186722d276cd40a05b3254e03bccc0208560aff20f612e018e8/sentry_sdk-2.63.0.tar.gz"
    sha256 "2a1502bf864769275dbc8c2c9fc7a0f7f5e18358180b615d262d13a31ffba216"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smg-grpc-proto" do
    url "https://files.pythonhosted.org/packages/66/e0/a8c0499bb4fbfebe4ff51ec674ded489cccbcf243f7f9e2ca09a45838608/smg_grpc_proto-0.4.9.tar.gz"
    sha256 "ea54704ab92452d9ce13371dc65234799bfd18cc1fcd6806a9d0c3e23e149d20"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/02/f1/a7a892f18d4d224e6b26f706531eafccc41e37594d37d304786969ee13cb/sqlalchemy-2.0.51.tar.gz"
    sha256 "804dccd8a4a6242c4e30ad961e540e18a588f6527202f2d6791b01845d59fdc9"
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
    url "https://files.pythonhosted.org/packages/87/d7/0535a28b1f5f24f6612fb3ff1e89fb1a8d160fee0f976e0aa6803862134b/tqdm-4.68.3.tar.gz"
    sha256 "00dfa48452b6b6cfae3dd9885636c23d3422d1ec97c66d96818cbd5e0821d482"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/48/55/15e2340963d2bfedcc6042da3911438fd336f8ae96b65bdbe3a29766da0c/tzlocal-5.4.3.tar.gz"
    sha256 "3a8c9bc18cf47e1dcde252ea0e6a72a6cde320a400b6ac6db1f1f8cccd553c00"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c4/1f/fa18009dea8469069cca78a4e877a008ab78f08b064bfc9ab891579077ff/uvicorn-0.49.0.tar.gz"
    sha256 "ebf4271aa580d9de97f93192d4595176df6e91f9aae919ca73e4fc07df1e66a3"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/49/b4/51fe890511f0f242d07cb1ebe6a5b6db417262b9d2568b460347c57d95cc/wcwidth-0.8.1.tar.gz"
    sha256 "faf5b4a5366a72dc49cad48cdf21f52bdf63bdda995178e483ba247ff79089b9"
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
