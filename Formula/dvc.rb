class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/43/84/2b29a5ef7348221f0ad0ed175ca750b236e7805dace7e75455be1eca4cc2/dvc-2.11.0.tar.gz"
  sha256 "26f5ba2a89a94874a4cc5046835717f8122c6e9adcf7097f5ec93a3a816388a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a2ed3472a21f69116d863403221e9b2738b493954cfaf243d39acd7cd200fb7e"
    sha256 cellar: :any,                 arm64_big_sur:  "08bc702b84888d72115a29cc1e0c3c1f85f412b3a64a73d3f439ac9ff36dd4a0"
    sha256 cellar: :any,                 monterey:       "6a494cec64d12c6a48197d9c210b77a1af390eb388830b945e55951d46e1df57"
    sha256 cellar: :any,                 big_sur:        "7a370f734013b24846419431c24b2607a06189e5412602894024b64eb7e9df5c"
    sha256 cellar: :any,                 catalina:       "c6c891761fe76a4451ed5ce125894a5bab498db13cade5b3b29a261e40506619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf5a843e3b3b7d5ce4c4ba47f6d22d335f64ecbd0ac54ede5d08f40a0418ba2"
  end

  depends_on "pkg-config" => :build
  # for cryptograpy (required by azure deps)
  depends_on "rust" => :build
  depends_on "apache-arrow"
  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/05/c0/63dc8a8cc3892a9dc93432980854e8764dc3c2121562972406acd872c30e/adlfs-2022.4.0.tar.gz"
    sha256 "055806592ab5792296def36470eee1067c8ff6e1176bc054a831510e471c3833"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/54/b7/453119271cc4c36b07fdeab9b0ff25c5fce178f51d270ccf7e05e7bc8177/aiobotocore-2.3.3.tar.gz"
    sha256 "13d403a067e1afc997f756a3107d125ffe964e7213f117f327c62fe763c67e2e"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/5a/86/5f63de7a202550269a617a5d57859a2961f3396ecd1739a70b92224766bc/aiohttp-3.8.1.tar.gz"
    sha256 "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/23/d9/6fcb308129ade81c50a09b3f534880946d46008e9cba727b80a1274dba4b/aiohttp_retry-2.4.6.tar.gz"
    sha256 "288c1a0d93b4b3ad92910c56a0326c6b055c7e1345027b26f173ac18594a97da"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/c2/9c/36180745f894257a50b1473fa348daf996b959d66f5985bbc868e44ef3ee/aioitertools-0.10.0.tar.gz"
    sha256 "7d1d1d4a03d462c5a0840787d3df098f125847e0d38b833b30f8f8cbc45a1420"
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
    url "https://files.pythonhosted.org/packages/31/8d/5052612578e9237ff5b2c398fe33fa52541ed53f741143893fb8f5f27120/aliyun-python-sdk-kms-2.15.0.tar.gz"
    sha256 "642a3f4f04dcdba5f8a3a0f1edff04479e76df33017a5b25512490ce5894ab2d"
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
    url "https://files.pythonhosted.org/packages/f7/23/9fd49843fed8dbca100070fa169fb3d99e9e82d06894ef2ae85ea39b4e6a/asyncssh-2.11.0.tar.gz"
    sha256 "59c36ce77ba9dda8dd57ad875776e7105ddb1fa851bc039bb3aeadeac4f67b56"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/a0/62/0d20716e53e9996c591051e6b76c3e51229c26e017f82a112c3eddf207df/atpublic-3.0.1.tar.gz"
    sha256 "bb072b50e6484490404e5cb4034e782aaa339fdd6ac36434e53c10791aef18bf"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/f0/b1/b16df381dcf33180b57b5c87b7c478725e64bf3cfb85a92c254cd611c8d4/azure-core-1.24.1.zip"
    sha256 "39c5d59d04209bb70a1a7ee879cef05d07bc76472cd3fb5eaa2e607a90d312bb"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/13/8b/2c151c9f4c3f5345d9a32889e15a471d98e426851b9fcf13dc9f134f5b93/azure-datalake-store-0.0.52.tar.gz"
    sha256 "4198ddb32614d16d4502b43d5c9739f81432b7e0e4d75d30e05149fe6007fea2"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/56/8b/3e070d67fe75afc6ef14edb506da2dc641d819eee91dc35c448d3fab11e7/azure-identity-1.10.0.zip"
    sha256 "656e5034d9cef297cf9b35376ed620085273c18cfa52cea4a625bf0d5d2d6409"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/5d/15/96067ca458241243b65f95f73f19bea262436f06c8d90a0d73a802923dfa/azure-storage-blob-12.12.0.zip"
    sha256 "f6daf07d1ca86d189ae15c9b1859dff5b7127bf24a07a4bbe41e0b81e01d62f7"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e8/36/edc85ab295ceff724506252b774155eff8a238f13730c8b13badd33ef866/bcrypt-3.2.2.tar.gz"
    sha256 "433c410c2177057705da2a9f2cd01dd157493b2a7ac14c8593a16b3dab6b6bfb"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/08/fe/64c6e7d074ca4368949f82e1c8db236184ba13380c893c3c82fe32292c16/boto3-1.21.21.tar.gz"
    sha256 "6fa0622f308cfd1da758966fc98b52fbd74b80606d14586c8ad82c7a6c4f32d0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/68/56/c4858a29beb127d95cebe5889251fac4e059513c51452c66cb4660d61bee/botocore-1.24.21.tar.gz"
    sha256 "7e976cfd0a61601e74624ef8f5246b40a01f2cce73a011ef29cf80a6e371d0fa"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c2/6f/278225c5a070a18a76f85db5f1238f66476579fa9b04cda3722331dcc90f/cachetools-5.2.0.tar.gz"
    sha256 "6a94c6402995a99c3970cc7e4884bb60b4a8639938157eeed436098bf9831757"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
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
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
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
    url "https://files.pythonhosted.org/packages/b5/7e/ddfbd640ac9a82e60718558a3de7d5988a7d4648385cf00318f60a8b073a/distro-1.7.0.tar.gz"
    sha256 "151aeccf60c216402932b52e40ee477a939f8d58898927378a02abbe852c1c39"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/a0/cf/cf35f8b7f212be18634970a5b2d7a50adc715e649a0a8fedb06c909603d8/dpath-2.0.6.tar.gz"
    sha256 "5a1ddae52233fbc8ef81b15fb85073a81126bb43698d3f3a1b6aaf561a46cdc0"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/c8/19/247ec461430dc3f1785d2b1f7e0cc2957393ace16215d75eb4bd259c0821/dulwich-0.20.43.tar.gz"
    sha256 "fcc2164e013b390a9ee3a109d7ef7b95d8de283b2e789bb07e94aa3115e329ea"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/3b/28/c8f2d2b889a11d8ba2cace5a703fe5ed45149d9fbecf330d0599b426c9f9/dvc-data-0.0.2.tar.gz"
    sha256 "17b67b3457e85eaa436313a69ad858dc282b59495bb02add5d5710c3e349caba"
  end

  resource "dvc-objects" do
    url "https://files.pythonhosted.org/packages/1f/e1/58515839c7060408f2501841307ba0ee6a0099016b19f18d1e44927e3b8a/dvc-objects-0.0.2.tar.gz"
    sha256 "65370e3ea83b4c4b2ad8567ef8aa79b5b4c0fc2b3a4ff6ea2290ca64a65c6fcf"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/c3/df/8dc8cbaf8881d10890a4332b0d0078679883a28439b83c35214c3be608dd/dvc-render-0.0.5.tar.gz"
    sha256 "a864df15152533f3363b62851df06f0e830b9a217ad88ca184b8ecfbaefce485"
  end

  resource "dvclive" do
    url "https://files.pythonhosted.org/packages/46/36/daf6d2f8f55444d1ee933e38f292780a52083fd2bc3b301075c8b492db2a/dvclive-0.8.2.tar.gz"
    sha256 "a6d1a173184e43b78873952887d66251a74976a4a8c80fb812242723ef4cd74e"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/89/c6/5fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3/flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl.lock" do
    url "https://files.pythonhosted.org/packages/52/78/7dedbee8bf42c22d10e0198eca82e3681e2aabc02efa52833702d66440a0/flufl.lock-7.0.tar.gz"
    sha256 "1415f7d19d8dd96a58242e0efb90ce3cb1877fb545074ad8c1cae4cb7191fe01"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/f4/f7/8dfeb76d2a52bcea2b0718427af954ffec98be1d34cd8f282034b3e36829/frozenlist-1.3.0.tar.gz"
    sha256 "ce6f2ba0edb7b0c1d8976565298ad2deba6f8064d2bebb6ffce2ca896eb35b0b"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/a9/fa/a949517ef319f7b19d0f27e102f1831f4d6b7bdd32737374ec4531f636ff/fsspec-2022.5.0.tar.gz"
    sha256 "7a5459c75c44e760fbe6a3ccb1f37e81e023cde7da8ba20401258d877ec483b4"
  end

  resource "ftfy" do
    url "https://files.pythonhosted.org/packages/97/16/79c6e17bd3465f6498282dd23813846c68cd0989fe60bfef68bb1918d041/ftfy-6.1.1.tar.gz"
    sha256 "bfc2019f84fcd851419152320a6375604a0f1459c281b5b199b2cd0d2e727f8f"
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
    url "https://files.pythonhosted.org/packages/2d/9f/28ced03960e6f21940345fd0a4831145aa9392b3da3144c9af4587c434c8/gcsfs-2022.5.0.tar.gz"
    sha256 "c28bbbc8f3fb29656f2379ffb8b2b888b95f44d9a46d8dc746253598d1493bb9"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/b5/b0/54c3b2ef432ebdac603aa064ab2de58194d4699a5dcc06a0b6e1ea80d856/google-api-core-2.8.1.tar.gz"
    sha256 "958024c6aa3460b08f35741231076a4dd9a4c819a6a39d44da9627febe8b28f0"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/67/e0/edf2d40f4eb1080017447a09559d7598139a2996f4e099a101526ab05b75/google-api-python-client-2.50.0.tar.gz"
    sha256 "159aa2d5f67998f39b06f28f38d6621389dda099c56f0fde46e9070dabdd5b40"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/44/f3/4ee51a2f7d1c262e8bac333338479006b556f97ef9622e81c73460ad72a2/google-auth-2.7.0.tar.gz"
    sha256 "8a954960f852d5f19e6af14dd8e75c20159609e85d8db37e4013cc8c3824a7e1"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/14/49/9f23d33e5872446c8162d63f035f222c1d0d74d0fbe00cea9e2538351432/google-auth-oauthlib-0.5.1.tar.gz"
    sha256 "30596b824fc6808fdaca2f048e4998cc40fb4b3599eaea66d28dc7085b36c5b8"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/c3/b0/430438d8c48c8635c9292eaacfeab6d9c53331dfd7b5479abe607076fe57/google-cloud-core-2.3.0.tar.gz"
    sha256 "fdaa629e6174b4177c2d56eb8ab1ddd87661064d0a3e9bb06b62e4d7e2344669"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/27/47/bfa2149125b5fc128b3111943a505e1b7463a7ceb79864f83d9b6c05a1f4/google-cloud-storage-2.3.0.tar.gz"
    sha256 "f4cbb0de5e17228e9c09cdc897d81eaa70e2c396f58513f79de0e824584c8f5b"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/db/de/477cdcfd3ba2877cdf798f0328ea6aa79b2e632d169f5099d6240c4c4ebf/google-crc32c-1.3.0.tar.gz"
    sha256 "276de6273eb074a35bc598f8efbc00c7869c5cf2e29c90748fccc8c898c244df"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/17/d1/74872a664d168c5d38774112d205502847b03f297f3af3199b5e1b126fe9/google-resumable-media-2.3.3.tar.gz"
    sha256 "27c52620bd364d1c8116eaac4ea2afcbfb81ae9139fb3199652fcac1724bfb6c"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/ac/4c/e7d3641f5dc618d4a569647e589675bb65f4b826feaf451a38d12a1aae99/googleapis-common-protos-1.56.2.tar.gz"
    sha256 "b09b56f5463070c2153753ef123f07d2e49235e89148e9b2459ec8ed2f68d7d3"
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

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/da/9c/d04c32ecf37e0ed5a887b30058de4bb817791550462383e3473cc8527309/knack-0.9.0.tar.gz"
    sha256 "7fcab17585c0236885eaef311c01a1e626d84c982aabcac81703afda3f89c81f"
  end

  resource "mailchecker" do
    url "https://files.pythonhosted.org/packages/1a/11/49e85a526dd3f2cb6bdf1dc519d64395bd56a88d9b2a5f6f3acd1f8c3f51/mailchecker-4.1.17.tar.gz"
    sha256 "35f80b238f74ffd6281c85d3543f3dd114defaa3fdaebc0016ff1791cd48639b"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/3d/a5/6e3c0f6de7b49d8e513e5230134240b4f61a2fd67df76fc6257752a33c9f/msal-1.18.0.tar.gz"
    sha256 "576af55866038b60edbcb31d831325a1bd8241ed272186e2832968fd4717d202"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/bd/0c/e6eddc93c19abede6db235bb048bf83ebd8ab7fa31c047992cad33ad8917/msrest-0.7.0.zip"
    sha256 "2210a4dff54c6d3af30bf2fc10db206a1bc5b097c654ce54b0ecd633d762afdf"
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
    url "https://files.pythonhosted.org/packages/4a/e2/1f9d6cf8562cf2bde58c102db70fe48d2d9652ec256f86bab6b279601b0d/networkx-2.8.2.tar.gz"
    sha256 "ae99c9b0d35e5b4a62cf1cfea01e5b3633d8d02f4a0ead69685b6e7de5b85eab"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6e/7e/a43cec8b2df28b6494a865324f0ac4be213cb2edcf1e2a717547a93279b0/oauthlib-3.2.0.tar.gz"
    sha256 "23a8208d75b902797ea29fd31fa80a15ed9dc2c6c16fe73f5d346f83f6fa27a2"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/16/d0/cfe6e199900a97d6e3db55e48ab525c630052e49475722fd20f0f7c7b793/oss2-2.15.0.tar.gz"
    sha256 "d8b5a10ba2291ff4c78246576f243dcec262f1f646344e61f3192dc262e87430"
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

  resource "phonenumbers" do
    url "https://files.pythonhosted.org/packages/30/d0/97ffd2581387702b7007c046c21e4e0195a75c91b6f14d5a747fc8adf807/phonenumbers-8.12.49.tar.gz"
    sha256 "c691661615ebdc90beff458f8fbf7c0bfb78f21a0aa40a256cc2ba6da41e393b"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/dc/60/9646b57d473d38fd23af22f18dce6baa4d591f37024e0c3dcd2d66814d50/portalocker-2.4.0.tar.gz"
    sha256 "a648ad761b8ea27370cb5915350122cd807b820d2193ed5c9cc28f163df637f4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/de/0999ea2562b96d7165812606b18f7169307b60cd378bc29cf3673322c7e9/psutil-5.9.1.tar.gz"
    sha256 "57f1819b5d9e95cdfb0c881a8a5b7d542ed0b7c522d575706a80bedc848c8954"
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
    url "https://files.pythonhosted.org/packages/32/09/41ea2633fea5b973dac9829de871b417ff3ce2963d07fd92e3f2d2a9ee9b/pycryptodome-3.14.1.tar.gz"
    sha256 "e04e40a7f8c1669195536a37979dd87da2c32dbdc73d6fe35f0077b0c17c803b"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "PyDrive2" do
    url "https://files.pythonhosted.org/packages/cf/cd/1be6f5b4f023331b3f2f519cb3452f64cea7307bdfc76641612a3c02c7ea/PyDrive2-1.10.1.tar.gz"
    sha256 "ac29d6da1eff3e5f14d3da0af10ff0bf3d12448427ee4e99d2f8336663455483"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/15/69/95baec94618352fad36a5c53ed1a7a96f7de96d2b36c5ac3fc2a5017b78a/pygit2-1.9.2.tar.gz"
    sha256 "20894433df1146481aacae37e2b0f3bbbfdea026db2f55061170bd9823e40b19"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/a5/8b/90d0f21a27a354e808a73eb0ffb94db990ab11ad1d8b3db3e5196c882cad/pygtrie-2.4.2.tar.gz"
    sha256 "43205559d28863358dbbf25045029f58e2ab357317a59b11f11ade278ac64692"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/d8/6b/6287745054dbcccf75903630346be77d4715c594402cec7c2518032416c2/PyJWT-2.4.0.tar.gz"
    sha256 "d42908208c699b3b973cbeb01a969ba6a96c821eefb1c5bfe4c390c01d67abba"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/35/d3/d6a9610f19d943e198df502ae660c6b5acf84cc3bc421a2aa3c0fb6b21d1/pyOpenSSL-22.0.0.tar.gz"
    sha256 "660b1b1425aac4a1bea1d94168a85d99f0b3144c869dd4390d27629d0087f1bf"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-benedict" do
    url "https://files.pythonhosted.org/packages/9b/8a/a4412ecc1415e871cfce47190676aa086a8eb614552e924a4b5c6fa4d7f3/python-benedict-0.25.1.tar.gz"
    sha256 "9e25e7d4de2d5f8a9c20c74a764d29933bcf5100c1e051c5a9d1418de66a7d0f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-fsutil" do
    url "https://files.pythonhosted.org/packages/a1/73/ccb89ec0e5312b9f379c19a083e1d012ed0cd3f23f6b33396ab35be1e6bc/python-fsutil-0.6.1.tar.gz"
    sha256 "7c6f8f2d203381f6b3ca4130f82bb2ced9860deca9aaa1232636418cfe57b0a9"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/5d/45/915967d7bcc28fd12f36f554e1a64aeca36214f2be9caf87158168b5a575/python-slugify-6.1.2.tar.gz"
    sha256 "272d106cb31ab99b3496ba085e3fea0e9e76dcde967b5e9992500d1f785ce4e1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
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
    url "https://files.pythonhosted.org/packages/f5/f3/f87be42279b5cfba09f7f29e2f4a77063ccf5d9075042981e2cf48752d51/rich-12.4.4.tar.gz"
    sha256 "4c586de507202505346f3e32d1363eb9ed6932f0c2f63184dea88983ff4971e2"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/8c/ee/4022542e0fed77dd6ddade38e1e4dea3299f873b7fd4e6d78319953b0f83/rsa-4.8.tar.gz"
    sha256 "5c6bd9dc7a543b7fe4304a631f8a8a3b674e2bbfc49c2ae96200cdbe55df6b17"
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
    url "https://files.pythonhosted.org/packages/1b/f7/78f4838eccdee56c2108463009216efeefcb60e8c57aaa9863f1cfb7b98a/s3fs-2022.5.0.tar.gz"
    sha256 "b40a3cbfaf80cbabaf0e332331117ccac69290efdac347184fb3ab6003f70465"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/7e/19/f82e4af435a19b28bdbfba63f338ea20a264f4df4beaf8f2ab9bfa34072b/s3transfer-0.5.2.tar.gz"
    sha256 "95c58c194ce657a5f4fb0b9e60a84968c808888aed628cd98ab8771fe1db98ed"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/bf/96/1581e8f40efb93614e7913d688598cff5955c174e89230abccd10412dab7/scmrepo-0.0.24.tar.gz"
    sha256 "8bbe72a3546694febab5fc57a47017c181a96f4a44c00ccd1fd9d5b6fa06246e"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/93/71/026c64b145a306c3b555d69f03d1e9c97d363faa64ddcf9345caf49e213f/shortuuid-1.0.9.tar.gz"
    sha256 "459f12fa1acc34ff213b1371467c0325169645a31ed989e268872339af7563d5"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/a6/74/aac295cee06806a129b025d6af7eb85d4e8d15d3a56687157b92fa209c0b/shtab-1.5.4.tar.gz"
    sha256 "0ef9cfc55e7e3efe83cb8e888cd39c4a2211271c07deade81acdfb1477c79140"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/35/61/7cd80d9add4dec01e7518527290c371244aa2012fbef7f02aac210898a14/sshfs-2022.6.0.tar.gz"
    sha256 "700b78a6af6952b4333474bdb55729a0d1949acf0157a3cb6d7b50221166b26e"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/98/2a/838de32e09bd511cf69fe4ae13ffc748ac143449bfc24bb3fd172d53a84f/tqdm-4.64.0.tar.gz"
    sha256 "40be55d30e200777a307a7585aee69e4eabb46b4ec6a4b4a5f2d9f11e7d5408d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/fe/71/1df93bd59163c8084d812d166c907639646e8aac72886d563851b966bf18/typing_extensions-4.2.0.tar.gz"
    sha256 "f1c24655a0da0d1b67f07e17a5e6b2a105894e6824b92096378bb3668ef02376"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
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

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
  end

  resource "zc.lockfile" do
    url "https://files.pythonhosted.org/packages/11/98/f21922d501ab29d62665e7460c94f5ed485fd9d8348c126697947643a881/zc.lockfile-2.0.tar.gz"
    sha256 "307ad78227e48be260e64896ec8886edc7eae22d8ec53e4d528ab5537a83203b"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.write("dvc/utils/build.py", "PKG = \"brew\"")

    venv.pip_install_and_link buildpath

    (bash_completion/"dvc").write `#{bin}/dvc completion -s bash`
    (zsh_completion/"_dvc").write `#{bin}/dvc completion -s zsh`
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
