class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/d4/7e/e623a2328deabc9cdaaaf875f95863cc816a5ae90b57593236782cef19dc/dvc-2.30.0.tar.gz"
  sha256 "2af62652c2b2f040629dde379c73fc2d99e62fa9dce640c5c43153b1ad1b54a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a877162134448e18fb549441de6e2cc419c50eee19840f6c7b17530e7af2c805"
    sha256 cellar: :any,                 arm64_big_sur:  "830427100cec9bdf2be0381f8ec8ee3344a45c23c153089c4cdc5f904000f889"
    sha256 cellar: :any,                 monterey:       "f97ce721866fceaabe5b8a6edc27f34fba17903af01f44ca04d25c7346850303"
    sha256 cellar: :any,                 big_sur:        "9f0510fc48b0421a66ad5ef470640bff8ced9a68fa1847a355523519862de0d6"
    sha256 cellar: :any,                 catalina:       "80da3f16519d33a9ed5f84a1df56c1f82bddc4f92fcd6af6f95aeec4651775f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f20fbd7eedd3ffa30842ffc1f49dd5429b415b9911d45b255796b86a363cdedf"
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
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/67/13/7b57e13f06393caeec97fb9930a1c59a9e2015d8d2afe7e0be50854737a1/adlfs-2022.10.0.tar.gz"
    sha256 "8542f9e6799aeb77adb5cb9854f76b7dce874610dc0f2ff006cce960526ffad6"
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
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
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
    url "https://files.pythonhosted.org/packages/67/c4/fd50bbb2fb72532a4b778562e28ba581da15067cfb2537dbd3a2e64689c1/anyio-3.6.1.tar.gz"
    sha256 "413adf95f93886e442aea925f3ee43baa5a765a64a0f52c6081894f9992fdd0b"
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
    url "https://files.pythonhosted.org/packages/ee/ab/05f2bf8699aad4c3eb29c1702cc1784c106816cc07bf8ac43abad9496a9d/azure-core-1.26.0.zip"
    sha256 "b0036a0d256329e08d1278dff7df36be30031d2ec9b16c691bc61e4732f71fe0"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/13/8b/2c151c9f4c3f5345d9a32889e15a471d98e426851b9fcf13dc9f134f5b93/azure-datalake-store-0.0.52.tar.gz"
    sha256 "4198ddb32614d16d4502b43d5c9739f81432b7e0e4d75d30e05149fe6007fea2"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/20/e8/576ae0ff02631cd395158bc79f2b9c7df2c91e69c5d9c2455cb3da9bd532/azure-identity-1.11.0.zip"
    sha256 "c3fc800af58b857e7faf0e310376e5ef10f5dad5090914cc42ffa6d7d23b6729"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/11/34/56b2b9a9375cce367a28ab1ad389aebce4a142bc106a79ec4849d9c28ab1/azure-storage-blob-12.13.1.zip"
    sha256 "899c4b8e2671812d2cf78f107556a27dbb128caaa2bb06094e72a3d5836740af"
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
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
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
    url "https://files.pythonhosted.org/packages/6d/0c/5e67831007ba6cd7e52c4095f053cf45c357739b0a7c46a45ddd50049019/cryptography-38.0.1.tar.gz"
    sha256 "1db3d807a14931fa317f96435695d9ec386be7b84b618cc61cfa5d08b0ae33d7"
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
    url "https://files.pythonhosted.org/packages/a0/cf/cf35f8b7f212be18634970a5b2d7a50adc715e649a0a8fedb06c909603d8/dpath-2.0.6.tar.gz"
    sha256 "5a1ddae52233fbc8ef81b15fb85073a81126bb43698d3f3a1b6aaf561a46cdc0"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/4c/61/85f17dd9e744e027d23bee2bbafc8438fab26c175a089b1a06b664deae21/dulwich-0.20.46.tar.gz"
    sha256 "4f0e88ffff5db1523d93d92f1525fe5fa161318ffbaad502c1b9b3be7a067172"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/18/47/0301c19cdff7d4cfd3d2bb5253ff0d21225c468bba62dd35f08d488526c3/dvc-azure-2.20.4.tar.gz"
    sha256 "e722b01bd43e61c49822f6c494e3456ce52f3517ade68104376eaff49621cb48"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/c3/b5/a9a6090e8580867951b8c210613a9007db8063405de3e72ad39aeadc4bed/dvc-data-0.17.1.tar.gz"
    sha256 "bb50e3fd8d2f24d29536e53e6b9811c93fa6013bbe8d8d35b26856e745d15fb2"
  end

  resource "dvc-gdrive" do
    url "https://files.pythonhosted.org/packages/d2/40/764837f7bb606fe795a9dbedb2eded16170d0ff75bc9f808ce405eecd6c8/dvc-gdrive-2.19.0.tar.gz"
    sha256 "9fe1ec52f31822df37a56fb06f7eb696a936294145a16ab0498c664f17fa0f1a"
  end

  resource "dvc-gs" do
    url "https://files.pythonhosted.org/packages/6d/c3/69c30360e8bb8e31119ea90acb747e8f722c2f2395eb028754b633fbb822/dvc-gs-2.19.1.tar.gz"
    sha256 "c88f86c93d789cb880982cc3bdc00db619660f18760a3abdfb40f90233a87b41"
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
    url "https://files.pythonhosted.org/packages/92/f2/e019c41212a83ab63ff7d08a14f8719faf55a042ba5e6cf29d1c2fa26ca5/dvc-objects-0.7.0.tar.gz"
    sha256 "58c09163324bca8ccf385c0839f6aae041d7a319253928efc722a9e074606702"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/a9/76/1f612a3e4c9c734ae8fa091cb9199c1c2ea1d498415ba1ccbb50ef8d6805/dvc-oss-2.19.0.tar.gz"
    sha256 "0927f3b0346a59fd31685ecbda2d6f099b74b3def7d574a6af23992ef3851b4b"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/05/0a/7897ba4df80dbf7a77039ad666e8d4ec062e65436b980d0605b15a6b1759/dvc-render-0.0.12.tar.gz"
    sha256 "faf331a37f0f3999284e2c7d16d76a51d073b93156bed145f32d0215c699d26f"
  end

  resource "dvc-s3" do
    url "https://files.pythonhosted.org/packages/31/cc/c3a7f8234855fcdafd5e6600010fe92edb588c683eb1113b4438d4625b94/dvc-s3-2.20.1.tar.gz"
    sha256 "e4e9b3bfda0a3d6b4d699df42f33daedff4f54b4f0917daef0a0725de6e674ab"
  end

  resource "dvc-ssh" do
    url "https://files.pythonhosted.org/packages/9f/94/23c97c5f15908a45783e2ba8a6e1b94ae384ce3fce83f565ee756a5ce4d9/dvc-ssh-2.19.0.tar.gz"
    sha256 "78b1dfc6606d782493218194b6405564a8f34e0aaf05e5cea22ae6a9c8d99488"
  end

  resource "dvc-task" do
    url "https://files.pythonhosted.org/packages/f5/90/cc03445113ce60e78b244d857125fb3bb5eba3a8ba3901050f68f4776e9e/dvc-task-0.1.3.tar.gz"
    sha256 "1670cf7dedfe4ff80a19b0b1768bfa8ef708374f50278575c6be99047a1dda43"
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
    url "https://files.pythonhosted.org/packages/24/31/572a76495ca0447daa562dc71d40a73a2f0d845b6fa8de080ba7bc089785/dvclive-0.12.0.tar.gz"
    sha256 "ca4538629f2cfde4c371adf6b03f660334bcef311d077185e7c9be38b7d314a6"
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
    url "https://files.pythonhosted.org/packages/8a/95/229aacfe85daa28e2792481a98c336bc30d3729533e6a44db537880aca21/frozenlist-1.3.1.tar.gz"
    sha256 "3a735e4211a04ccfa3f4833547acdf5d2f863bfeb01cfd3edaffbc251f15cec8"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/19/4b/c755522aed160cbe69dc6c1f9e1641d39947e2ba3d6994c2e19b446b5594/fsspec-2022.8.2.tar.gz"
    sha256 "7f12b90964a98a7e921d27fb36be536ea036b73bf3b724ac0b0bd7b8e39c7c18"
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
    url "https://files.pythonhosted.org/packages/95/1c/d52b8c152dcf74ebb6e3d30d156b05ba83d79cf112afbb4408ad3d32da65/gcsfs-2022.8.2.tar.gz"
    sha256 "23380fe0ae7036da88f4bd1687b737a5e94a34c96d7355abfbd7ff0936a35885"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/1e/2d/6ccc5a2a05a474e7ae7ef7b1372ead9381378c438da4cc3434109b376d82/GitPython-3.1.28.tar.gz"
    sha256 "6bd3451b8271132f099ceeaf581392eaf6c274af74bb06144307870479d0697c"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/fe/d6/5dd223fc5cb476ab62966849f3e6466056799dbfc005d74da800eb097f7d/google-api-core-2.10.2.tar.gz"
    sha256 "10c06f7739fe57781f87523375e8e1a3a4674bf6392cd6131a3222182b971320"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/a7/ff/a8bc30fdbc62ce1b504a878c586c72c9d3308508fca0aa7a7d694ec080da/google-api-python-client-2.64.0.tar.gz"
    sha256 "0dc4c967a5c795e981af01340f1bd22173a986534de968b5456cb208ed6775a6"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/19/dd/48e06d7ce02ebf53a2d36fcada99c68d7f6b10f2058ec4f76f7e2e81d9e6/google-auth-2.12.0.tar.gz"
    sha256 "f12d86502ce0f2c0174e2e70ecc8d36c69593817e67e1d9c5e34489120422e4b"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/f0/d0/3521515d13827eb4c68d3b45972ad49a21b02e486c589fdd3c2aee9b9065/google-auth-oauthlib-0.5.3.tar.gz"
    sha256 "307d21918d61a0741882ad1fd001c67e68ad81206451d05fc4d26f79de56fc90"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/40/4b/f4cebb92fe965f02f4a9c06f16355cf83a61a2d5db110df9af71191c830a/google-cloud-core-2.3.2.tar.gz"
    sha256 "b9529ee7047fd8d4bf4a2182de619154240df17fbe60ead399078c1ae152af9a"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/e0/58/618be066ba3f38b9cc6c8ce0a4b7356707408b80fd80433cd821a108bae2/google-cloud-storage-2.5.0.tar.gz"
    sha256 "382f34b91de2212e3c2e7b40ec079d27ee2e3dbbae99b75b1bcd8c63063ce235"
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
    url "https://files.pythonhosted.org/packages/f0/8e/190b3ac9bc75d6ead661398a07c6d6f013502c364fd6cc3d5c06427b8023/googleapis-common-protos-1.56.4.tar.gz"
    sha256 "c25873c47279387cfdcbdafa36149887901d36202cb645a0e4f29686bf6e4417"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/a2/3f/df0618a962a1744e932f2a4547cb786f5a93df7e2476c99e7f7dbd68039f/grandalf-0.6.tar.gz"
    sha256 "7471db231bd7338bc0035b16edf0dc0c900c82d23060f4b4d0c4304caedda6e4"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/42/98/44c3e51a0655eae75adefee028c9bada7427a90f63105e54f5e735946f50/httpcore-0.15.0.tar.gz"
    sha256 "18b68ab86a3ccf3e7dc0f43598eaddcf472b602aba29f9aa6ab85fe2ada3980b"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/9c/65/57ad964eb8d45cc3d1316ce5ada2632f74e35863a0e57a52398416a182a1/httplib2-0.20.4.tar.gz"
    sha256 "58a98e45b4b1a48273073f905d2961666ecf0fbac4250ea5b47aef259eb5c585"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/43/cd/677173d194b4839e5b196709e3819ffca2a4bc58b0538f4ae4be877ad480/httpx-0.23.0.tar.gz"
    sha256 "f28eac771ec9eb4866d3fb4ab65abd42d38c424739e80c08d8d20570de60b0ef"
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
    url "https://files.pythonhosted.org/packages/87/3b/6faabc9b45c678e9455b84e1cf8c96fbd9743f0f0603711e243fbc62a297/iterative-telemetry-0.0.5.tar.gz"
    sha256 "104dfbee63206ee54d2cb409a2d3d55f2b93d14e06974137cf00e7c24ca0ee74"
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
    url "https://files.pythonhosted.org/packages/9e/89/90846e0da5c412cbffb66d1f976b056cd46c6f2aa7f2f1eb271573b5fefb/networkx-2.8.7.tar.gz"
    sha256 "815383fd52ece0a7024b5fd8408cc13a389ea350cd912178b82eed8b96f82cd3"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fe/58/30a4d3302f9bbd602c43385e7270fc3a9e8a665d07aafd6a4d4baa844739/oauthlib-3.2.1.tar.gz"
    sha256 "1565237372795bf6ee3e5aba5e2a85bd5a65d0e2aa5c628b9a97b7d7a0da3721"
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
    url "https://files.pythonhosted.org/packages/28/b5/ee15a73d2d1e3e4f8ed9cf46b8c590317fa182b5c50ab5149e0c66866f25/portalocker-2.5.1.tar.gz"
    sha256 "ae8e9cc2660da04bf41fa1a0eef7e300bb5e4a5869adfb1a6d8551632b559b2b"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/8f/57/828ac1f70badc691a716e77bfae258ef5db76bb7830109bf4bcf882de020/psutil-5.9.2.tar.gz"
    sha256 "feb861a10b6c3bb00701063b37e4afc754f8217f0f09c42280586bd6ac712b5c"
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
    url "https://files.pythonhosted.org/packages/ca/8c/d7392b8adf61762749afbde7bebf7ae06a4550d05fe030be63e920a13ba6/PyDrive2-1.14.0.tar.gz"
    sha256 "db5da3be671630f571ca7100b281d8b5d72fd078acd425247a6d292e2b3d2840"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/d5/ef/af7272cde1db9fea4a9b4f9c41f2e1fabd45d94a5f1fc84e8928a2a06969/pygit2-1.10.1.tar.gz"
    sha256 "354651bf062c02d1f08041d6fbf1a9b4bf7a93afce65979bdc08bdc65653aa2e"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/b9/13/55deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5f/pygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/d4/63/6f57a751c9e3135856b44e2c29c548741ec14db3d24b9666e97292aa968e/PyJWT-2.5.0.tar.gz"
    sha256 "e77ab89480905d86998442ac5788f35333fa85f65047a534adc38edf3c88fc3b"
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
    url "https://files.pythonhosted.org/packages/31/da/2d48d3499b59c7f3c5d5e1c79fcee5537c320c8ab7b7a0cd2db578bc34b3/pytz-2022.4.tar.gz"
    sha256 "48ce799d83b6f8aab2020e369b627446696619e79645419610b9facd909b3174"
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
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/e4/80/b40ecebbf194d22cee9281595c62c7bc508f58c8e3b3fda73c0ad737f909/s3fs-2022.8.2.tar.gz"
    sha256 "3ca0701a89a9e125a28de90829d19f96f41ddb1d8b4379076c29ed82c4af86cd"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/0e/f3/bc3b99e3747f5a18339412c74c7cd9b2148aaf5bc86efc606aff87fb05c8/scmrepo-0.1.1.tar.gz"
    sha256 "4caca9c325461dcb1e4a79cf4a02c35048cfb75d610d8941abba08d8f1c0925f"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/93/71/026c64b145a306c3b555d69f03d1e9c97d363faa64ddcf9345caf49e213f/shortuuid-1.0.9.tar.gz"
    sha256 "459f12fa1acc34ff213b1371467c0325169645a31ed989e268872339af7563d5"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/63/d1/d202d3824e4901f4d3d704115f093cf5f199427e1873d27fa564b88e3424/shtab-1.5.5.tar.gz"
    sha256 "f90a6ce64b821002d5881b6212992a27ab40c3bab36aabca8de118b0b78f61f6"
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
    url "https://files.pythonhosted.org/packages/0c/2b/7823f215c6aec294f5ab5ff2f529aca1d85e8bec2208ae7ea89ca1413620/tomlkit-0.11.5.tar.gz"
    sha256 "571854ebbb5eac89abcb4a2e47d7ea27b89bf29e09c35395da6f03dd4ae23d1c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "types-cryptography" do
    url "https://files.pythonhosted.org/packages/d4/8e/e3c6436544400cdfbf723c4b47805e72234ade12b05a5279e0745db6e3c7/types-cryptography-3.3.23.tar.gz"
    sha256 "b85c45fd4d3d92e8b18e9a5ee2da84517e8fff658e3ef5755c885b1c2a27c1fe"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
    url "https://files.pythonhosted.org/packages/e9/5e/114db086e62fe8de233c13f155ba5cc46208ec85ce70c9260db0df1a9d0e/webdav4-0.9.7.tar.gz"
    sha256 "352db25e62d82c30bb3e71fdc2e932b2f8394fadb5f7405140aecda4c47c22ee"
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
    assert_match "azure", output
    assert_match "gdrive", output
    assert_match "gs", output
    assert_match "http", output
    assert_match "https", output
    assert_match "s3", output
    assert_match "ssh", output
    assert_match "webdav", output
    assert_match "webdavs", output
  end
end
