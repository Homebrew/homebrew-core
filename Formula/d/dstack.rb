class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://dstack.ai/"
  url "https://files.pythonhosted.org/packages/98/82/f5221bb214f01a42b9055ecea6e84350a085cf4a8a0b3e826e9d232e19f7/dstack-0.18.20.tar.gz"
  sha256 "5c2c62716d571afa0d53358e1065264da9a6b1e43fced34ecd1e7f457a9abe84"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb37976bb24d9b5c1559118f156f70c502266a191e47da42076aad4ad0c5fa1a"
    sha256 cellar: :any,                 arm64_sonoma:  "9eac968b0cf24556b738c09df326cc78eccfd1f3dd2f5d21674006acfab2c710"
    sha256 cellar: :any,                 arm64_ventura: "e0fe2675afacc513940ed6ad0047893b33cd41b52180cd70a1f1e0a0ceceb2b5"
    sha256 cellar: :any,                 sonoma:        "d4806706141fe87a66c629ef7ab58290337636ed44b150f02c8e8f3992390c7c"
    sha256 cellar: :any,                 ventura:       "db78e9c52934d5c0ea7dbd16687b8814c2784b27252ddc190478f40601ede6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5087da34778eb0fa7c286c68a6e8948a6b789d56b2b3098ee780c553b5f535"
  end

  # `pkg-config` and `rust` are for bcrypt.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/bc/69/2f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40/aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/17/7e/16e57e6cf20eb62481a2f9ce8674328407187950ccc602ad07c685279141/aiohttp-3.10.10.tar.gz"
    sha256 "0631dd7c9f0822cc61c88586ca76d5b5ada26538097d0f1df510b082bad3411a"
  end

  resource "aiorwlock" do
    url "https://files.pythonhosted.org/packages/ba/c5/882b4c89d71d6f9c7d0d8dee18d267025e71d4c3241eb3b16ab39105a0d1/aiorwlock-1.4.0.tar.gz"
    sha256 "4cea5bec4e9d03533a26919299394822a1422aa519bca9dd09178ec490f8d1cc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/0d/3a/22ff5415bf4d296c1e92b07fd746ad42c96781f13295a074d58e77747848/aiosqlite-0.20.0.tar.gz"
    sha256 "6d35c8c256637f4672f843c31021464090805bf925385ac39473fb16eaaca3d7"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/94/a2/840c3b84382dce8624bc2f0ee67567fc74c32478d0c5a5aea981518c91c3/alembic-1.13.3.tar.gz"
    sha256 "203503117415561e203aa14541740643a611f641517f0209fcae63e9fa09f1a2"
  end

  resource "alembic-postgresql-enum" do
    url "https://files.pythonhosted.org/packages/c4/63/5188bd184cc7515090ca98686b97695f68aca403c119e688b66ceb0e653b/alembic_postgresql_enum-1.3.0.tar.gz"
    sha256 "64d5de7ac2ea39433afd965b057ca882fb420eb5cd6a7db8e2b4d0e7e673cae1"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/9f/09/45b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546cc/anyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/5e/34/5dcb368cf89f93132d9a31bd3747962a9dc874480e54333b0c09fa7d56ac/APScheduler-3.10.4.tar.gz"
    sha256 "e6df071b27d9be898e486bc7940a7be50b4af2e9da7c08f0744a96d4bd4cef4a"
  end

  resource "asyncpg" do
    url "https://files.pythonhosted.org/packages/2f/4c/7c991e080e106d854809030d8584e15b2e996e26f16aee6d757e387bc17d/asyncpg-0.30.0.tar.gz"
    sha256 "c551e9928ab6707602f44811817f82ba3c446e018bfe1d3abecc8ba5f3eac851"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/03/7a/f79ad135a276a37e61168495697c14ba1721a52c3eab4dae2941929c79f8/azure_core-1.31.0.tar.gz"
    sha256 "656a0dd61e1869b1506b7c6a3b31d62f15984b1a573d6326f6aa2f3e4123284b"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/aa/91/cbaeff9eb0b838f0d35b4607ac1c6195c735c8eb17db235f8f60e622934c/azure_identity-1.19.0.tar.gz"
    sha256 "500144dc18197d7019b81501165d4fa92225f03778f17d7ca8a2a180129a9c83"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/9e/ab/e79874f166eed24f4456ce4d532b29a926fb4c798c2c609eefd916a3f73d/azure-mgmt-authorization-4.0.0.zip"
    sha256 "69b85abc09ae64fc72975bd43431170d8c7eb5d166754b98aac5f3845de57dc4"
  end

  resource "azure-mgmt-compute" do
    url "https://files.pythonhosted.org/packages/90/f2/a2b1391e9df876d7ef9086f8d41ad4666eafef921ae0c47da931f8cedb1a/azure-mgmt-compute-33.0.0.tar.gz"
    sha256 "a3cc0fe4f09c8e1d3523c1bfb92620dfe263a0a893b0ac13a33d7057e9ddddd2"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/14/95/2b2085e40f4b9de88ad256428a669583066d8ab348fc19110c7d04c3189b/azure-mgmt-core-1.4.0.zip"
    sha256 "d195208340094f98e5a6661b781cde6f6a051e79ce317caabd8ff97030a9b3ae"
  end

  resource "azure-mgmt-network" do
    url "https://files.pythonhosted.org/packages/bf/aa/bf464fd70eefa8f13f5e5b45d021416d5c9c8d79eabb96f4a673fe91346d/azure_mgmt_network-27.0.0.tar.gz"
    sha256 "5c1c61d8bb13ad40f788a26fd7569c1d9d60eb2e4cb19c2a1b5d9c02ae862316"
  end

  resource "azure-mgmt-resource" do
    url "https://files.pythonhosted.org/packages/71/e9/cafb7076283db9f21e05e54fa0536b16d790e43f30691e80d6eac4603789/azure_mgmt_resource-23.2.0.tar.gz"
    sha256 "747b750df7af23ab30e53d3f36247ab0c16de1e267d666b1a5077c39a4292529"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e4/7e/d95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0/bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6e/3e/b48efd041192500ea071aecac94315888dfee5aa5ef6fe7e1caa738336df/boto3-1.35.48.tar.gz"
    sha256 "5007a5cdd09e4db9309adf2ee090455a34ae639bd10a68a1fefca72cd77070fc"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c1/49/4a9e83ad1fb95289d65b9a92df9297d23656037779c5f884c37c247064ae/botocore-1.35.48.tar.gz"
    sha256 "3e766cc251053c9ef98542fdf225381ed58531769c3811a6282bd7247f7e2bdf"
  end

  resource "cached-classproperty" do
    url "https://files.pythonhosted.org/packages/6f/00/6c75d528e795555d65de8a4cd181347a5918d267c278478aeba2b369769b/cached_classproperty-1.0.1.tar.gz"
    sha256 "24ac50911c5a87bd57fafc348ce14ba58584975e73d1dfea329d1dcdc9f774c0"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/a9/ce/b64ce344d7b13c0768dc5b131a69d52f57202eb85839408a7637ca0dd7e2/fastapi-0.115.3.tar.gz"
    sha256 "c091c6a35599c036d676fa24bd4a6e19fa30058d93d950216cdc672881f6f7db"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8f/ed/0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3/frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/28/c8/046abf3ea11ec9cc3ea6d95e235a51161039d4a558484a997df60f9c51e9/google_api_core-2.21.0.tar.gz"
    sha256 "4a152fd11a9f774ea606388d423b68aa7e6d6a0ffe4c8266f74979613ec09f81"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/ff/36/a587319840f32c8a28b6700805ad18a70690f985538ea49e87e210118884/google_api_python_client-2.149.0.tar.gz"
    sha256 "b9d68c6b14ec72580d66001bd33c5816b78e2134b93ccc5cf8f624516b561750"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a1/37/c854a8b1b1020cf042db3d67577c6f84cd1e8ff6515e4f5498ae9e444ea5/google_auth-2.35.0.tar.gz"
    sha256 "f4c64ed4e01e8e8b646ef34c018f8bf3338df0c8e37d8b3bba40e7f574a3278a"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/c9/e7/8439212aae2af478c40ea535affe5f1a6132e52b49cec0700e35a8b39813/google_cloud_appengine_logging-1.4.5.tar.gz"
    sha256 "de7d766e5d67b19fc5833974b505b32d2a5bbdfb283fd941e320e7cfdae4cb83"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/eb/81/c345efe9261a4b0bd0c5957f1685d2b4cc4522ec4fc7b0861f691d4476e7/google_cloud_audit_log-0.3.0.tar.gz"
    sha256 "901428b257020d8c1d1133e0fa004164a555e5a395c7ca3cdbb8486513df3a65"
  end

  resource "google-cloud-billing" do
    url "https://files.pythonhosted.org/packages/7c/66/6bd2cb2ddc592cc274be3ae7f9f76cb4e7f436c340dc8255baca3731d75f/google_cloud_billing-1.13.6.tar.gz"
    sha256 "eb24f7515496991b60f920122539badcb1c2d6007ee35f7ae7fde08e2f9e0839"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/62/6d/17551113240c058013b6702e45fc721622966d0e1f19129aa07affb2e36e/google_cloud_compute-1.19.2.tar.gz"
    sha256 "3fce82abe14e76faaa81234d9a7be1e634b2ed8a27f55feefcf2b146467f7fab"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/b8/1f/9d1e0ba6919668608570418a9a51e47070ac15aeff64261fb092d8be94c0/google-cloud-core-2.4.1.tar.gz"
    sha256 "9b7749272a812bde58fff28868d0c5e2f585b82f37e09a1f6ed2d4d10f134073"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/a5/ac/1eabcefb926414812b759102e4b03a123ad5bfc9576bac0f27405e2f3727/google_cloud_logging-3.11.3.tar.gz"
    sha256 "0a73cd94118875387d4535371d9e9426861edef8e44fba1261e86782d5b8d54f"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/d6/b7/1554cdeb55d9626a4b8720746cba8119af35527b12e1780164f9ba0f659a/google_cloud_storage-2.18.2.tar.gz"
    sha256 "aaf7acd70cdad9f274d29332673fcab98708d0e1f4dceb5a5356aaef06af4d99"
  end

  resource "google-cloud-tpu" do
    url "https://files.pythonhosted.org/packages/d8/04/cfea998c93ce549e8a926eb115dd35505c66f32a30bceace46195f18253d/google_cloud_tpu-1.18.5.tar.gz"
    sha256 "88440a913abeb2b74a8224b109ffaf35c85ab1b2fa7369ea54baf250c2458b5a"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/67/72/c3298da1a3773102359c5a78f20dae8925f5ea876e37354415f68594a6fb/google_crc32c-1.6.0.tar.gz"
    sha256 "6eceb6ad197656a1ff49ebfbbfa870678c75be4344feb35ac1edf694309413dc"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/58/5a/0efdc02665dca14e0837b62c8a1a93132c264bd02054a15abb2218afe0ae/google_resumable_media-2.7.2.tar.gz"
    sha256 "5280aed4629f2b60b847b0d42f9857fd4935c11af266744df33d8074cae92fe0"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/53/3b/1599ceafa875ffb951480c8c74f4b77646a6b80e80970698f2aa93c216ce/googleapis_common_protos-1.65.0.tar.gz"
    sha256 "334a29d07cddc3aa01dee4988f9afd9b2916ee2ff49d6b757155dc0d197852c0"
  end

  resource "gpuhunt" do
    url "https://files.pythonhosted.org/packages/65/f3/1046d5612853bf906114a997db2524d304c57354f10da96a5b4bf50142eb/gpuhunt-0.0.16.tar.gz"
    sha256 "ca8a2dafd66b71f1f68596db9c7738d2d7c229cd9d35a5437529162d2ed14959"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/2f/ff/df5fede753cc10f6a5be0931204ea30c35fa2f2ea7a35b25bdaf4fe40e46/greenlet-3.1.1.tar.gz"
    sha256 "4ce3ac6cdb6adf7946475d7ef31777c26d94bccc377e070a7986bd2d5c515467"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/63/41/f01bf46bac4034b4750575fe87c80c5a43a8912847307955e22f2125b60c/grpc-google-iam-v1-0.13.1.tar.gz"
    sha256 "3ff4b2fd9d990965e410965253c0da6f66205d5a8291c4c31c6ebecca18a9001"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/ec/ae/3c47d71ab4abd4bd60a7e2806071fe0a4b6937b9eabe522291787087ea1f/grpcio-1.67.0.tar.gz"
    sha256 "e090b2553e0da1c875449c8e75073dd4415dd71c9bde6a406240fdf4c0ee467c"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/d2/cc/2bacef7f621af0033f072ffea82aef9bc4d3e672d269b1ffb8296f1f9367/grpcio_status-1.67.0.tar.gz"
    sha256 "c3e5a86fa007e9e263cd5f988a8a907484da4caab582874ea2a4a6092734046b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/b6/44/ed0fa6a17845fb033bd885c03e842f08c1b9406c86a2e60ac1ae1b9206a6/httpcore-1.0.6.tar.gz"
    sha256 "73f6dbd6eb8c21bbf7ef8efad555481853f5f6acdeaff1edb0694289269ee17f"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/c0/bd/fa8ce65b0a7d4b6d143ec23b0f5fd3f7ab80121078c465bc02baeaab22dc/importlib_metadata-8.4.0.tar.gz"
    sha256 "9a547d3bc3608b025f93d403fdd1aae741c24fbb8314df4b155675742ce303c5"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
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
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/fa/0b/29bc5a230948bf209d3ed3165006d257e547c02c3c2a96f6286320dfe8dc/mako-1.3.6.tar.gz"
    sha256 "9ec3a1583713479fae654f83ed9fa8c9a4c16b7bb0daba0e6bbebff50c0d983d"
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
    url "https://files.pythonhosted.org/packages/59/04/8d7aa5c671a26ca5612257fd419f97380ba89cdd231b2eb67df58483796d/msal-1.31.0.tar.gz"
    sha256 "2c4f189cf9cc8f00c80045f66d39b7c0f3ed45873fd3d1f2af9f22db2e12ff4b"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/2d/38/ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5eb/msal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/c9/83/93114b6de85a98963aec218a51509a52ed3f8de918fe91eb0f7299805c3f/opentelemetry_api-1.27.0.tar.gz"
    sha256 "ed673583eaa5f81b5ce5e86ef7cdaf622f88ef65f0b9aab40b843dcae5bef342"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1b/0f/c00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609b/paramiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a9/4d/5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cd/propcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/7e/05/74417b2061e1bf1b82776037cad97094228fa1c1b6e82d08a78d3fb6ddb6/proto_plus-1.25.0.tar.gz"
    sha256 "fbb17f57f7bd05a68b7707e745e26528b0b3c34e378db91eef93912c54982d91"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/74/6e/e69eb906fddcb38f8530a12f4b410699972ab7ced4e21524ece9d546ac27/protobuf-5.28.3.tar.gz"
    sha256 "64badbc49180a5e401f373f9ce7ab1d18b63f7dd4a9cdc43c92b9f0b481cef7b"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/20/e6/89d6ba0c0a981fd7e3129d105502c4cf73fad1611b294c87b103f75b5837/pydantic-1.10.18.tar.gz"
    sha256 "baebdff1907d1d96a139c25136a9bb7d17e118f133a76a2ef3b845e831e3403a"
  end

  resource "pydantic-duality" do
    url "https://files.pythonhosted.org/packages/91/b8/629ca5f981cb91c86fffad1872c35695857dc4e34a512c0e60e3412e85b3/pydantic_duality-1.2.0.tar.gz"
    sha256 "0202c47ebdeba755d946c90397c2d954d4bf31e408ee4e03d69006848278b844"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/fb/68/ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020e/pyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
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
    url "https://files.pythonhosted.org/packages/4f/da/95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13/python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/16/6e/7ecfe1366b9270f7f475c76fcfa28812493a6a1abd489b2433851a444f4f/python_multipart-0.0.12.tar.gz"
    sha256 "045e1f98d719c1ce085ed7f7e1ef9d8ccc8c02ba02b5566d5f7521410ced58cb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
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
    url "https://files.pythonhosted.org/packages/d9/e9/cf9ef5245d835065e6673781dbd4b8911d352fb770d56cf0879cf11b7ee1/rich-13.9.3.tar.gz"
    sha256 "bc1e01b899537598cf02579d2b9f4a415104d3fc439313a7a2c165d76557a08e"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/26/f1/0a5ba24d684012e2f25deec88d9a9a1199d8e26e3bb595b812c8b0218cff/rich_argparse-1.5.2.tar.gz"
    sha256 "84d348d5b6dafe99fffe2c7ea1ca0afe14096c921693445b9eee65ee4fcbfd2c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/b1/83/7d0956a71ac894717099be3669ca7b8f164bccbcfb570b2f02817d0a0068/sentry_sdk-2.17.0.tar.gz"
    sha256 "dd0a05352b78ffeacced73a94e86f38b32e2eae15fff5f30ca5abb568a72eacf"
  end

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/a1/a0/7e78b93510886f6fb5b7146bd5cee03986fa5c2319644155c275e389c55a/simple-term-menu-1.6.4.tar.gz"
    sha256 "be9c5dbd8df12a404b14cd8e95d6fc02d58c60e2555f65ddde41777c487fb3b9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/50/65/9cbc9c4c3287bed2499e05033e207473504dc4df999ce49385fb1f8b058a/sqlalchemy-2.0.36.tar.gz"
    sha256 "7f2767680b6d2398aea7082e45a774b2b0767b5c8d8ffb9c8b683088ea9b29c5"
  end

  resource "sqlalchemy-utils" do
    url "https://files.pythonhosted.org/packages/4d/bf/abfd5474cdd89ddd36dbbde9c6efba16bfa7f5448913eba946fed14729da/SQLAlchemy-Utils-0.41.2.tar.gz"
    sha256 "bc599c8c3b3319e53ce6c5c3c471120bd325d0071fb6f38a10e924e3d07b9990"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/78/53/c3a36690a923706e7ac841f649c64f5108889ab1ec44218dac45771f252a/starlette-0.41.0.tar.gz"
    sha256 "39cbd8768b107d68bfe1ff1672b38a2c38b49777de46d2a592841d58e3bf7c2a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/e0/fc/1d785078eefd6945f3e5bab5c076e4230698046231eb0f3747bc5c8fa992/uvicorn-0.32.0.tar.gz"
    sha256 "f78b36b143c16f54ccdb8190d0a26b5f1901fe5a3c777e1ab29f26391af8551e"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c8/27/2ba23c8cc85796e2d41976439b08d52f691655fdb9401362099502d1f0cf/watchfiles-0.24.0.tar.gz"
    sha256 "afb72325b74fa7a428c009c1b8be4b4d7c2afedafb2982827ef2156646df2fe1"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "www-authenticate" do
    url "https://files.pythonhosted.org/packages/a7/2d/5567291a8274ef5d9b6495a1ec341394ab68933e2396936755b157f87b43/www-authenticate-0.9.2.tar.gz"
    sha256 "cf75fc2ea5effb0f9342d7de7619b736f2a7d4b223331a53e296863a286e9dcb"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/52/e9766cc6c2eab7dd1e9749c52c9879317500b46fb97d4105223f86679f93/yarl-1.16.0.tar.gz"
    sha256 "b6f687ced5510a9a2474bbae96a4352e5ace5fa34dc44a217b0537fec1db00b4"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/54/bf/5c0000c44ebc80123ecbdddba1f5dcd94a5ada602a9c225d84b5aaa55e86/zipp-3.20.2.tar.gz"
    sha256 "bc9eb26f4506fda01b81bcde0ca78103b6e62f991b381fec825435c836edbc29"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    expected = "No default project, specify project name"
    assert_match expected, shell_output("#{bin}/dstack init 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/dstack --version")
  end
end
