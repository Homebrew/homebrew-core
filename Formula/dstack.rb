class Dstack < Formula
  include Language::Python::Virtualenv

  desc "ML workflow orchestration system designed for reproducibility and collaboration"
  homepage "https://docs.dstack.ai/"
  url "https://files.pythonhosted.org/packages/ef/42/5a2fb84e3f1b1e2759ce05d8c669b06563d8e4c2987d24a5e66758088474/dstack-0.7.2.tar.gz"
  sha256 "d660993aea4d7c8f2a06da599767e1ccd685c2b2f87babc45c5833bba39c54db"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2665d0d1ea35b5095b1111135bca85ab8574070dbf133666ddfc4312c17570b7"
    sha256 cellar: :any,                 arm64_monterey: "07d108d373f151bd2a54b641b24179efff0078fa8af779d03f37c928147a12ac"
    sha256 cellar: :any,                 arm64_big_sur:  "d08777992872d8c45aa99d5e3c8ee28074f14b765a30062d1d0cb1182072a6b8"
    sha256 cellar: :any,                 ventura:        "bbf85d5586d6809fddfd925b38de35afe8ff4ce7d2f41134ba9284d87de2402d"
    sha256 cellar: :any,                 monterey:       "d5d10854700797d804cf92f1ecdc6a35b83ea5c23bd39278e5cbd2dde021cd8c"
    sha256 cellar: :any,                 big_sur:        "190f7871a7b774632efc75d287b0a933c5151d65ee9d5416023ddcf1261a4e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ff7f9e74e0f250729c06a0dd7a2953dbdfa1824046f186a29692405c02b4d4b"
  end

  # `pkg-config`, `rust`, and `openssl@1.1` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "greenlet" do
    on_intel do
      url "https://files.pythonhosted.org/packages/1e/1e/632e55a04d732c8184201238d911207682b119c35cecbb9a573a6c566731/greenlet-2.0.2.tar.gz"
      sha256 "e7c8dc13af7db097bed64a051d2dd49e9f0af495c26995c00a9ee842690d34c0"
    end
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/ea/51/060efa10a814145acd4e42c6e5ed540b8714cad52ca026c5930e7c473049/aiosqlite-0.19.0.tar.gz"
    sha256 "95ee77b91c8d2808bd08a59fbebf66270e9090c3d92ffbf260dc0db0b979577d"
  end

  resource "alembic" do
    url "https://files.pythonhosted.org/packages/1e/7e/025531ac551af143f84475b5d2c7b523539d6812ccf771a1bf69c19fc8b7/alembic-1.10.3.tar.gz"
    sha256 "32a69b13a613aeb7e8093f242da60eff9daed13c0df02fff279c1b06c32965d2"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/8b/94/6928d4345f2bc1beecbff03325cad43d320717f51ab74ab5a571324f4f5a/anyio-3.6.2.tar.gz"
    sha256 "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421"
  end

  resource "APScheduler" do
    url "https://files.pythonhosted.org/packages/ea/ed/f1ad88e88208c24db80dcaae7a5a339bb283956984f8fa59933d2806413a/APScheduler-3.10.1.tar.gz"
    sha256 "0293937d8f6051a0f493359440c1a1b93e882c57daf0197afeff0e727777b96e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/18/5b/c8b6ae6be553d1ed09e5a4f4b750a866e3b3ef53325ee851b0525ca9c9cd/boto3-1.26.114.tar.gz"
    sha256 "b10324d452fe677d6e1005b650ae11158cf21310e0c0062b00d184b352f4196b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0c/3b/37aa84d8a9cd56fdc229257e68c2400bc4fa34d87d46ff16646add03e4f4/botocore-1.29.114.tar.gz"
    sha256 "aeacb03303d6babb0490247158647346d27900fcf89bfb9713db41f1ce1cc93f"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "cursor" do
    url "https://files.pythonhosted.org/packages/59/1b/ae231e1f9a8e1f970453f92fcb20a3fce87fa38753915477c26bc1655d86/cursor-1.3.5.tar.gz"
    sha256 "6758cae6ac14765ec85d9ce3f14fcb98fff5045f06d8398f1e8da8ce3acd2f20"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/a9/7b/ec011cf46d78627159ab869556f246b5f823a6df8d94f7577e043a63fffd/fastapi-0.95.1.tar.gz"
    sha256 "9569f0a381f8a457ec479d90fa01005cfddaae07546eb1f3fa035bc4797ae7d5"
  end

  resource "git-url-parse" do
    url "https://files.pythonhosted.org/packages/26/ea/c8c22b051026d9debe95c92df4fa0388f30fcde6f10fc0000058d13f6996/git-url-parse-1.2.2.tar.gz"
    sha256 "7b5f4e3aeb1d693afeee67a3bd4ac063f7206c2e8e46e559f0da0da98445f117"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/2b/15/7bafa5379a228ed72baf769eea5e6019a944469fe637ea0742c0351109bf/google-api-core-2.11.0.tar.gz"
    sha256 "4b9bb5d5a380a0befa0573b302651b8a9a89262c1730e37bf423cec511804c22"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/b3/56/7d367cbce23368b5d75d62dca0d3994b3c59e9e4038ae3303ab17984dcce/google-auth-2.17.3.tar.gz"
    sha256 "ce311e2bc58b130fddf316df57c9b3943c2a7b4f6ec31de9663a9333e4064efc"
  end

  resource "google-cloud-appengine-logging" do
    url "https://files.pythonhosted.org/packages/a3/9f/eb72dcb7445566ed5c4e5f116c132a8d771e7c8a06404bc81f8db29e1f3b/google-cloud-appengine-logging-1.3.0.tar.gz"
    sha256 "d52f14e1e9a993797a086eff3d4772dea7908390c6ad612d26281341f17c9a49"
  end

  resource "google-cloud-audit-log" do
    url "https://files.pythonhosted.org/packages/b1/3d/48e8b2c0cc7113d1674526b609944ef77d7182f233b23c50fec7106b2e2c/google-cloud-audit-log-0.2.5.tar.gz"
    sha256 "86e2faba3383adc8fd04a5bd7fd4f960b3e4aedaa7ed950f2f891ce16902eb6b"
  end

  resource "google-cloud-compute" do
    url "https://files.pythonhosted.org/packages/6f/24/3f83ebbc47fa472e983bf4d78a16c3ea900953783e46a07134f711a4b42d/google-cloud-compute-1.11.0.tar.gz"
    sha256 "d1d05a4b3ec6f830bbdcc779a740e963a80d324a4fd6ef41a7c248a07cf96489"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/40/4b/f4cebb92fe965f02f4a9c06f16355cf83a61a2d5db110df9af71191c830a/google-cloud-core-2.3.2.tar.gz"
    sha256 "b9529ee7047fd8d4bf4a2182de619154240df17fbe60ead399078c1ae152af9a"
  end

  resource "google-cloud-logging" do
    url "https://files.pythonhosted.org/packages/2f/87/633774179bc73e52b172c209c89b493804b0ad8e4c6e71b547603d35a883/google-cloud-logging-3.5.0.tar.gz"
    sha256 "f11544a21ea3556f70ebac7bc338ffa8a197913834ecdd8853d176b870823aaa"
  end

  resource "google-cloud-secret-manager" do
    url "https://files.pythonhosted.org/packages/48/6b/92b705f408c1d928526b65d1259be4254ef1f45e620f01f8665156b4d781/google-cloud-secret-manager-2.16.1.tar.gz"
    sha256 "149d11ce9be7ea81d4ac3544d3fcd4c716a9edb2cb775d9c075231570b079fbb"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/e3/a8/f1027a3aa5df2ea23b94e42317f41e8011cb654680b18fc1c53505fb0474/google-cloud-storage-2.8.0.tar.gz"
    sha256 "4388da1ff5bda6d729f26dbcaf1bfa020a2a52a7b91f0a8123edbda51660802c"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/d3/a5/4bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352/google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/88/11/ea0db6fe28017487dd1e2c6bc3623ea2dc4655947d6f571c6207b6d9693c/google-resumable-media-2.4.1.tar.gz"
    sha256 "15b8a2e75df42dc6502d1306db0bce2647ba6013f9cd03b6e17368c0886ee90a"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/9a/19/02a6256e00653b0fec9f356678df0ed996cb9d89aeb472c8c4df9490cac0/googleapis-common-protos-1.59.0.tar.gz"
    sha256 "4168fcb568a826a52f23510412da405abd93f4d23ba544bb68d943b14ba3cb44"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/1e/1e/632e55a04d732c8184201238d911207682b119c35cecbb9a573a6c566731/greenlet-2.0.2.tar.gz"
    sha256 "e7c8dc13af7db097bed64a051d2dd49e9f0af495c26995c00a9ee842690d34c0"
  end

  resource "grpc-google-iam-v1" do
    url "https://files.pythonhosted.org/packages/40/92/aee864f03f47c672a31d128e49981b01ca629d81541dcc9904c652dbab5b/grpc-google-iam-v1-0.12.6.tar.gz"
    sha256 "2bc4b8fdf22115a65d751c9317329322602c39b7c86a289c9b72d228d960ef5f"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/9d/13/f7e3834ba272c0058c66de57272fb3b20dde69003032fdb6b4d7c36eebed/grpcio-1.53.0.tar.gz"
    sha256 "a4952899b4931a6ba12951f9a141ef3e74ff8a6ec9aa2dc602afa40f63595e33"
  end

  resource "grpcio-status" do
    url "https://files.pythonhosted.org/packages/c2/7d/d3f34bdfe8c7a954f9974a4fca0be56021080fbcfba994b99896e433409e/grpcio-status-1.53.0.tar.gz"
    sha256 "5a46820dc7d94bac48aae5dd97c94cadea09d80a05553aca74a92a2954030420"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/e8/53/e614a5b7bcc658d20e6eff6ae068863becb06bf362c2f135f5c290d8e6a2/paramiko-3.1.0.tar.gz"
    sha256 "6950faca6819acd3219d4ae694a23c7a87ee38d084f70c1724b0c0dbb8b75769"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/38/ab/d5916bd1a56dfc2c9c268effd12a635ef7bbb2c9dc9b0270da72122afabb/proto-plus-1.22.2.tar.gz"
    sha256 "0e8cda3d5a634d9895b75c573c9352c16486cb75deb0e078b5fda34db4243165"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/e2/86/44a1e4990a81cb4248a2091a182bb76a6417fddcaff560ceb6b44eb05c55/protobuf-4.22.3.tar.gz"
    sha256 "23452f2fdea754a8251d0fc88c0317735ae47217e0d27bf330a30eec2848811a"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/37/a8/d832f7293ebb21690860d2e01d8115e5ff6f2ae8bbdc953f0eb0fa4bd2c7/py-cpuinfo-9.0.0.tar.gz"
    sha256 "3cdbbf3fac90dc6f118bfd64384f309edeadd902d7c8fb17f02ffa1fc3f49690"
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

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/43/5f/e53a850fd32dddefc998b6bfcbda843d4ff5b0dcac02a92e414ba6c97d46/pydantic-1.10.7.tar.gz"
    sha256 "cfc83c0678b6ba51b0532bea66860617c4cd4251ecf76e9846fa5a9f3454e97e"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/03/98/c7468f5a1b434cb15b1d240c5f3bd015962af8a822e89e7f10ee11e68928/Pygments-2.15.0.tar.gz"
    sha256 "f7e36cffc4c517fbc252861b9a6e4644ca0e5abadf9a113c72d1358ad09b9500"
  end

  resource "pygtail" do
    url "https://files.pythonhosted.org/packages/b0/89/437120e303d5d2c81107ed3415d5f3c9975f7dfdeef9e4440cef364e3bf9/pygtail-0.14.0.tar.gz"
    sha256 "55616d31a081eaaeb069d0946f2bc7e530ebf505d4c3c050f8e941786a3449d3"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/31/3b/2360352760b436f822258396e66ffb6d42585518a9cde2f93f142e64c5eb/rich-13.3.4.tar.gz"
    sha256 "b5d573e13605423ec80bdd0cd5f8541f7844a0e71a13f74cf454ccb2f490708b"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/a1/00/310d8c04104ccf2dac2dd505fd66639b61a40a38e77379bfa415f235a1d0/rich_argparse-1.1.0.tar.gz"
    sha256 "6af790893d9d6a0d5160dcc1a1448e0d0923d96f7b77af5de1efd54f4bd499cc"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/2d/69/31c7d6927338e1deac36e62be5a122e109a0a835a9bf2e30d422c0f3ccc3/simple-term-menu-1.6.1.tar.gz"
    sha256 "368b4158d1749b868552fb6c054b8301785086c71a7253dac8404cc3cb2d30e8"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/74/2c/2316a7a0d8b03e34741b3763604d180423f79730010dd7ed61d0f2854d8d/SQLAlchemy-2.0.9.tar.gz"
    sha256 "95719215e3ec7337b9f57c3c2eda0e6a7619be194a5166c07c1e599f6afc20fa"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/52/55/98746af96f57a0ff4f108c5ac84c130af3c4e291272acf446afc67d5d5d8/starlette-0.26.1.tar.gz"
    sha256 "41da799057ea8620e4667a3e69a5b1923ebd32b1819c8fa75634bbe8d8bea9bd"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/70/e5/81f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420d/tzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/39/97/b15b711a10d0774390404bec9712b2647b0b53a4da50a08acf7d7e51e284/tzlocal-4.3.tar.gz"
    sha256 "3f21d09e1b2aa9f2dacca12da240ca37de3ba5237a93addfd6d593afe9073355"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/ea/fa/362dc074f4c886e4bff1d994ed1929ed2c2a5ba85827d8f1d745fbe66de2/uvicorn-0.21.1.tar.gz"
    sha256 "0fac9cb342ba099e0d582966005f3fdba5b0290579fed4a6266dc702ca7bb032"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8b/94/696484b0c13234c91b316bc3d82d432f9b589a9ef09d016875a31c670b76/websocket-client-1.5.1.tar.gz"
    sha256 "3f09e6d8230892547132177f575a4e3e73cfdf06526e20cc02aa1c3b47184d40"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init", "--initial-branch=main"

    expected = "No remote branch configured for branch main"
    output = shell_output("#{bin}/dstack init 2>&1", 1).chomp
    assert_match expected, output

    output = shell_output("#{bin}/dstack tags add -a #{testpath} 2>&1 brewtest", 1).chomp
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/dstack --version")
  end
end
