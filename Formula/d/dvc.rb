class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/ee/27/3092dde533b8ee4ced70e984a1cdf95c94fa7cd9638d7e0f220141277fda/dvc-3.32.0.tar.gz"
  sha256 "fe47e88f91d48daa669c34233940b0fa5ce0762e7ccc303f892561bcae6cdf0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "613681684443e1f70c32a15e7fa00680aec4c3d61ecf7c9d2a8c74dcfac74808"
    sha256 cellar: :any,                 arm64_ventura:  "918e5b65ac90c63465e23611ce87ea07ab3acfcf3402fbd58a25edffc3372af3"
    sha256 cellar: :any,                 arm64_monterey: "3ed2af32c301c2004cd08997bbcba77c542dbcb12572ce6bd20fe3ac3685712b"
    sha256 cellar: :any,                 sonoma:         "77e7ebba7c12f0119a8a3427d0fe643aac8e24333ecefc586a6fb903d8987585"
    sha256 cellar: :any,                 ventura:        "b93df94a48c57fb58bdedc6260a83339a8c58cdefd9a8745d7368d5e71181f2c"
    sha256 cellar: :any,                 monterey:       "2b222c535ebc8cc664ffdd7b593eb9e9b45da9e5b1cad48d236cd0ebe4bdeca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7924d84e3634d21675ccb4a4c86b2bc45a421c6929d3c5cd48924b5da1de5592"
  end

  depends_on "openjdk" => :build # for hydra-core
  depends_on "rust" => :build # for bcrypt
  depends_on "apache-arrow"
  depends_on "cffi"
  depends_on "numpy"
  depends_on "protobuf"
  depends_on "pycparser"
  depends_on "pygit2"
  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-pyparsing"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/2f/a2/04c55c9c64bf37287a6a9c772f5128441337da8918d87ebe2bb9f4f5532c/adlfs-2023.10.0.tar.gz"
    sha256 "f5cf06c5b0074d17d43838d4c434791a98420d9e768b36a1a02c7b3930686543"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/b4/c5/d41d249fbe14be17190fd6c40603003ec02af0cb2ecfdc5a124addd8b8e9/aiobotocore-2.8.0.tar.gz"
    sha256 "f160497cef21cfffc1a8d4219eeb27bb7b243389c2d021a812b9c0e3fb8e2bd1"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/54/07/9467d3f8dae29b14f423b414d9e67512a76743c5bb7686fb05fe10c9cc3e/aiohttp-3.9.1.tar.gz"
    sha256 "8fc49a87ac269d4529da45871e2ffb6874e87779c3d0e2ccd813c0899221239d"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/01/c1/d57818a0ed5b0313ad8c620638225ddd44094d0d606ee33f3df5105572cd/aiohttp_retry-2.8.3.tar.gz"
    sha256 "9a8e637e31682ad36e1ff9f8bcba912fcfc7d7041722bc901a4b948da4d71ea9"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/4a/e6/888e1d726f0846c84e14a0f2f57873819eff9278b394d632aed979c98fbd/aioitertools-0.11.0.tar.gz"
    sha256 "42c68b8dd3a69c2bf7f2233bf7df4bb58b557bca5252ac02ed5187bbc67d6831"
  end

  resource "aiooss2" do
    url "https://files.pythonhosted.org/packages/34/e4/9434bf112c1f869719edb71a5fe08f2661670a628409721e5ed7df124181/aiooss2-0.2.8.tar.gz"
    sha256 "64fe56efb74edeb643f37adb75100d202d81e3d500a5cb969d693d587ecdf106"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/1e/e3/8623c0305022610466ded2b0010a7221e9585046116263dd27cb2e56df36/aliyun-python-sdk-core-2.14.0.tar.gz"
    sha256 "c806815a48ffdb894cc5bce15b8259b9a3012cc0cda01be2f3dfbb844f3f4f21"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/cb/87/f0004243da50bb102715fdc92e2fbff92b039bfbd16400c57a7dba572308/aliyun-python-sdk-kms-2.16.2.tar.gz"
    sha256 "f87234a8b64d457ca2338f87650db18a3ce7f7dbc9bfef71efe8f2894aded3d6"
  end

  resource "amqp" do
    url "https://files.pythonhosted.org/packages/32/2c/6eb09fbdeb3c060b37bd33f8873832897a83e7a428afe01aad333fc405ec/amqp-5.2.0.tar.gz"
    sha256 "a1ecff425ad063ad42a486c902807d1482311481c8ad95a72694b2975e75f7fd"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/6e/57/075e07fb01ae2b740289ec9daec670f60c06f62d04b23a68077fd5d73fab/anyio-4.1.0.tar.gz"
    sha256 "5a0bec7085176715be77df87fc66d6c9d70626bd752fcc85f57cdbee5b3760da"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/5f/86/59278fefc49ddcc10567e52a8e0e1553fc936584e241d516b5682d55ea17/asyncssh-2.14.1.tar.gz"
    sha256 "1ac31c333a0d83c88831523245500caa814503423741b0e465339ef6da5b5e29"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/4f/c8/22e1e6e2fe2cbe7a789a30d6288db3c1dbdbbe06af0d61277a97e4960b9e/atpublic-4.0.tar.gz"
    sha256 "0f40433219e124edf115c6c363808ca6f0e1cfa7d160d86b2fb94793086d1294"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/e3/39/328faea9f656075dbb8ecf70f1a4697bc80510fcc70e3e8f0090c34fc00c/azure-core-1.29.5.tar.gz"
    sha256 "52983c89d394c6f881a121e5101c5fa67278ca3b1f339c8fb2ef39230c70e9ac"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/22/ff/61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17/azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/74/02/a0545eaa3fb83a6b6c413de4a65e06a02ce887f874a2e74a1240b2169140/azure-identity-1.15.0.tar.gz"
    sha256 "4c28fc246b7f9265610eb5261d65931183d019a23d4b0e99357facb2e6c227c8"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/fd/f8/59c209132b3b2993402df6b7e79728726927b53168624e917cd9daaffea8/azure-storage-blob-12.19.0.tar.gz"
    sha256 "26c0a4320a34a3c2a1b74528ba6812ebcb632a04cd67b1c7377232c4b01a5897"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/df/56/be5fda8e6fc05123c8c9f526095e93d0802a0a0b2beaf995ee2cc20aa2f8/bcrypt-4.1.1.tar.gz"
    sha256 "df37f5418d4f1cdcff845f60e747a015389fa4e63703c918330865e06ad80007"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/09/52/f10d74fd56e73b430c37417658158ad8386202b069b70ff97d945c3ab67a/billiard-4.2.0.tar.gz"
    sha256 "9a3c3184cb275aa17a732f93f65b20c525d3d9f253722d26a82194803ade5a2c"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/18/e6/ba8827f5b0c2d1a63d3038de7dc0cbda0c1fd44668e4f20cafe9f13bac66/boto3-1.33.1.tar.gz"
    sha256 "1fe5fa75ff0f0c29a6f55e818d149d33571731e692a7b785ded7a28ac832cae8"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/3b/01/0f22b3c6d0578d163c967d4b3fbeaee8fb0697d9d5c1c33926f8551bd0ac/botocore-1.33.1.tar.gz"
    sha256 "d22d29916905e5f0670b91f07688e92b2c4a2075f9a474d6edbe7d22040d8fbf"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/99/72/45a2d2f9b45ccc6e80e2168ce169d17bf06a98711c192d7b53d5a8accf77/celery-5.3.6.tar.gz"
    sha256 "870cc71d737c0200c397290d730344cc991d13a057534353d124c9380267aab9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/cb/a2/57f4ac79838cfae6912f997b4d1a64a858fb0c86d7fcaae6f7b58d267fca/click-repl-0.3.0.tar.gz"
    sha256 "17849c23dba3d667247dc4defe1757fff98694e90fe37474f3feebb69ced26a9"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
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
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/0a/81/044f03129b6006fc594654bb26c22a9417346037261c767ac6e0773ca1dd/dpath-2.1.6.tar.gz"
    sha256 "f1e07c72e8605c6a9e80b64bc8f42714de08a789c7de417e49c3f87a19692e47"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/2b/e2/788910715b4910d08725d480278f625e315c3c011eb74b093213363042e0/dulwich-0.21.7.tar.gz"
    sha256 "a9e9c66833cea580c3ac12927e4b9711985d76afca98da971405d414de60e968"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/e5/e0/2414a4f2ef4b07ca54774abbe74e082b65fd6fcd0cfbb233523cf366a0db/dvc-azure-2.23.0.tar.gz"
    sha256 "d3e1b69f5cac445fe0825e6190eb145b650f3a6e98d44c5914148c7ceac44328"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/9c/04/9ffceebe624a2f78f7c5a3a0f7a78bb2763a2339e2a6e94eddc081e87f49/dvc-data-2.22.3.tar.gz"
    sha256 "ab4b6695078eea95f8289c6cde2d8356cfbff231c8d5b72b29cf34ec2ecf9c26"
  end

  resource "dvc-gdrive" do
    url "https://files.pythonhosted.org/packages/34/23/346f8ec6a8e6d17be802f1fa58d8b1023a50d9fa7f67e6bde1352e1aea7e/dvc-gdrive-2.20.0.tar.gz"
    sha256 "3bc75909a6094731d9b154b5b1f98f17f9abc217697497f5c3b9dd11eb3f038f"
  end

  resource "dvc-gs" do
    url "https://files.pythonhosted.org/packages/cd/e9/c87d2302056ad792561a80e26ffa5c6164db0d679dc2ee83a0af54f6e29f/dvc-gs-2.22.1.tar.gz"
    sha256 "20a0f07527e8959c2ff13bc71e2715578d8f61e50b86c92ff1cb1b9222732db9"
  end

  resource "dvc-hdfs" do
    url "https://files.pythonhosted.org/packages/d0/26/3459a96fb90c2f2e9edaa2d13f57051eb7bbb5d0d0c9dded8531a0ce43df/dvc-hdfs-2.19.0.tar.gz"
    sha256 "bce4b5a3633d018e795d196227714f30bdd701ac5f4c2a627f731b74d43f4aee"
  end

  resource "dvc-http" do
    url "https://files.pythonhosted.org/packages/a8/b7/66856e1f511b928945786a43fb0b3a283423b5243dcb738c3239164fdcec/dvc-http-2.31.0.tar.gz"
    sha256 "5b24b3edaee25b7a08f8cf260e63ead445ab18150faff0c033365dc8b9fb787f"
  end

  resource "dvc-objects" do
    url "https://files.pythonhosted.org/packages/08/07/b7ee3537cae61d1bc787873dc737d26935af26ff859aabf756633e01625f/dvc-objects-1.3.2.tar.gz"
    sha256 "6e4a4e92ede6b34d647e9d17eb515f65b2239a26b94972525713daf49b468492"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/78/b7/c0da46f72dd07d1e045d0657ea203c715f49a55fe7ffb43e4f16401c63f5/dvc-oss-2.22.0.tar.gz"
    sha256 "a65a13a0ec30de3093e037f06adbbc8a67b413c7d107b6bc6a818669b87771ef"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/2a/4e/50bd340d026189f5b440644a5c42ff575e0008d2fb7a7c69d741b63fce18/dvc-render-0.7.0.tar.gz"
    sha256 "8f0fc1a2924249152f2c5259af41821a1e9c9004d2197f3057e5f9f73d761d43"
  end

  resource "dvc-s3" do
    url "https://files.pythonhosted.org/packages/c6/e3/c36c130d108af65333e774575dee9815abac6497a4db6722a26f9cd7a0c1/dvc-s3-2.23.0.tar.gz"
    sha256 "1f28598f5b0def4a350933428aba062a368c93bb411aa3c6d8f46cae79b5b957"
  end

  resource "dvc-ssh" do
    url "https://files.pythonhosted.org/packages/62/a0/1c6a4edc14bd187974341ee02714e1db3b2782468b7f225cc7d482077026/dvc-ssh-2.22.2.tar.gz"
    sha256 "789c0d099bdd06a60a11b5f83a7de91a6d9bcc2bc7f46eeb76c81e37b5cf241d"
  end

  resource "dvc-studio-client" do
    url "https://files.pythonhosted.org/packages/f7/4a/f811e60902633fe5551b235806da5d2e26b2bbdb6f4e025cc73576e4636f/dvc-studio-client-0.17.1.tar.gz"
    sha256 "afda43f563c85ae4b60f01456d0ce1bd6a498880b9c5e48bf5ff3b033fa86f81"
  end

  resource "dvc-task" do
    url "https://files.pythonhosted.org/packages/02/70/a65126b40d43b9c53406d88a95d5e2b32083453f4739ea2bb854ba4b87c1/dvc-task-0.3.0.tar.gz"
    sha256 "6ab288bfbbc4a2df8ef145c543bb979d6cb8fb49037fec821a59ad6e1dfdddce"
  end

  resource "dvc-webdav" do
    url "https://files.pythonhosted.org/packages/65/68/49aac94af79dbc7662384c943fc0fa021adfe586f7f5899b232d5ab8a326/dvc-webdav-2.19.1.tar.gz"
    sha256 "1f24207d2ec94ed295e438a5182c4c817ab60d067c0cf0f6a0d4f9dbfe5e8ad1"
  end

  resource "dvc-webhdfs" do
    url "https://files.pythonhosted.org/packages/d2/a4/f975f7ebac05fe70b3fc2621a30958d330b827fc8814c6a6ca388f503cf3/dvc-webhdfs-2.19.0.tar.gz"
    sha256 "fc438e40fe9c0b5cc213c0b0f8767f5bd5025397bc58fc61b097f86ae0028ff9"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/ea/8d/a7121ffe5f402dc015277d2d31eb82d2187334503a011c18f2e78ecbb9b2/entrypoints-0.4.tar.gz"
    sha256 "b706eddaa9218a19ebcd67b56818f05bb27589b1ca9e8d797b74affad4ccacd4"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/89/c6/5fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3/flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl-lock" do
    url "https://files.pythonhosted.org/packages/35/33/d3baecd2545b9ae842f4df356aaa4a1816191eff737264542e9d27c5ec3b/flufl.lock-7.1.1.tar.gz"
    sha256 "af14172b35bbc58687bd06b70d1693fd8d48cbf0ffde7e51a618c148ae24042d"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/1f/c2/e94323e64149ea127e502d48f00dcf00806182966da88d5c10d9fe572745/fsspec-2023.12.1.tar.gz"
    sha256 "c4da01a35ac65c853f833e43f67802c25213f560820d54ddf248f92eddd5e990"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/1a/9e/3f087f5a1bb6bd414abe9cb1b6b6f44625e6e111b8db8465e00105265624/gcsfs-2023.12.1.tar.gz"
    sha256 "e86cc583fdf879e5ea2f87bab61738d26ec7e8972762a1e6c6ab758b1e1af99c"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/0d/b2/37265877ae607a2cbf9a471f4581dbf5ed13a501b90cb4c773f9ccfff3ea/GitPython-3.1.40.tar.gz"
    sha256 "22b126e9ffb671fdd0c129796343a02bf67bf2994b35449ffc9321aa755e18a4"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/10/3c/a25588d309f439aaa27e98621ab2e7fef90cb4b7b0a91a188b0faeb7c4b6/google-api-core-2.14.0.tar.gz"
    sha256 "5368a4502b793d9bbf812a5912e13e4e69f9bd87f6efb508460c43f5bbd1ce41"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/f8/99/c83a13d7d7f15aa06e9a6811375688f8c45f5211f5f5c719d337a2596f3d/google-api-python-client-2.109.0.tar.gz"
    sha256 "d06390c25477c361d52639fe00ef912c3fab8dafc7fbf29580c1144e92523a79"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/54/62/a13a5cac653075436ef97fc1c7b48eba277c5bfa3c8613617a733a832cbc/google-auth-2.24.0.tar.gz"
    sha256 "2ec7b2a506989d7dbfdbe81cb8d0ead8876caaed14f86d29d34483cbe99c57af"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/0f/7a/83c3a1f8419d66f91672ad7f2cea57d044f7f0b3c1740389a468ff3937ed/google-auth-httplib2-0.1.1.tar.gz"
    sha256 "c64bc555fdc6dd788ea62ecf7bccffcf497bf77244887a3f3d7a5a02f8e3fc29"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/6a/34/c584323ea98fb596e71ade06c06d514de898c60498efc72311e18ebe2825/google-auth-oauthlib-1.1.0.tar.gz"
    sha256 "83ea8c3b0881e453790baff4448e8a6112ac8778d1de9da0b68010b843937afb"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/6b/60/dcc26e42d3754ac57c51a524f53c988f2aa755faec4cc00a232bb0077637/google-cloud-core-2.3.3.tar.gz"
    sha256 "37b80273c8d7eee1ae816b3a20ae43585ea50506cb0e60f3cf5be5f87f1373cb"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/f1/94/665b3b7394477704cc3e894e37e04aa7c68575d30f46c62dff9ef8f2e8a6/google-cloud-storage-2.13.0.tar.gz"
    sha256 "f62dc4c7b6cd4360d072e3deb28035fbdad491ac3d9b0b1815a12daea10f37c7"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/d3/a5/4bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352/google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/66/3a/66ff4e1e862b39b1ac6680bd29cc98bd0b65c150daabfae356694d3390de/google-resumable-media-2.6.0.tar.gz"
    sha256 "972852f6c65f933e15a4a210c2b96930763b47197cdf4aa5f5bea435efb626e7"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/95/41/f9d4425eac5cec8c0356575b8f183e8f1f7206875b1e748bd3af4b4a8a1e/googleapis-common-protos-1.61.0.tar.gz"
    sha256 "8a64866a97f6304a7179873a465d6eee97b7a24ec6cfd78e0f575e96b821240b"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/95/0e/4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659/grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "gto" do
    url "https://files.pythonhosted.org/packages/a2/8a/a8cfd929ebeeb9da5d688c4a4469b4fb095b9a6daafb860d0a67c5192f2c/gto-1.5.0.tar.gz"
    sha256 "3772716fc978b3a261a24650ddd4cc1d87addb3cdb6b644beba6790b4f06615f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/18/56/78a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366/httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/8c/23/911d93a022979d3ea295f659fbe7edb07b3f4561a477e83b3a6d0e0c914e/httpx-0.25.2.tar.gz"
    sha256 "8b8fcaa0c8ea7b05edd69a094e63a2094c4efcb48129fb757361bc423c0ad9e8"
  end

  resource "hydra-core" do
    url "https://files.pythonhosted.org/packages/6d/8e/07e42bc434a847154083b315779b0a81d567154504624e181caf2c71cd98/hydra-core-1.3.2.tar.gz"
    sha256 "8a878ed67216997c3e9d88a8e72e7b4767e81af37afb4ea3334b269a4390a824"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "iterative-telemetry" do
    url "https://files.pythonhosted.org/packages/32/c1/0a2cdac1256bc1f8afde8a97be8d461036e8c09957b134bdd292eac6c18f/iterative-telemetry-0.0.8.tar.gz"
    sha256 "5bed9d19109c892cff2a4712a2fb18ad727079a7ab260a28b1e2f6934eec652d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/0c/5b/7cc69b2941a11bdace4faffef8f023543feefd14ab0222b6e62a318c53b9/knack-0.11.0.tar.gz"
    sha256 "eb6568001e9110b1b320941431c51033d104cc98cda2254a5c2b09ba569fd494"
  end

  resource "kombu" do
    url "https://files.pythonhosted.org/packages/f1/24/f88282626d5f5b720fed5a8d1a609a504569b93465cbbfe8e7c049fba54e/kombu-5.3.4.tar.gz"
    sha256 "0bb2e278644d11dea6272c17974a3dbb9688a949f3bb60aeb5b791329c44fadc"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/bb/45/c4dfbe24dd546d141287fa26476ce3206d461d8e4a24be77c84b835e647d/msal-1.26.0.tar.gz"
    sha256 "224756079fe338be838737682b49f8ebc20a87c1c5eeaf590daae4532b83de15"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
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
    url "https://files.pythonhosted.org/packages/09/48/6388f1bb9da707110532cb70ec4d2822858ddfb44f1cdf1233c20a80ea4b/omegaconf-2.3.0.tar.gz"
    sha256 "d5d4b6d29955cc50ad50c46dc269bcd92c6e00f5f90d23ab5fee7bfca4ba4cc7"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/72/75/642688bf5d99131fe8cf603f4ef9f26e4b1c6ed8f7f5c7e6fb31def54fb7/orjson-3.9.10.tar.gz"
    sha256 "9ebbdbd6a046c304b1845e96fbcc5559cd296b4dfd3ad2509e33c4d9ce07d6a1"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/4a/e7/08b90651a435acde68c537eebff970011422f61c465f6d1c88c4b3af6774/oss2-2.18.1.tar.gz"
    sha256 "5a901f6c0f3ac42f792e16a1e1c04e60f34e6cc9eb2bc4c0c3ce6e7bda2da4cc"
  end

  resource "ossfs" do
    url "https://files.pythonhosted.org/packages/d2/42/4cdce6e1ff4ce53c33cdc0dc1d212207181af3037d0a3a789367da42a266/ossfs-2023.12.0.tar.gz"
    sha256 "f99eb2d74717d22551b1f32ec9434587962627a816a64536dc47d68470536110"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/35/00/0f230921ba852226275762ea3974b87eeca36e941a13cd691ed296d279e5/portalocker-2.8.2.tar.gz"
    sha256 "2b035aa7828e46c58e9b31390ee1f169b98e1066ab10b9a6a861fe7e25ee4f33"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/d9/7b/7d88d94427e1e179e0a62818e68335cf969af5ca38033c0ca02237ab6ee7/prompt_toolkit-3.0.41.tar.gz"
    sha256 "941367d97fc815548822aa26c2a269fdc4eb21e9ec05fc5d447cf09bad5d75f0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/1a/72/acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025b/pycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b7/41/3c8108f79fb7da2d2b17f35744232af4ffcd9e764ebe1e3fd4b26669b325/pydantic-2.5.2.tar.gz"
    sha256 "ff177ba64c6faf73d7afa2e8cad38fd456c0dbe01c9954e71038001cd15a6edd"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/64/26/cffb93fe9c6b5a91c497f37fae14a4b073ecbc47fc36a9979c7aa888b245/pydantic_core-2.14.5.tar.gz"
    sha256 "6d30226dfc816dd0fdf120cae611dd2215117e4f9b124af8c60ab9093b6e8e71"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "pydrive2" do
    url "https://files.pythonhosted.org/packages/9b/f4/ac87aa67907033a3f55bdee46ac6d2dccf9dc9df23235c1d4efa464b5e32/PyDrive2-1.17.0.tar.gz"
    sha256 "68fea934347bb612b7a848811d48149db840bcfb5fa4d7a8b6161b2d2adfec70"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/b9/13/55deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5f/pygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/4a/90/583c20c2cdcd0b37d91eecf7c46e6797f8467222dd53bc4c6c65750ec87b/s3fs-2023.12.1.tar.gz"
    sha256 "63e429bb6b5e814568cacd3f2a8551fc35493e8c418ddfcb44e6f86aa8696ccd"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/48/62/53056e8a931a004b9a958c7ca709350a94e212ebcadfc9914a2a8bfaa4ec/s3transfer-0.8.0.tar.gz"
    sha256 "e8d6bd52ffd99841e3a57b34370a54841f12d3aab072af862cdcc50955288002"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/ca/2a/fd4af6b2143bf4e59acffabb8835571b8e207ac35a14e57748036a825de5/scmrepo-1.5.0.tar.gz"
    sha256 "d0c55295853be011342c6a58ed373dfeb7f501966d1b346ed2e649ef3d388604"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/1e/c6/ba2dd56e3996a1919984645ca0aaf20c4879cc1227c50a4be08f52b19ad0/shortuuid-1.0.11.tar.gz"
    sha256 "fc75f2615914815a8e4cb1501b3a513745cb66ef0fd5fc6fb9f8c3fa3481f789"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/14/0e/ce211daf7b28fe685b1c9a21d943b3a1c4f300a07e6c59d8765c5f22eb06/shtab-1.6.5.tar.gz"
    sha256 "cf4ab120183e84cce041abeb6f620f9560739741dfc31dd466315550c08be9ec"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sqltrie" do
    url "https://files.pythonhosted.org/packages/d7/73/7176cd3041c604219f0e1a4c4fa9074da6ceb571e59762fa8ed79704cd1b/sqltrie-0.9.0.tar.gz"
    sha256 "a5b3a0794156d509b6d721a8abba2241e86858d8a957c86c53a9cbede5cdbe41"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/90/b9/2c6a1238d70ba1bc6487b92ec5f3eba9a905ff34da31dab15e419d57e32c/sshfs-2023.10.0.tar.gz"
    sha256 "8f63f83dd05511552f3ac9590212888dff70dfd43645615b5c030190d2fe3a2b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5b/49/39f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9/typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/70/e5/81f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420d/tzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "vine" do
    url "https://files.pythonhosted.org/packages/bd/e4/d07b5f29d283596b9727dd5275ccbceb63c44a1a82aa9e4bfd20426762ac/vine-5.1.0.tar.gz"
    sha256 "8b62e981d35c41049211cf62a0a1242d8c1ee9bd15bb196ce38aefd6799e61e0"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/d8/33/98b8032d580525c04e0691f4df9a74b0cfb327661823e32fe6d00bed55a4/voluptuous-0.14.1.tar.gz"
    sha256 "7b6e5f7553ce02461cce17fedb0e3603195496eb260ece9aca86cc4cc6625218"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  resource "webdav4" do
    url "https://files.pythonhosted.org/packages/be/cc/172a99d6bee59597063e8a920ca5c7aeeced8f624453110490deba46819b/webdav4-0.9.8.tar.gz"
    sha256 "fc7748df33a375de13ddb5f4594f5799f9f3dc13c005b7b9c45c120aad745694"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/ca/f7/2af788563995eeec32b920c0640a6bc54777c89c780030a7754f95166b7f/yarl-1.9.3.tar.gz"
    sha256 "4a14907b597ec55740f63e52d7fee0e9ee09d5b9d57a4f399a7423268e457b57"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/5b/83/a5432aa08312fc834ea594473385c005525e6a80d768a2ad246e78877afd/zc.lockfile-3.0.post1.tar.gz"
    sha256 "adb2ee6d9e6a2333c91178dcb2c9b96a5744c78edb7712dc784a7d75648e81ec"
  end

  def install
    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/3.0.0/scripts/build.py#L23
    File.write("dvc/_build.py", "PKG = \"brew\"")

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
