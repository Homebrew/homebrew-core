class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/35/53/95e1ca856291a61a66f5482a9ada99570bfac7f9bbd613c0bd1a30b317dd/dstack-0.19.7.tar.gz"
  sha256 "fe6e7c47ffc6ad8f039e68cbfeb802b0fad1a5d69389a01e5bb79b70bab5d4b7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8e9ecef2b6d74687db5443a38fa3ceecaf098e4ef29b61b8b513ccabf79aebc"
    sha256 cellar: :any,                 arm64_sonoma:  "8177168400ad08e25338b30fc174b7ca845481047f07f21a456ebcee24b1df86"
    sha256 cellar: :any,                 arm64_ventura: "8e27937b09ce425c0683086edf028f096807f6ceb55809d9a528bc694f4b4c5d"
    sha256 cellar: :any,                 sonoma:        "5043e3577b688a9e42c17fbed3f9b1f670489933570a70daafd9e21f3a8a38c1"
    sha256 cellar: :any,                 ventura:       "b76b1fd0711d14595abe2276873a785545aa441ad41afa621cc8bb1bd6d8e40a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ff0a8357c21c9765f5999c1a4f850c9f6310e4586110809abdcff9b64e30c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcee2dbc2a38063824c3e97fa69a500227ed03dabea9d3461a0e294c7b285af2"
  end

  # `pkgconf` and `rust` are for bcrypt.
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "aiocache" do
    url "https://files.pythonhosted.org/packages/7a/64/b945b8025a9d1e6e2138845f4022165d3b337f55f50984fbc6a4c0a1e355/aiocache-0.12.3.tar.gz"
    sha256 "f528b27bf4d436b497a1d0d1a8f59a542c153ab1e37c3621713cb376d44c4713"
  end

  resource "aiorwlock" do
    url "https://files.pythonhosted.org/packages/c5/bf/d1ddcd676be027a963b3b01fdf9915daf4590b4dfd03bf1c8c2858aac7e3/aiorwlock-1.5.0.tar.gz"
    sha256 "b529da24da659bdedcf68faf216595bde00db228c905197ac554773620e7fd2f"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/13/7d/8bca2bf9a247c2c5dfeec1d7a5f40db6518f88d314b8bca9da29670d2671/aiosqlite-0.21.0.tar.gz"
    sha256 "131bb8056daa3bc875608c631c678cda73922a2d4ba8aec373b19f18c17e7aa3"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/e6/57/e314c31b261d1e8a5a5f1908065b4ff98270a778ce7579bd4254477209a7/alembic-1.15.2.tar.gz"
    sha256 "1c72391bbdeffccfe317eefba686cb9a3c078005478885413b95c3b26c57a8a7"
  end

  resource "alembic-postgresql-enum" do
    url "https://files.pythonhosted.org/packages/f9/45/d3a66a8c7604baba5b498727539539120897fd8f931a6c89aa68ff0d7cb3/alembic_postgresql_enum-1.7.0.tar.gz"
    sha256 "1a12a2b25f3f49440f419821888530496511573875438b6e9a08cbcb8a6f006f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/4e/00/6d6814ddc19be2df62c8c898c4df6b5b1914f3bd024b780028caa392d186/apscheduler-3.11.0.tar.gz"
    sha256 "4c622d250b0955a65d5d0eb91c33e6d43fd879834bf541e0a18661ae60460133"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "asyncpg" do
    url "https://files.pythonhosted.org/packages/2f/4c/7c991e080e106d854809030d8584e15b2e996e26f16aee6d757e387bc17d/asyncpg-0.30.0.tar.gz"
    sha256 "c551e9928ab6707602f44811817f82ba3c446e018bfe1d3abecc8ba5f3eac851"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
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

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/87/30/bb941f2eee419009668305b510dfb3577604a08102b3a1d0df78d14205f3/azure_mgmt_compute-34.1.0.tar.gz"
    sha256 "cd9d35d1cc1b8cb0bd241ad55c91b77d14e04ae73c632ada1140135f9c217fe1"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/48/9a/9bdc35295a16fe9139a1f99c13d9915563cbc4f30b479efaa40f8694eaf7/azure_mgmt_core-1.5.0.tar.gz"
    sha256 "380ae3dfa3639f4a5c246a7db7ed2d08374e88230fd0da3eb899f7c11e5c441a"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/bf/aa/bf464fd70eefa8f13f5e5b45d021416d5c9c8d79eabb96f4a673fe91346d/azure_mgmt_network-27.0.0.tar.gz"
    sha256 "5c1c61d8bb13ad40f788a26fd7569c1d9d60eb2e4cb19c2a1b5d9c02ae862316"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/a7/28/e950da2d89e55e2315ff0f4de075da4ac0fed4c27a489f7c774dedde9854/azure_mgmt_resource-23.3.0.tar.gz"
    sha256 "fc4f1fd8b6aad23f8af4ed1f913df5f5c92df117449dc354fea6802a2829fea4"
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
    url "https://files.pythonhosted.org/packages/bb/5d/6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77b/bcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e9/1c/4f7233a257d0981bc3f5b4bef80be0698454b87097927aee75ba3cc35fab/boto3-1.38.6.tar.gz"
    sha256 "9d764c402cadd112020812b9621a567058aa29d41a491d2d04b070be19ad5173"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a8/12/416080d232c677da31f259b24acb0557d9423325565bafaec80ef5bd9c4f/botocore-1.38.6.tar.gz"
    sha256 "07e0721f6b1758183ed425f481a7af79e4897a3c02c2c486e101c576aee7377c"
  end

  resource "cached-classproperty" do
    url "https://files.pythonhosted.org/packages/6f/00/6c75d528e795555d65de8a4cd181347a5918d267c278478aeba2b369769b/cached_classproperty-1.0.1.tar.gz"
    sha256 "24ac50911c5a87bd57fafc348ce14ba58584975e73d1dfea329d1dcdc9f774c0"
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

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/f4/55/ae499352d82338331ca1e28c7f4a63bfd09479b16395dce38cf50a39e2c2/fastapi-0.115.12.tar.gz"
    sha256 "1e2c2a2646905f9e83d32f04a3f86aff4a286669c6c950ca95b5fd68c2602681"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/6a/a2/7950df7fbb8ab1b7afb286ab374df2f5b3ea107b5d18224eac4e81bd2a69/google_api_core-2.25.0rc0.tar.gz"
    sha256 "38d9d6a67673473457adbbef1ccca27d9ebb755e377c05e8a9b88f89eecab9ad"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/4f/e6/787c24738fc7c99de9289abe60bd64591800ae1cdf60db7b87e0e6ef9cdd/google_api_python_client-2.169.0.tar.gz"
    sha256 "0585bb97bd5f5bf3ed8d4bf624593e4c5a14d06c811d1952b07a1f94b4d12c51"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/cb/8e/8f45c9a32f73e786e954b8f9761c61422955d23c45d1e8c347f9b4b59e8e/google_auth-2.39.0.tar.gz"
    sha256 "73222d43cdc35a3aeacbfdcaf73142a97839f10de930550d89ebfe1d0a00cde7"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/cb/ec/ac5eed8660dd49a68d425c1e9594a40dc0c757d3d06af1e7731e5ff5d4ee/google_cloud_appengine_logging-1.6.1.tar.gz"
    sha256 "f97bde36c7f7ff541123c2570813158bdda0c3f2385c8d32fdf1211c561ae56d"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/85/af/53b4ef636e492d136b3c217e52a07bee569430dda07b8e515d5f2b701b1e/google_cloud_audit_log-0.3.2.tar.gz"
    sha256 "2598f1533a7d7cdd6c7bf448c12e5519c1d53162d78784e10bcdd1df67791bc3"
  end

  resource "google-cloud-billing" do
    url "https://files.pythonhosted.org/packages/e0/75/3154aa521af2028ae12ac45afefe1f4b1a4e9c1ddf4db8107be1aebf7d28/google_cloud_billing-1.16.2.tar.gz"
    sha256 "49ed14e5b184731ec9207e0eaf0f72cbab4ac541a2017f939c1a3e3bb5966d04"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/3f/ff/ea0b7e1b265b91511cb44b95e64634d10e747133a1896c6d80fb4a559cfe/google_cloud_compute-1.30.0.tar.gz"
    sha256 "8b2d3fe37380de5859a786081d9bcc1203a0f3a205300839a27f828d59828a27"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/d6/b8/2b53838d2acd6ec6168fd284a990c76695e84c65deee79c9f3a4276f6b4f/google_cloud_core-2.4.3.tar.gz"
    sha256 "1fab62d7102844b278fe6dead3af32408b1df3eb06f5c7e8634cbd40edc4da53"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/14/9c/d42ecc94f795a6545930e5f846a7ae59ff685ded8bc086648dd2bee31a1a/google_cloud_logging-3.12.1.tar.gz"
    sha256 "36efc823985055b203904e83e1c8f9f999b3c64270bcda39d57386ca4effd678"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/f3/08/52143124415a889bbab60a8ecede1e31ea0e8d992ca078317886f26dc3be/google_cloud_storage-3.1.0.tar.gz"
    sha256 "944273179897c7c8a07ee15f2e6466a02da0c7c4b9ecceac2a26017cb2972049"
  end

  resource "google-cloud-tpu" do
    url "https://files.pythonhosted.org/packages/45/1f/e3bbd2115e64258ed50e901c264408999e35aa593125cebc7cc087f43221/google_cloud_tpu-1.23.1.tar.gz"
    sha256 "df0f8c6e825c0a48471bed825a79d31686390d2069e374f086e0953f5771357c"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/19/ae/87802e6d9f9d69adfaedfcfd599266bf386a54d0be058b532d04c794f76d/google_crc32c-1.7.1.tar.gz"
    sha256 "2bff2305f98846f3e825dbeec9ee406f89da7962accdb29356e4eadc251bd472"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/58/5a/0efdc02665dca14e0837b62c8a1a93132c264bd02054a15abb2218afe0ae/google_resumable_media-2.7.2.tar.gz"
    sha256 "5280aed4629f2b60b847b0d42f9857fd4935c11af266744df33d8074cae92fe0"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/97/bd/c66741a78134095022d365f89de97b06afc31f4e8aa23fc5cacf993010b0/gpuhunt-0.1.5.tar.gz"
    sha256 "fc6e744c2156c3b78d5412d39298814e24bbb50f9909e4f2be8e47a4423ff683"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3f/74/907bb43af91782e0366b0960af62a8ce1f9398e4291cac7beaeffbee0c04/greenlet-3.2.1.tar.gz"
    sha256 "9f4dd4b4946b14bb3bf038f81e1d2e535b7d94f1b2a59fdba1293cd9c1a0a4d7"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/b9/4e/8d0ca3b035e41fe0b3f31ebbb638356af720335e5a11154c330169b40777/grpc_google_iam_v1-0.14.2.tar.gz"
    sha256 "b3e1fc387a1a329e41672197d0ace9de22c78dd7d215048c4c78712073f7bd20"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/d1/33/bf7bf9188cfce1c626e4c5d55523fec7f2f1d905e003df5da025f532916e/grpcio-1.72.0rc1.tar.gz"
    sha256 "221793dccd3332060f426975a041d319d6d57323d857d4afc25257ec4a5a67f3"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/d7/53/a911467bece076020456401f55a27415d2d70d3bc2c37af06b44ea41fc5c/grpcio_status-1.71.0.tar.gz"
    sha256 "11405fed67b68f406b3f3c7c5ae5104a79d2d309666d10d61b152e91d28fb968"
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
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
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

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/3f/90/81dcc50f0be11a8c4dcbae1a9f761a26e5f905231330a7cacc9f04ec4c61/msal-1.32.3.tar.gz"
    sha256 "5eea038689c78a5a70ca8ecbe1245458b55a857bd096efb6989c69ba15985d35"
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
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/42/40/2359245cd33641c2736a0136a50813352d72f3fc209de28fb226950db4a1/opentelemetry_api-1.32.1.tar.gz"
    sha256 "a5be71591694a4d9195caf6776b055aa702e964d961051a0715d05f8632c32fb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/7d/15/ad6ce226e8138315f2451c2aeea985bf35ee910afb477bae7477dc3a8f3b/paramiko-3.5.1.tar.gz"
    sha256 "b2c665bc45b2b215bd7d7f039901b14b067da00f3a11e6640995fd58f2664822"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/62/14/7d0f567991f3a9af8d1cd4f619040c93b68f09a02b6d0b6ab1b2d1ded5fe/prometheus_client-0.21.1.tar.gz"
    sha256 "252505a722ac04b0456be05c05f75f45d760c2911ffc45f2a06bcaed9f3ae3fb"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/17/7d/b9dca7365f0e2c4fa7c193ff795427cfa6290147e5185ab11ece280a18e7/protobuf-5.29.4.tar.gz"
    sha256 "4f1dfcd7997b31ef8f53ec82781ff434a28bf71d9102ddde14d076adcfc78c99"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
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
    url "https://files.pythonhosted.org/packages/9a/57/5996c63f0deec09e9e901a2b838247c97c6844999562eac4e435bcb83938/pydantic-1.10.22.tar.gz"
    sha256 "ee1006cebd43a8e7158fb7190bb8f4e2da9649719bff65d0c287282ec38dec6d"
  end

  resource "pydantic-duality" do
    url "https://files.pythonhosted.org/packages/9e/64/da9e9525f68803d75dca8b693097c666e53f2268cddaa51d6ec2335fe331/pydantic_duality-1.2.4.tar.gz"
    sha256 "34bdbf102c004f009619c2b6682143fa6f14c04bf947f0ba72d75b04e84a65c7"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dxf" do
    url "https://files.pythonhosted.org/packages/cc/f6/aac11aa8d64d39706838d57ace0b5ba5c31af157019e96c1bf2a8930563d/python_dxf-12.1.0.tar.gz"
    sha256 "59ff22c0ab92a29fb3085f65ea70c0e8c7ff9fdfd74db0109efd5dfdc404d96c"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/9e/de/d3144a0bceede957f961e975f3752760fbe390d57fbe194baf709d8f1f7b/python_json_logger-3.3.0.tar.gz"
    sha256 "12b7e74b17775e7d565129296105bbe3910842d9d0eb083fc83a6a617aa8df84"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/f3/87/f44d7c9f274c7ee665a29b885ec97089ec5dc034c7f3fafa03da9e39a09e/python_multipart-0.0.20.tar.gz"
    sha256 "8dd0cab45b8e23064ae09147625994d090fa46f5b0d1e13af944c331a7fa9d13"
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

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/aa/b9/ff53663ee7fa6a4195fa96d91da499f2e00ca067541e016d345cce1c9ad2/rich_argparse-1.7.0.tar.gz"
    sha256 "f31d809c465ee43f367d599ccaf88b73bc2c4d75d74ed43f2d538838c53544ba"
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
    url "https://files.pythonhosted.org/packages/fc/9e/73b14aed38ee1f62cd30ab93cd0072dec7fb01f3033d116875ae3e7b8b44/s3transfer-0.12.0.tar.gz"
    sha256 "8ac58bc1989a3fdb7c7f3ee0918a66b160d038a147c7b5db1500930a607e9a1c"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/cf/b6/a92ae6fa6d7e6e536bc586776b1669b84fb724dfe21b8ff08297f2d7c969/sentry_sdk-2.27.0.tar.gz"
    sha256 "90f4f883f9eff294aff59af3d58c2d1b64e3927b28d5ada2b9b41f5aeda47daf"
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

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/68/c3/3f2bfa5e4dcd9938405fe2fab5b6ab94a9248a4f9536ea2fd497da20525f/sqlalchemy-2.0.40.tar.gz"
    sha256 "d827099289c64589418ebbcaead0145cd19f4e3e8a93919a0100247af245fa00"
  end

  resource "sqlalchemy-utils" do
    url "https://files.pythonhosted.org/packages/4d/bf/abfd5474cdd89ddd36dbbde9c6efba16bfa7f5448913eba946fed14729da/SQLAlchemy-Utils-0.41.2.tar.gz"
    sha256 "bc599c8c3b3319e53ce6c5c3c471120bd325d0071fb6f38a10e924e3d07b9990"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/ce/20/08dfcd9c983f6a6f4a1000d934b9e6d626cff8d2eeb77a89a68eef20a2b7/starlette-0.46.2.tar.gz"
    sha256 "7f7361f34eed179294600af672f565727419830b54b7b084efe44bb82d2fccd5"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
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

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/a6/ae/9bbb19b9e1c450cf9ecaef06463e40234d98d95bf572fab11b4f19ae5ded/uvicorn-0.34.2.tar.gz"
    sha256 "0e929828f6186353a80b58ea719861d2629d766293b6d19baf086ba31d4f3328"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/03/e2/8ed598c42057de7aa5d97c472254af4906ff0a59a66699d426fc9ef795d7/watchfiles-1.0.5.tar.gz"
    sha256 "b7529b5dcc114679d43827d8c35a07c493ad6f083633d573d81c660abc5979e9"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "www-authenticate" do
    url "https://files.pythonhosted.org/packages/a7/2d/5567291a8274ef5d9b6495a1ec341394ab68933e2396936755b157f87b43/www-authenticate-0.9.2.tar.gz"
    sha256 "cf75fc2ea5effb0f9342d7de7619b736f2a7d4b223331a53e296863a286e9dcb"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = "No default project, specify project name"
    assert_match expected, shell_output("#{bin}/dstack init 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/dstack --version")
  end
end
