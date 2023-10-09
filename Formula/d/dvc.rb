class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/b4/fd/cfc2c92c7c9b349983cd284d24742038a51bd2ee27e4188b51bd6d9192b1/dvc-3.24.0.tar.gz"
  sha256 "e657bb08689e9c5c0395e4b1e618dc514189d6f9f663f3a1d08e947a629cbab0"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "53d48019155b94cf28221497ff5681aa182aa1c4353055659cd06f12983e65e8"
    sha256 cellar: :any,                 arm64_ventura:  "b5926484c74942ae6b68fb967f03088082d8886f076773276ba77527fbd875db"
    sha256 cellar: :any,                 arm64_monterey: "e34ac2953c1f38d16d63e525528b8af6380fc74611f25c4111627d95ca86942a"
    sha256 cellar: :any,                 sonoma:         "4569dcfd9240abb7670db83b59ae2e83add200eeac1e3134d91573150cff56da"
    sha256 cellar: :any,                 ventura:        "277396191c6b70a3abab5e7a9d5c2b9ef5d1d908d557a1beab177cb533c3c207"
    sha256 cellar: :any,                 monterey:       "5b136f9522dfd9b1b624f8e484d72e73c2d7cdbea1e46d47e3780b81fb9d7524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e664915b7138577fbb3644bf284f127787aafab27021385ad657f202eef46e0"
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
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/76/b5/39a05057787d9ad3c92025707f581a3949ba81b82291102b2ff8cc3ff1e5/adlfs-2023.8.0.tar.gz"
    sha256 "07e804f6df4593acfcaf01025b162e30ac13e523d3570279c98b2d91a18026d9"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/f1/bc/3c5e5b57f519ec9a2f11cc4904ecbc723a15f1958af6f2df839a953c964a/aiobotocore-2.5.4.tar.gz"
    sha256 "60341f19eda77e41e1ab11eef171b5a98b5dbdb90804f5334b6f90e560e31fae"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/d6/12/6fc7c7dcc84e263940e87cbafca17c1ef28f39dae6c0b10f51e4ccc764ee/aiohttp-3.8.5.tar.gz"
    sha256 "b9552ec52cc147dbf1944ac7ac98af7602e51ea2dcd076ed194ca3c0d1c7d0bc"
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
    url "https://files.pythonhosted.org/packages/ee/06/0a9f8deb322f539571f7fd928cc4a8b243e8a09b1b005914bed9031248b1/aiooss2-0.2.7.tar.gz"
    sha256 "2f7c5e4cc89ed65ce87ac0195bf32e705fa1ef0fe77dd1047b96ca54b9110c3a"
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
    url "https://files.pythonhosted.org/packages/cb/e7/bcaab89065e17915a28247fa5d4f582ca107b4544e2b1aba92d32f794a0f/amqp-5.1.1.tar.gz"
    sha256 "2c1b13fecc0893e946c65cbd5f36427861cffa4ea2201d8f6fca22e2a373b5e2"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/42/97/41ccb6acac36fdd13592a686a21b311418f786f519e5794b957afbcea938/annotated_types-0.5.0.tar.gz"
    sha256 "47cdc3490d9ac1506ce92c7aaa76c579dc3509ff11e098fc867e5130ab7be802"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/74/17/5075225ee1abbb93cd7fc30a2d343c6a3f5f71cf388f14768a7a38256581/anyio-4.0.0.tar.gz"
    sha256 "f7ed51751b2c2add651e5747c891b47e26d2a21be5d32d9311dfe9692f3e5d7a"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/1b/c5/fb934dda06057e182f8247b2b13a281552cf55ba2b8b4450f6e003d0469f/argcomplete-3.1.2.tar.gz"
    sha256 "d5d1e5efd41435260b8f85673b74ea2e883affcbec9f4230c582689e8e78251b"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
    sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/8a/fd/9d921a3ddd61eb400aa352c41c033c649b337a611b861d5ad31958e0961a/asyncssh-2.14.0.tar.gz"
    sha256 "e03ef2d131fbb4371b4018718452ce8c735a48edfe0139d2abdce4c187a459c3"
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
    url "https://files.pythonhosted.org/packages/fa/19/43a9eb812b4d6071fdc2c55640318f7eb5a1be8dbd3b6f9d96a1996e1bb6/azure-core-1.29.4.tar.gz"
    sha256 "500b3aa9bf2e90c5ccc88bb105d056114ca0ce7d0ce73afb8bc4d714b2fc7568"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/22/ff/61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17/azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/e4/2c/f5e1b34c34c580d3d47ddaa75bc15374a1f601547bcbb1e1e366777e7995/azure-identity-1.14.0.zip"
    sha256 "72441799f8c5c89bfe21026965e266672a7c5d050c2c65119ef899dd5362e2b1"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/62/6e/93d698736a14c7d178de053316ac3b30c81140e716c52e3abc7e3779302b/azure-storage-blob-12.18.2.tar.gz"
    sha256 "e11935348981ffc005b848b55db25c04f2d1f90e1ee33000659906b763cf14c8"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/b3/9c/c02d3988ddb0e32e974db1d8434616f1503b12fc7087bf18243ccd69a60a/billiard-4.1.0.tar.gz"
    sha256 "1ad2eeae8e28053d729ba3373d34d9d6e210f6e4d8bf0a9c64f92bd053f1edf5"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/f9/889e0c7d07bc5616d193d63b9600145d2d83f21a09fca40be078ef9323eb/boto3-1.28.17.tar.gz"
    sha256 "90f7cfb5e1821af95b1fc084bc50e6c47fa3edc99f32de1a2591faa0c546bea7"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/54/ce/3aced9653aa3b81aeda70574f342cd3014ecc36aff6a20e74c767f92864f/botocore-1.31.17.tar.gz"
    sha256 "396459065dba4339eb4da4ec8b4e6599728eb89b7caaceea199e26f7d824a41c"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/cc/2d/006ba66a8ee1bf1aef841d7a8a3d44733e9d4d45d7acdc7a675b06a8de22/celery-5.3.4.tar.gz"
    sha256 "9023df6a8962da79eb30c0c84d5f4863d9793a466354cc931d7f72423996de28"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
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
    url "https://files.pythonhosted.org/packages/57/e0/1b5f95c2651284a5d4fdfb2cc5ecad57fb694084cce59d9d4acb7ac30ecf/dulwich-0.21.6.tar.gz"
    sha256 "30fbe87e8b51f3813c131e2841c86d007434d160bd16db586b40d47f31dd05b0"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/fc/89/a0835bb993906e3a44c2649e6592ff417e3384f2b73169374322c3a0b7b2/dvc-azure-2.22.1.tar.gz"
    sha256 "bf755108dd4ea124f94657d438ff43a5f99fde8f42fdc92eb2687dd586b60a29"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/c2/68/edf6091cc0a502664b7f348e8f8f55cc792e125a65ffaf0fbfeacf012576/dvc-data-2.18.1.tar.gz"
    sha256 "2150046baa8519ac8f0f6b314e48878a5af5742cbf13453fb6f9b1d2bf44a22a"
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
    url "https://files.pythonhosted.org/packages/f7/13/6e78634560e86dab3f858176f34790bf4c566c5cbd576fe7e33799427a8d/dvc-http-2.30.2.tar.gz"
    sha256 "d7cf66e8f8359cc9f5ca137de24d259beebdec444516fc7d085ad26fa7d3b34b"
  end

  resource "dvc-objects" do
    url "https://files.pythonhosted.org/packages/9e/92/8ea3b09602601a959a02d9db8e16f3ae33b1925ae0ef86cc2d44b113dd53/dvc-objects-1.0.1.tar.gz"
    sha256 "a9fdf55552b95d3dfa1d4572b3938e893c4b4365bb551e168e164fcf5eab93dd"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/c2/fe/bd18852700460221cbd9e2ea3cbeabc9aae21ffc53e3acd8206470625424/dvc-oss-2.21.0.tar.gz"
    sha256 "b1aae395a60db04500c6b6ee14df3270f48be7e2009b74a237635bb1acf6a4ec"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/9c/5e/a5a30613a1f069a50df71433c706ac209ae3e2cd3a8004e3ce91d26ecf29/dvc-render-0.6.0.tar.gz"
    sha256 "69b7dfdadf890beb6d7fa5b3d4bd33323d78fc4c3ce33ed1bf777026192f9b4d"
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
    url "https://files.pythonhosted.org/packages/fe/df/53379c8e8886d3333630873440f973a508a0c27f81ed7f1632d3a4734c5d/dvc-studio-client-0.15.0.tar.gz"
    sha256 "46dd508a0fb2c1c9986efd4111aa16ad3e40718c5e86a2be9f6e5ee509ff44a1"
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
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
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
    url "https://files.pythonhosted.org/packages/14/e4/33a5c4635cff37ef6eb66608c675ae678b48baa6e73b331536cf2cbf18a1/fsspec-2023.6.0.tar.gz"
    sha256 "d0b2f935446169753e7a5c5c55681c54ea91996cc67be93c39a154fb3a2742af"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/51/4a/6283a24fae13f1b3745572c443a7cb072076ccc3eefd3fcf84c078000ff8/gcsfs-2023.6.0.tar.gz"
    sha256 "30b14fccadb3b7f0d99b2cd03bd8507c40f3a9a7d05847edca571f642bedbdff"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c6/33/5e633d3a8b3dbec3696415960ed30f6718ed04ef423ce0fbc6512a92fa9a/GitPython-3.1.37.tar.gz"
    sha256 "f9b9ddc0761c125d5780eab2d64be4873fc6817c2899cbcb34b02344bdc7bc54"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/3f/5d/9138d873205a38e5264a78fd4ebf446fc987f20e2566719ed6eee69c200a/google-api-core-2.12.0.tar.gz"
    sha256 "c22e01b1e3c4dcd90998494879612c38d0a3411d1f7b679eb89e2abe3ce1f553"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/fa/6c/97e6eeac0959783c2ac21aea3c560f970327fbb0498a6011d58cbfbb30e8/google-api-python-client-2.102.0.tar.gz"
    sha256 "906ff9b672a4d5ddad8f4073a040e59f1fba6734909c14cd49938e37be53691d"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/49/5c/537d35dbbd248cd58fa1014a9770063b103fa63a3d929bbcf739d2d731f9/google-auth-2.23.2.tar.gz"
    sha256 "5a9af4be520ba33651471a0264eead312521566f44631cbb621164bc30c8fd40"
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
    url "https://files.pythonhosted.org/packages/50/a5/6c9a105eabe77deeb313cbf1d13c2cda4444af7298e17d3ab350a0e5cfb9/google-cloud-storage-2.11.0.tar.gz"
    sha256 "6fbf62659b83c8f3a0a743af0d661d2046c97c3a5bfb587c4662c4bc68de3e31"
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
    url "https://files.pythonhosted.org/packages/08/78/aedf7f323cc6d4f2116556bd42c9ffab6021cf3f2fd9925ed4e71213dd1b/googleapis-common-protos-1.60.0.tar.gz"
    sha256 "e73ebb404098db405ba95d1e1ae0aa91c3e15a71da031a2eeb6b2e23e7bc3708"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/95/0e/4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659/grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "gto" do
    url "https://files.pythonhosted.org/packages/e1/5e/e070ea2f82e3527c213784db9ef73fb9e0e59c6e6d35c2d672496b707d36/gto-1.3.0.tar.gz"
    sha256 "f86c1f25ad5130020a4f1fb09c53500303c30cd65f4407f3bc1e66293d1a827f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/23/b6/d71729dc09e5a5b361b655ae18e85fbf97e5e27a076c4f9b4606b4eb0340/httpcore-0.18.0.tar.gz"
    sha256 "13b5e5cd1dca1a6636a6aaea212b19f4f85cd88c366a2b82304181b769aab3c9"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/a5/24/dbc981590a8b72ddd5f954fbddb1da010ae844a1cde904bca3c9380ccb1d/httpx-0.25.0.tar.gz"
    sha256 "47ecda285389cb32bb2691cc6e069e3ab0205956f681c5b2ad2325719751d875"
  end

  resource "hydra-core" do
    url "https://files.pythonhosted.org/packages/6d/8e/07e42bc434a847154083b315779b0a81d567154504624e181caf2c71cd98/hydra-core-1.3.2.tar.gz"
    sha256 "8a878ed67216997c3e9d88a8e72e7b4767e81af37afb4ea3334b269a4390a824"
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
    url "https://files.pythonhosted.org/packages/bb/2e/95a2af69f9fc7f9c7b7a34f630843d843ee2de758934eb9694f6e3412094/kombu-5.3.2.tar.gz"
    sha256 "0ba213f630a2cb2772728aef56ac6883dc3a2f13435e10048f6e97d48506dbbd"
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
    url "https://files.pythonhosted.org/packages/5d/03/fa40e4a7c9bd32492ed5e222b23f699553f0d25ff8f7d489fcb21a745787/msal-1.24.1.tar.gz"
    sha256 "aa0972884b3c6fdec53d9a0bd15c12e5bd7b71ac1b66d746f54d128709f3f8f8"
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
    url "https://files.pythonhosted.org/packages/fd/a1/47b974da1a73f063c158a1f4cc33ed0abf7c04f98a19050e80c533c31f0c/networkx-3.1.tar.gz"
    sha256 "de346335408f84de0eada6ff9fafafff9bcda11f0a0dfaa931133debb146ab61"
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
    url "https://files.pythonhosted.org/packages/d9/e8/3b73e455a5f5f16ed70b364b5dbaec5691e7ae1d3c1e6cf8945735ec05a0/orjson-3.9.7.tar.gz"
    sha256 "85e39198f78e2f7e054d296395f6c96f5e02892337746ef5b6a1bf3ed5910142"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/4a/e7/08b90651a435acde68c537eebff970011422f61c465f6d1c88c4b3af6774/oss2-2.18.1.tar.gz"
    sha256 "5a901f6c0f3ac42f792e16a1e1c04e60f34e6cc9eb2bc4c0c3ce6e7bda2da4cc"
  end

  resource "ossfs" do
    url "https://files.pythonhosted.org/packages/25/72/06d0ee01928f3fba48dd082bdff936724d049649b432e3972209801b0489/ossfs-2023.8.0.tar.gz"
    sha256 "91525c94d03d9a4e7d092f7a51b0086c973d730fbc4f1263b838f9f827d9f204"
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
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
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
    url "https://files.pythonhosted.org/packages/df/e8/4f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41/pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/31/8e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6eca/pydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
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
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
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
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/de/7d/4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54/ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/c7/a8/a7db1ffd9db7539dea35b01372bc8862b8c4dbb4287cfd3759eb964ebf20/s3fs-2023.6.0.tar.gz"
    sha256 "63fd8ddf05eb722de784b7b503196107f2a518061298cf005a8a4715b4d49117"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/78/68/d2465a0a15dbd3e3343bedec38962f8b1d719796acce22539d0edb5be98f/scmrepo-1.3.1.tar.gz"
    sha256 "11fe5fb4815d2aa1c2d1bcc63898228f0eb7106a18529243dd9fad34b57ef0dc"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/46/30/a14b56e500e8eabf8c349edd0583d736b231e652b7dce776e85df11e9e0b/semver-3.0.1.tar.gz"
    sha256 "9ec78c5447883c67b97f98c3b6212796708191d22e4ad30f4570f840171cbce1"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/1e/c6/ba2dd56e3996a1919984645ca0aaf20c4879cc1227c50a4be08f52b19ad0/shortuuid-1.0.11.tar.gz"
    sha256 "fc75f2615914815a8e4cb1501b3a513745cb66ef0fd5fc6fb9f8c3fa3481f789"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/72/5c/6614a030e5308c244f3fb7ada978d3860720d8dc69522c651d3052c50e8c/shtab-1.6.4.tar.gz"
    sha256 "aba9e049bed54ffdb650cb2e02657282d8c0148024b0f500277052df124d47de"
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
    url "https://files.pythonhosted.org/packages/da/6a/d579f4ba0d35202fb2b27edbe75f481e64ec5fb00c873ac4c558e4b9659d/sqltrie-0.8.0.tar.gz"
    sha256 "a773e41f00ae9215a79d3e0537526eaf5e37100037a2ef042d09edcc209abc9e"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/71/18/fa440e1b4cb83c9179b07ffb6ce78a6ed751945350601a3342c2b842d60d/sshfs-2023.7.0.tar.gz"
    sha256 "5bc28cd04df12aad73b5eef85e33e4eb54d9c9249193bb14236de9e75912b710"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
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
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
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
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  resource "webdav4" do
    url "https://files.pythonhosted.org/packages/be/cc/172a99d6bee59597063e8a920ca5c7aeeced8f624453110490deba46819b/webdav4-0.9.8.tar.gz"
    sha256 "fc7748df33a375de13ddb5f4594f5799f9f3dc13c005b7b9c45c120aad745694"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
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
