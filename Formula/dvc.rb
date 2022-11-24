class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/7c/d3/7db216a07eb36b322f485c0a40d5b1b1533e6907a843610010ede5bfef05/dvc-2.35.1.tar.gz"
  sha256 "99bfdde5f348f5717e7fcf84cecf22cc6010bc6530eac0777f926698a10bba2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f483bdd95151de8873f440307d20d5114c750f807e03332d228af811cd94aaea"
    sha256 cellar: :any,                 arm64_monterey: "fd65e04997524cad6eb650df5be3c8b61afe6a80e00143c7598e61c1a25f5a21"
    sha256 cellar: :any,                 arm64_big_sur:  "c647752ee11d0e77b08dde6ad674c5713c7c24f5d8dbf0dc921ee3d297858179"
    sha256 cellar: :any,                 monterey:       "0aaa375326b75fa3c80d1e45ff1345dd82ce9982a9c31241b262bdd49d52ec98"
    sha256 cellar: :any,                 big_sur:        "97df3bd93e6b4f1d41f16d60c653778f4560b43a11a960a4695f9595eed918a0"
    sha256 cellar: :any,                 catalina:       "5350d7f6880b36ad72a19043ff5059ef7181f8bd4e3cc2f982dcafb1091c982d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e96be9b773aac2402bc3cb08e23d4385eaa81467986750305672a7d12e6e9784"
  end

  depends_on "openjdk" => :build # for hydra-core
  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for cryptography (required by azure deps)
  depends_on "apache-arrow"
  depends_on "libgit2"
  depends_on "libpython-tabulate"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/2d/5a/90fcb46d2a1d1ecd1396b20f9cf51bbf6f826a2568410db8c75a07d350dc/adlfs-2022.11.1.tar.gz"
    sha256 "ef2200244f7c4dd694bdb7e9ef346082250edb230dc2e43ebd00d3888b7ddf30"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/14/f1/61f49b9625eb15fc4f37b106d11dadaa6137f8135c2d0f77680e365ceef7/aiobotocore-2.4.0.tar.gz"
    sha256 "f9fe0698cc497861bdb54cd16161c804031f758ada9480c35540f20c0c078385"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ff/4f/62d9859b7d4e6dc32feda67815c5f5ab4421e6909e48cbc970b6a40d60b7/aiohttp-3.8.3.tar.gz"
    sha256 "3828fb41b7203176b82fe5d699e0d845435f2374750a44b480ea6b930f6be269"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/01/c1/d57818a0ed5b0313ad8c620638225ddd44094d0d606ee33f3df5105572cd/aiohttp_retry-2.8.3.tar.gz"
    sha256 "9a8e637e31682ad36e1ff9f8bcba912fcfc7d7041722bc901a4b948da4d71ea9"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/4a/e6/888e1d726f0846c84e14a0f2f57873819eff9278b394d632aed979c98fbd/aioitertools-0.11.0.tar.gz"
    sha256 "42c68b8dd3a69c2bf7f2233bf7df4bb58b557bca5252ac02ed5187bbc67d6831"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/55/5a/6eec6c6e78817e5ca2afee661f2bbb33dbcfa2ce09a2980b52223323bd2e/aliyun-python-sdk-core-2.13.36.tar.gz"
    sha256 "20bd54984fa316da700c7f355a51ab0b816690e2a0fcefb7b5ef013fed0da928"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/d5/6f/648401212f41c91f8aeb7676d57c2840ed258cca64854a9315c2280b15df/aliyun-python-sdk-kms-2.16.0.tar.gz"
    sha256 "a7f185772c88f3a0dda856b666dda436d82e00f9f11ea5bbf12dcab2610ee358"
  end

  resource "amqp" do
    url "https://files.pythonhosted.org/packages/cb/e7/bcaab89065e17915a28247fa5d4f582ca107b4544e2b1aba92d32f794a0f/amqp-5.1.1.tar.gz"
    sha256 "2c1b13fecc0893e946c65cbd5f36427861cffa4ea2201d8f6fca22e2a373b5e2"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/8b/94/6928d4345f2bc1beecbff03325cad43d320717f51ab74ab5a571324f4f5a/anyio-3.6.2.tar.gz"
    sha256 "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/3e/51/647552e03b9eb73d0a456c8c01dc97ea0a1aa810288ceb2eb50eb521ba2d/asyncssh-2.12.0.tar.gz"
    sha256 "274101322c4b941823aeed8e1ab6e7be5191686c6db2d2bd35afeba30505e780"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/8e/9a/ff8783e9e181ead59ae612a5df5bcd4f4bb3cc4147ef6aaa96f90020347b/atpublic-3.1.1.tar.gz"
    sha256 "3098ee12d0107cc5009d61f4e80e5edcfac4cda2bdaa04644af75827cb121b18"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/4f/ec/3ba46ff4deebe738b7213997fc856553282e971a767b6291e05aca9d9566/azure-core-1.26.1.zip"
    sha256 "223b0e90cbdd1f03c41b195b03239899843f20d00964dbb85e64386873414a2d"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/fa/d7/a7402d68d1975d869ce3ba7b6e11983310c12ff8793f0ebf01cd7ca1f398/azure-identity-1.12.0.zip"
    sha256 "7f9b1ae7d97ea7af3f38dd09305e19ab81a1e16ab66ea186b6579d85c1ca2347"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/e8/72/a834f1a89f8b66e717d7cddc88ff182fb860130c4ff78f87a286eec602be/azure-storage-blob-12.14.1.zip"
    sha256 "860d4d82985a4bfc7d3271e71275af330f54f330a754355435a7ba749ccde997"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/92/91/40de1901da8ec9eeb7c6a22143ba5d55d8aaa790761ca31342cedcd5c793/billiard-3.6.4.0.tar.gz"
    sha256 "299de5a8da28a783d51b197d496bef4f1595dd023a93a4f59dde1886ae905547"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/3f/3b/eac5f57a495da702f34eb7c1f34a325d122c4e2f9ffd99bac5eddf7ddbd1/boto3-1.24.59.tar.gz"
    sha256 "a50b4323f9579cfe22fcf5531fbd40b567d4d74c1adce06aeb5c95fce2a6fb40"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/94/29/b8ef249300edf4584384f725d20db126b6caf6147aac4d02efebca239dce/botocore-1.27.59.tar.gz"
    sha256 "eda4aed6ee719a745d1288eaf1beb12f6f6448ad1fa12f159405db14ba9c92cf"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c2/6f/278225c5a070a18a76f85db5f1238f66476579fa9b04cda3722331dcc90f/cachetools-5.2.0.tar.gz"
    sha256 "6a94c6402995a99c3970cc7e4884bb60b4a8639938157eeed436098bf9831757"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/ce/21/41a0028f6d610987c0839250357c1a00f351790b8a448c2eb323caa719ac/celery-5.2.7.tar.gz"
    sha256 "fafbd82934d30f8a004f81e8f7a062e31413a23d444be8ee3326553915958c6d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/2f/a7/822fbc659be70dcb75a91fb91fec718b653326697d0e9907f4f90114b34f/click-didyoumean-0.3.0.tar.gz"
    sha256 "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "click-repl" do
    url "https://files.pythonhosted.org/packages/60/30/11d3f09eff5ae3627bca79563855035e8d241444520500a3c7914eae6a74/click-repl-0.2.0.tar.gz"
    sha256 "cd12f68d745bf6151210790540b4cb064c7b13e571bc64b6957d98d120dacfd8"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/13/dd/a9608b7aebe5d2dc0c98a4b2090a6b815628efa46cc1c046b89d8cd25f4c/cryptography-38.0.3.tar.gz"
    sha256 "bfbe6ee19615b07a98b1d2287d6a6073f734735b49ee45b11324d85efc4d5cbd"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/61/7b/35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0/dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/c7/34/d23a9bc5b2a84917879b977f00fdb97a7700b186a32bf7b0cf5f29f4c2d9/diskcache-5.4.0.tar.gz"
    sha256 "8879eb8c9b4a2509a5e633d2008634fb2b0b35c2b36192d89655dbde02419644"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/54/96/c7c4149d0b556c2d62f03c0a63a1f7b1ed53babf2a21ef49d8ad86337e5b/dpath-2.0.8.tar.gz"
    sha256 "a3440157ebe80d0a3ad794f1b61c571bef125214800ffdb9afc9424e8250fe9b"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/d1/20/4c2ea55d6547460a93dce9112599953be1c939155eae7a8e11a17c4d0b2c/dulwich-0.20.50.tar.gz"
    sha256 "50a941796b2c675be39be728d540c16b5b7ce77eb9e1b3f855650ece6832d2be"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/29/39/06f8e62d9f5a961eafb5bbeb53aacd902acc70317667fd7272ad29d87eeb/dvc-azure-2.20.5.tar.gz"
    sha256 "85f6cdda4804a8b07970eaf0456434a3ec985bc2cf4dfd1b3e1da364ab373b2c"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/2d/a5/745c0e84972e143d408f4c781d717cf50a9aa36d948677053459aa116f81/dvc-data-0.28.0.tar.gz"
    sha256 "d7ec483d20ee6fd5dbe9f2105352bb37e7858d5fd531361adc25987ff9cab222"
  end

  resource "dvc-gdrive" do
    url "https://files.pythonhosted.org/packages/5f/73/3e9b4defb9dabbeada2a52a20e9310ed793f8e72088072c98960a80084ff/dvc-gdrive-2.19.1.tar.gz"
    sha256 "da2c1dd5dd5eead9d86255d0c749795620932b8598afad461bcf169d50b6fa21"
  end

  resource "dvc-gs" do
    url "https://files.pythonhosted.org/packages/34/59/8c20c4ced7315d138e8bdd3b94bfabca936ce4a9f8d7f789a6138ab377f3/dvc-gs-2.20.0.tar.gz"
    sha256 "17662fff3ee87b359a2dc2351c5721a351b12a42fe9bb29e2a820132201cd237"
  end

  resource "dvc-hdfs" do
    url "https://files.pythonhosted.org/packages/d0/26/3459a96fb90c2f2e9edaa2d13f57051eb7bbb5d0d0c9dded8531a0ce43df/dvc-hdfs-2.19.0.tar.gz"
    sha256 "bce4b5a3633d018e795d196227714f30bdd701ac5f4c2a627f731b74d43f4aee"
  end

  resource "dvc-http" do
    url "https://files.pythonhosted.org/packages/17/42/0099a0c68c6f4bedc5876ec1f8119ded885b3aa201a748a532572a710521/dvc-http-2.27.2.tar.gz"
    sha256 "242bed287ba1055b7a59eb7931023f2b617b8e670330fbee52312d7b31eb4b44"
  end

  resource "dvc-objects" do
    url "https://files.pythonhosted.org/packages/70/8f/e8f8330bf7b20f429483e28522c85f6672f56af00f0f4180d9574c821a86/dvc-objects-0.14.0.tar.gz"
    sha256 "039b7be98f4c8325bd90e2869072e3a776bf8e27419723b459704d7cd984e11f"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/a9/76/1f612a3e4c9c734ae8fa091cb9199c1c2ea1d498415ba1ccbb50ef8d6805/dvc-oss-2.19.0.tar.gz"
    sha256 "0927f3b0346a59fd31685ecbda2d6f099b74b3def7d574a6af23992ef3851b4b"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/b1/83/5e80c36c484108bae79159eefb17c185a4c97ecd67d334355951f2928fc3/dvc-render-0.0.14.tar.gz"
    sha256 "9b0d90138a27ec7bc9de0940ea243c915b8f34ab6cb913be27cb4d641ca99514"
  end

  resource "dvc-s3" do
    url "https://files.pythonhosted.org/packages/cf/09/0575ee27b864fec363014d6f1032839a3d73413e48a698cd0eae793f5065/dvc-s3-2.21.0.tar.gz"
    sha256 "004079372a7a8fb997d00380d2b85e81de2af313ff3cec7d27aca7d4fa6ed279"
  end

  resource "dvc-ssh" do
    url "https://files.pythonhosted.org/packages/b5/e7/e47c458ff7a98b4a89ce11c23ea128b96f6bc42eb9f715201a3dd14fc86a/dvc-ssh-2.20.0.tar.gz"
    sha256 "47b06bba9ac2c39c509b6139856a169d52f5260d8fc6dbcdbb1a46683f1cc45b"
  end

  resource "dvc-task" do
    url "https://files.pythonhosted.org/packages/9f/db/4f1639dcb745af90a281aa049f8985f190886fa920a7ffeeec927635b9e0/dvc-task-0.1.6.tar.gz"
    sha256 "2013637c1b0c4504a7082da0f7779f8f4650b2532c4dbba9b1a666a6c28a17f5"
  end

  resource "dvc-webdav" do
    url "https://files.pythonhosted.org/packages/dc/89/76a5782ed61ebf802190f76178488308697fd68fa58b998d8f3e9c04ad16/dvc-webdav-2.19.0.tar.gz"
    sha256 "d44977617ef4bffb5bc8e783fac5af0a1eb592cfef9d1d7c56cd28f0e3da05a5"
  end

  resource "dvc-webhdfs" do
    url "https://files.pythonhosted.org/packages/d2/a4/f975f7ebac05fe70b3fc2621a30958d330b827fc8814c6a6ca388f503cf3/dvc-webhdfs-2.19.0.tar.gz"
    sha256 "fc438e40fe9c0b5cc213c0b0f8767f5bd5025397bc58fc61b097f86ae0028ff9"
  end

  resource "dvclive" do
    url "https://files.pythonhosted.org/packages/c1/6c/81687f3b3f203c08154d6b097f932fa1f9ebd3e3ff4440f261a607672da1/dvclive-1.0.1.tar.gz"
    sha256 "e0aff1d22c27694cf9ad1155508b7b18ab09f9935cd2bd495a7569bcfaa44e8a"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/89/c6/5fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3/flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl.lock" do
    url "https://files.pythonhosted.org/packages/35/33/d3baecd2545b9ae842f4df356aaa4a1816191eff737264542e9d27c5ec3b/flufl.lock-7.1.1.tar.gz"
    sha256 "af14172b35bbc58687bd06b70d1693fd8d48cbf0ffde7e51a618c148ae24042d"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/44/7c/fb753d18e2eeb186a47ecd6939326f7633a027fe23a44ee7912978e64819/fsspec-2022.11.0.tar.gz"
    sha256 "259d5fd5c8e756ff2ea72f42e7613c32667dc2049a4ac3d84364a7ca034acb8b"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/2d/0d/65e6824020a10fee9ea07ec2e4a1527249c1cbf04486e0dfe2a71604b7d2/funcy-1.17.tar.gz"
    sha256 "40b9b9a88141ae6a174df1a95861f2b82f2fdc17669080788b73a3ed9370e968"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/9d/f1/79834a15a341c42ddca882b5dcf06295890faf43d8277aaa458fdbc5e27e/gcsfs-2022.11.0.tar.gz"
    sha256 "84d0caada7097e357d735d7e16e8064f0819d28746101d6f65ff42938557e831"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/22/ab/3dd8b8a24399cee9c903d5f7600d20e8703d48904020f46f7fa5ac5474e9/GitPython-3.1.29.tar.gz"
    sha256 "cc36bfc4a3f913e66805a28e84703e419d9c264c1077e537b54f0e1af85dbefd"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/fe/d6/5dd223fc5cb476ab62966849f3e6466056799dbfc005d74da800eb097f7d/google-api-core-2.10.2.tar.gz"
    sha256 "10c06f7739fe57781f87523375e8e1a3a4674bf6392cd6131a3222182b971320"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/b8/ca/4fcfeb70d90f70f9784e10b79f6db41463278e5e4acef00606b8ef4e9bbb/google-api-python-client-2.66.0.tar.gz"
    sha256 "4cfaf0205aa7c538c8fb1772368be3d049dfed7886adf48597e9a766e9828a6e"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/89/e3/b9002efddfc812af8afd59577ed04432cd3bfcc9c46e0210f3a1b56dfe4c/google-auth-2.14.1.tar.gz"
    sha256 "ccaa901f31ad5cbb562615eb8b664b3dd0bf5404a67618e642307f00613eda4d"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/fb/d1/afcdd1611dc768ed3757a021a6e9410275ae27c6b26b84623bc0f9f706dc/google-auth-oauthlib-0.7.1.tar.gz"
    sha256 "9940f543f77d1447432a93781d7c931fb53e418023351ad4bf9e92837a1154ec"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/40/4b/f4cebb92fe965f02f4a9c06f16355cf83a61a2d5db110df9af71191c830a/google-cloud-core-2.3.2.tar.gz"
    sha256 "b9529ee7047fd8d4bf4a2182de619154240df17fbe60ead399078c1ae152af9a"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/93/ad/2841b47923ea0f7edf44afdca9d61d47dbb521698185225878468710457e/google-cloud-storage-2.6.0.tar.gz"
    sha256 "104ca28ae61243b637f2f01455cc8a05e8f15a2a18ced96cb587241cdd3820f5"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/d3/a5/4bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352/google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/71/d2/d681d0c192d2948b692f155bc20ee03727ab3a70d541b0c39a327c9689a9/google-resumable-media-2.4.0.tar.gz"
    sha256 "8d5518502f92b9ecc84ac46779bd4f09694ecb3ba38a3e7ca737a86d15cbca1f"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/c5/db/9b98c3a9e148b5daaa2e26ce4faeb6ade28dc623dcc109f2ac7efee514de/googleapis-common-protos-1.57.0.tar.gz"
    sha256 "27a849d6205838fb6cc3c1c21cb9800707a661bb21c6ce7fb13e99eb1f8a0c46"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/a2/3f/df0618a962a1744e932f2a4547cb786f5a93df7e2476c99e7f7dbd68039f/grandalf-0.6.tar.gz"
    sha256 "7471db231bd7338bc0035b16edf0dc0c900c82d23060f4b4d0c4304caedda6e4"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/f9/1a/a2652d94e901308c33b9f17c329b0d327da73b30678a6618d4256a3ac2ae/httpcore-0.16.1.tar.gz"
    sha256 "3d3143ff5e1656a5740ea2f0c167e8e9d48c5a9bbd7f00ad1f8cff5711b08543"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c2/37/a093aaa902f6b2301f0f2cff5285548dbc4ab9b9a29215eb440381cbb32b/httplib2-0.21.0.tar.gz"
    sha256 "fc144f091c7286b82bec71bdbd9b27323ba709cc612568d3000893bfd9cb4b34"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/8a/df/a3e8b91dfb452e645ef110985a30f0915276a1a2144004c7671c07bb203c/httpx-0.23.1.tar.gz"
    sha256 "202ae15319be24efe9a8bd4ed4360e68fde7b38bcc2ce87088d416f026667d19"
  end

  # dont use pypi artifact, has some installation issue
  resource "hydra-core" do
    url "https://github.com/facebookresearch/hydra/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "19b203fc614426cd6e4bb7c51e73a25a1ceb4606450ec0203345aec67a0a4f6a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "iterative-telemetry" do
    url "https://files.pythonhosted.org/packages/9d/39/15fc32f1ba9b3c3d0ffdeca9a3abb26778ea4dda94ca256c2f84d632f40e/iterative-telemetry-0.0.6.tar.gz"
    sha256 "721bc0bfa962eb4d80877d5a4e04c758881ea7e7e7529a3f0e9bfd7e829365e2"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/14/60/960f3b4a7ce4ef2b5599372d4b5a08db96625a66e59c705f0878b3e47e69/knack-0.10.0.tar.gz"
    sha256 "13190fa95d4c21bce04b4bee22d6a4e3fb19a93b6999b1d104bd02c476706c28"
  end

  resource "kombu" do
    url "https://files.pythonhosted.org/packages/e1/9e/3811be7d86ac3be6d1a1f5098f95b1d8e2519c12c537719c7e13c8a12800/kombu-5.2.4.tar.gz"
    sha256 "37cee3ee725f94ea8bb173eaab7c1760203ea53bbebae226328600f9d2799610"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/c5/f8/05c343f2652b5b32f063bc908f428ffd14da65939d96b7adc48986f242a8/msal-1.20.0.tar.gz"
    sha256 "78344cd4c91d6134a593b5e3e45541e666e37b747ff8a6316c3668dd1e6ab6b2"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/fa/a7/71c253cdb8a1528802bac7503bf82fe674367e4055b09c28846fdfa4ab90/multidict-6.0.2.tar.gz"
    sha256 "5ff3bd75f38e4c43f1f470f2df7a4d430b821c4ce22be384e1459cb57d6bb013"
  end

  resource "nanotime" do
    url "https://files.pythonhosted.org/packages/d5/54/6d5924f59cf671326e7809f4b3f70fa8df535d67e952ad0b6fea02f52faf/nanotime-0.5.2.tar.gz"
    sha256 "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/cd/16/c44e8550012735b8f21b3df7f39e8ba5a987fb764ac017ad5f3589735889/networkx-2.8.8.tar.gz"
    sha256 "230d388117af870fce5647a3c52401fcf753e94720e6ea6b4197a5355648885e"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "omegaconf" do
    url "https://files.pythonhosted.org/packages/37/75/38ad9c93c61c0635dc19b6d5cacf1a78b1a6990ff557d1192296161f459e/omegaconf-2.2.3.tar.gz"
    sha256 "59ff9fba864ffbb5fb710b64e8a9ba37c68fa339a2e2bb4f1b648d6901552523"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/7a/d2/33b2607395c625f685c9e225d94fa2f56a4debabfe53b9b00c9eaed22f6d/oss2-2.16.0.tar.gz"
    sha256 "a08ca287dbadb19767a204297540c185f5ccccad7ef6f9ca3a180f77b6dc8376"
  end

  resource "ossfs" do
    url "https://files.pythonhosted.org/packages/75/46/3bf84cb604b5bb32476c934952d157f0e38b5a518924bef9bb4a74c547d2/ossfs-2021.8.0.tar.gz"
    sha256 "169080ca8fcf6e16ea7a65d4b6ac63a9968b02473341e31c8c21e77dfbc46432"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/a6/5c/57ef8091f9f1d01bf5413fcd0fd1f2f255f45536e42bfd34bc45b6cc2786/portalocker-2.6.0.tar.gz"
    sha256 "964f6830fb42a74b5d32bce99ed37d8308c1d7d44ddf18f3dd89f4680de97b39"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c4/6e/6ff7938f47981305a801a4c5b8d8ed282b58a28c01c394d43c1fbcfc810b/prompt_toolkit-3.0.33.tar.gz"
    sha256 "535c29c31216c77302877d5120aef6c94ff573748a5b5ca5b1b1f76f5e700c73"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/11/e4/a8e8056a59c39f8c9ddd11d3bc3e1a67493abe746df727e531f66ecede9e/pycryptodome-3.15.0.tar.gz"
    sha256 "9135dddad504592bcc18b0d2d95ce86c3a5ea87ec6447ef25cfedea12d6018b8"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "PyDrive2" do
    url "https://files.pythonhosted.org/packages/05/e8/4d227db64308b3ccc81e7ef5df2432c4b97ecc835b9f291fd07f5be93c58/PyDrive2-1.15.0.tar.gz"
    sha256 "3ae06b66bf963f43524989c87f4d678039441fe059993c6703fb33cc3c6d8aec"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/43/9a/f4375f39d2de971750a7c16bd7ab9cc53368f395edaac59b32e9b3f62ce9/pygit2-1.11.1.tar.gz"
    sha256 "793f583fd33620f0ac38376db0f57768ef2922b89b459e75b1ac440377eb64ec"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/b9/13/55deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5f/pygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/75/65/db64904a7f23e12dbf0565b53de01db04d848a497c6c9b87e102f74c9304/PyJWT-2.6.0.tar.gz"
    sha256 "69285c7e31fc44f68a1feb309e948e0df53259d579295e6cfe2b1792329f05fd"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/e7/2f/c6d89edac75482f11e231b644e365d31d5479b7b727734e6a8f3d00decd5/pyOpenSSL-22.1.0.tar.gz"
    sha256 "7a83b7b272dd595222d672f5ce29aa030f1fb837630ef229f62e72e395ce8968"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/ac/cf/a3e7af8c267cfe138cb5a12eb0608134d485b1e217e742de624466a04487/s3fs-2022.11.0.tar.gz"
    sha256 "10c5ac283a4f5b67ffad6d1f25ff7ee026142750c5c5dc868746cd904f617c33"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/cb/64/f883b842dcc8a0c5b9a874b88a083310a4e90830d81d144206f3465901bb/scmrepo-0.1.3.tar.gz"
    sha256 "9ae20c2dc32a588215bb9b76040129cec68e2ef51b06cda48cdc32df15575998"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/1e/c6/ba2dd56e3996a1919984645ca0aaf20c4879cc1227c50a4be08f52b19ad0/shortuuid-1.0.11.tar.gz"
    sha256 "fc75f2615914815a8e4cb1501b3a513745cb66ef0fd5fc6fb9f8c3fa3481f789"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/3c/4c/7d8363edcd34b5fb6d5fd24be8224cdae2de39bc558a84394655822b0ef3/shtab-1.5.8.tar.gz"
    sha256 "1f944e2e33c1554be69e6b26ef638ba3b516ac9449fdd2a40d197f9061c8bed8"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/35/61/7cd80d9add4dec01e7518527290c371244aa2012fbef7f02aac210898a14/sshfs-2022.6.0.tar.gz"
    sha256 "700b78a6af6952b4333474bdb55729a0d1949acf0157a3cb6d7b50221166b26e"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "vine" do
    url "https://files.pythonhosted.org/packages/66/b2/8954108816865edf2b1e0d24f3c2c11dfd7232f795bcf1e4164fb8ee5e15/vine-5.0.0.tar.gz"
    sha256 "7d3b1624a953da82ef63462013bbd271d3eb75751489f9807598e8f340bd637e"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/72/0c/0ed7352eeb7bd3d53d2c0ae87fa1e222170f53815b8df7d9cdce7ffedec0/voluptuous-0.13.1.tar.gz"
    sha256 "e8d31c20601d6773cb14d4c0f42aee29c6821bbd1018039aac7ac5605b489723"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "webdav4" do
    url "https://files.pythonhosted.org/packages/be/cc/172a99d6bee59597063e8a920ca5c7aeeced8f624453110490deba46819b/webdav4-0.9.8.tar.gz"
    sha256 "fc7748df33a375de13ddb5f4594f5799f9f3dc13c005b7b9c45c120aad745694"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/d6/04/255c68974ec47fa754564c4abba8f61f9ed68b869bbbb854198d6259c4f7/yarl-1.8.1.tar.gz"
    sha256 "af887845b8c2e060eb5605ff72b6f2dd2aab7a761379373fd89d314f4752abbf"
  end

  resource "zc.lockfile" do
    url "https://files.pythonhosted.org/packages/11/98/f21922d501ab29d62665e7460c94f5ed485fd9d8348c126697947643a881/zc.lockfile-2.0.tar.gz"
    sha256 "307ad78227e48be260e64896ec8886edc7eae22d8ec53e4d528ab5537a83203b"
  end

  def install
    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.write("dvc/utils/build.py", "PKG = \"brew\"")

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dvc", "completion", "-s", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/dvc doctor 2>&1")
    assert_match "gdrive", output
    assert_match "gs", output
    assert_match "http", output
    assert_match "https", output
    assert_match "oss", output
    assert_match "s3", output
    assert_match "ssh", output
    assert_match "webdav", output
    assert_match "webdavs", output
    assert_match "webhdfs", output
  end
end
