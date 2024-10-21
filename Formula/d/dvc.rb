class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/ce/fe/30d8a9733f1edddd356766f0ec167e950e26a4717ec6f0c397da25f9510f/dvc-3.55.2.tar.gz"
  sha256 "2fbb38385753d51b25967c80e672cf9dea046bdac182c159a2c1d1f246d15ce0"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2b98b8cce3f11591a324a2cb2e9336c148aa8926cc212da977da80d35df435ad"
    sha256 cellar: :any,                 arm64_sonoma:  "78f42ba1e81e63b5b3c9d9d9d6250883683521775b2c0a9938c40db99005b7c5"
    sha256 cellar: :any,                 arm64_ventura: "d6037a11debcc892f71e8dba68a4d2d1c7f2d4a2f76f57c1735a148eaf5b0af9"
    sha256 cellar: :any,                 sonoma:        "16c7e08b5d5055b228d036598e50c4b42023bb780e2da08f0b7028798d055c84"
    sha256 cellar: :any,                 ventura:       "3b07aa92e0b39a8588477825be810b56020029e31b5b5a42ad4fc5f95721976e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d60921cb347c9583be8996e317efad18af3e850b7e03411ef6d6feeb6f44c95"
  end

  depends_on "cmake" => :build # for pyarrow
  depends_on "ninja" => :build # for pyarrow
  depends_on "openjdk" => :build # for hydra-core
  depends_on "rust" => :build # for bcrypt
  depends_on "apache-arrow"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/b4/1e/6d5146676044247af566fa5843b335b1a647e6446070cec9c8b61c31b369/adlfs-2024.7.0.tar.gz"
    sha256 "106995b91f0eb5e775bcd5957d180d9a14faef3271a063b1f65c66fd5ab05ddf"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/e3/3d/5d54985abed848a4d4dafd10d7eb9ecd6bd7fff9533223911a92c2e6e15d/aiobotocore-2.15.2.tar.gz"
    sha256 "9ac1cfcaccccc80602968174aa032bf978abe36bd4e55e6781d6500909af1375"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/bc/69/2f6d5a019bd02e920a3417689a89887b39ad1e350b562f9955693d900c40/aiohappyeyeballs-2.4.3.tar.gz"
    sha256 "75cf88a15106a5002a8eb1dab212525c00d1f4c0fa96e551c9fbe6f09a621586"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/17/7e/16e57e6cf20eb62481a2f9ce8674328407187950ccc602ad07c685279141/aiohttp-3.10.10.tar.gz"
    sha256 "0631dd7c9f0822cc61c88586ca76d5b5ada26538097d0f1df510b082bad3411a"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/01/c1/d57818a0ed5b0313ad8c620638225ddd44094d0d606ee33f3df5105572cd/aiohttp_retry-2.8.3.tar.gz"
    sha256 "9a8e637e31682ad36e1ff9f8bcba912fcfc7d7041722bc901a4b948da4d71ea9"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/06/de/38491a84ab323b47c7f86e94d2830e748780525f7a10c8600b67ead7e9ea/aioitertools-0.12.0.tar.gz"
    sha256 "c2a9055b4fbb7705f561b9d86053e8af5d10cc845d22c32008c43490b2d8dd6b"
  end

  resource "aiooss2" do
    url "https://files.pythonhosted.org/packages/99/81/63bc832d0ddf2ac5b61177343338ffb21d9ebd49964279a1bd83861b2844/aiooss2-0.2.10.tar.gz"
    sha256 "65698a287386464e4a08fb862be85668df4d1e1acfe0620404617d88869630eb"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/3e/09/da9f58eb38b4fdb97ba6523274fbf445ef6a06be64b433693da8307b4bec/aliyun-python-sdk-core-2.16.0.tar.gz"
    sha256 "651caad597eb39d4fad6cf85133dffe92837d53bdf62db9d8f37dab6508bb8f9"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/a8/2c/9877d0e6b18ecf246df671ac65a5d1d9fecbf85bdcb5d43efbde0d4662eb/aliyun-python-sdk-kms-2.16.5.tar.gz"
    sha256 "f328a8a19d83ecbb965ffce0ec1e9930755216d104638cd95ecd362753b813b3"
  end

  resource "amqp" do
    url "https://files.pythonhosted.org/packages/32/2c/6eb09fbdeb3c060b37bd33f8873832897a83e7a428afe01aad333fc405ec/amqp-5.2.0.tar.gz"
    sha256 "a1ecff425ad063ad42a486c902807d1482311481c8ad95a72694b2975e75f7fd"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/78/49/f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8/anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/5f/39/27605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35e/argcomplete-3.5.1.tar.gz"
    sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/32/34/007ba4c65dc15ad394ff50d6ce272bcc028a8824ab1658c5fe5c480be515/asyncssh-2.17.0.tar.gz"
    sha256 "3b159c105aa388c1e2245c4faf483f540ada8cad99402281119100166e5edb3c"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/5d/18/b1d247792440378abeeb0853f9daa2a127284b68776af6815990be7fcdb0/atpublic-5.0.tar.gz"
    sha256 "d5cb6cbabf00ec1d34e282e8ce7cbc9b74ba4cb732e766c24e2d78d1ad7f723f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/03/7a/f79ad135a276a37e61168495697c14ba1721a52c3eab4dae2941929c79f8/azure_core-1.31.0.tar.gz"
    sha256 "656a0dd61e1869b1506b7c6a3b31d62f15984b1a573d6326f6aa2f3e4123284b"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/22/ff/61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17/azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/aa/91/cbaeff9eb0b838f0d35b4607ac1c6195c735c8eb17db235f8f60e622934c/azure_identity-1.19.0.tar.gz"
    sha256 "500144dc18197d7019b81501165d4fa92225f03778f17d7ca8a2a180129a9c83"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/66/b2/df9ac2ea294e558fa8b6cdade9a14a938b07529f5194303664152819277a/azure_storage_blob-12.23.1.tar.gz"
    sha256 "a587e54d4e39d2a27bd75109db164ffa2058fe194061e5446c5a89bca918272f"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/e4/7e/d95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0/bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/7c/58/1546c970afcd2a2428b1bfafecf2371d8951cc34b46701bea73f4280989e/billiard-4.2.1.tar.gz"
    sha256 "12b641b0c539073fc8d3f5b8b7be998956665c4233c7c1fcd66a7e677c4fb36f"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/33/9f/17536f9a1ab4c6ee454c782f27c9f0160558f70502fc55da62e456c47229/boto3-1.35.36.tar.gz"
    sha256 "586524b623e4fbbebe28b604c6205eb12f263cc4746bccb011562d07e217a4cb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8d/4f/11d2d314f0bdbe7ff975737d125e1a5357115afe28fcc64f13e68b05ba61/botocore-1.35.36.tar.gz"
    sha256 "354ec1b766f0029b5d6ff0c45d1a0f9e5007b7d2f3ec89bcdd755b208c5bc797"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/8a/9c/cf0bce2cc1c8971bf56629d8f180e4ca35612c7e79e6e432e785261a8be4/celery-5.4.0.tar.gz"
    sha256 "504a19140e8d3029d5acad88330c541d4c3f64c789d85f94756762d8bca7e706"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
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
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
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
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/b5/ce/e1fd64d36e4a5717bd5e6b2ad188f5eaa2e902fde871ea73a79875793fc9/dpath-2.2.0.tar.gz"
    sha256 "34f7e630dc55ea3f219e555726f5da4b4b25f2200319c8e6902c394258dd6a3e"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/cf/ac/cf6420b90832c4ffbc88b92962dd0167c58632c2b8d508d5baf4ecb0c61d/dulwich-0.22.1.tar.gz"
    sha256 "e36d85967cfbf25da1c7bc3d6921adc5baa976969d926aaf1582bd5fd7e94758"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/b1/cd/5cf47247c82e7b8eba42890a23e6700f4baade329d24722140d290c32dc3/dvc-azure-3.1.0.tar.gz"
    sha256 "52cbc70d5414b50219b3db0a16f68ad25daba76e3f220aebe4e49b3c6498ae20"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/97/3d/7c160b6b0ceddbf930ee2f05f3e4aa456f7926c9b92339ba010fbad6995a/dvc_data-3.16.6.tar.gz"
    sha256 "598c10e5ded098f5145ede5535f2b5b964af42dc900486bc9bb739191f8189fd"
  end

  resource "dvc-gdrive" do
    url "https://files.pythonhosted.org/packages/b5/ab/278694dd93e8657d590408e37e440ead5ca809af6c265ca248df10942270/dvc-gdrive-3.0.1.tar.gz"
    sha256 "ad7c9cd044083745150a57649eb4ef9240348f054bed5a8f8aa5f1820c6384ec"
  end

  resource "dvc-gs" do
    url "https://files.pythonhosted.org/packages/71/58/7714c93a472f04613fee5714d847d1af7b1fabcca93784046cc07eb7b8d8/dvc-gs-3.0.1.tar.gz"
    sha256 "e5430a297fb8182366f7c4bc910b1ab104d8e5cc22f611a19bce05165dffecd4"
  end

  resource "dvc-hdfs" do
    url "https://files.pythonhosted.org/packages/ea/b5/42a2a3b3897f6e7c0b77c1408ed27e472ffdf61c5a1fec91d396177da275/dvc-hdfs-3.0.0.tar.gz"
    sha256 "286443cb2c107ad53e73d8d6c4af8524b6e3b6b88b1543c8bc0544738aeb9fee"
  end

  resource "dvc-http" do
    url "https://files.pythonhosted.org/packages/33/e6/4fb38ab911a9d90fbe2c7759c430814fe2253760304a9de0d3ebd6e27c20/dvc-http-2.32.0.tar.gz"
    sha256 "f714f8435634aab943c625f659ddac1188c6ddaf3ff161b39715b83ff39637fc"
  end

  resource "dvc-objects" do
    url "https://files.pythonhosted.org/packages/f0/18/22e1b3440ad2b1b6de864b10ef25e6e0069342524d2b592de40f0cb17e13/dvc-objects-5.1.0.tar.gz"
    sha256 "22e919620f9ecf428a0d295efca8073d1c0e87206dd8e1f52b1d9520fa25b814"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/c2/32/08789c1aa80da525fd7bd0fbef4c11431aabf32cc9446e28a589daf9fa2e/dvc-oss-3.0.0.tar.gz"
    sha256 "1047f734022fcd2b96d32b06bf6e0921cd0a65810f7fc1e9b0fac29a147b6a9a"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/be/15/605312dbdc0931547987ee25a9a3f6fcabf48ca1436039abcd524156b8e2/dvc-render-1.0.2.tar.gz"
    sha256 "40d1cd81760daf34b48fa8362b5002fcbe415e3cdbcf42369b6347d01497ffc0"
  end

  resource "dvc-s3" do
    url "https://files.pythonhosted.org/packages/fa/cf/14e5f014f77381a58617c1ee3ae98f8fc15768e6a89ff0efac3ff7fc0016/dvc_s3-3.2.0.tar.gz"
    sha256 "1d012ac1dce47659986f918123b48931cf9b3429ab0b4a22fd4b02448185ceb6"
  end

  resource "dvc-ssh" do
    url "https://files.pythonhosted.org/packages/13/02/ced97a5206110568a1360473d6416a71327155ae1b93d28b748da61c045f/dvc-ssh-4.1.1.tar.gz"
    sha256 "96f0baa005d0478bbbb3ed759fa360404c4f73dcabab72409a65edb8ec36dad2"
  end

  resource "dvc-studio-client" do
    url "https://files.pythonhosted.org/packages/87/08/13cf5bb8bf0855d47325467a5948848bcea51780e2212349034f5e4701e6/dvc_studio_client-0.21.0.tar.gz"
    sha256 "db212ff5cf73dce886d0713a5d2bf4bc0bbfb499f3ca8548705ca98aab5addd1"
  end

  resource "dvc-task" do
    url "https://files.pythonhosted.org/packages/19/ef/da712c4d9c7d6cacac27d7b2779e6a97c3381ef2c963c33719d39113b6a3/dvc_task-0.40.2.tar.gz"
    sha256 "909af541bf5fde83439da56c4c0ebac592af178a59b702708fadaacfd6e7b704"
  end

  resource "dvc-webdav" do
    url "https://files.pythonhosted.org/packages/56/20/7290e6bf073844970706db64109ab1fdad7038ff7a6df57dff3620170767/dvc-webdav-3.0.0.tar.gz"
    sha256 "65e7eef2ebc83415a8ddbdcb579bf219a3797c67e7a62d4568c5c82de2b6a508"
  end

  resource "dvc-webhdfs" do
    url "https://files.pythonhosted.org/packages/36/f5/249f881b2e035d6c7362733986b5545fa8c88fed451972be5d0fedae5fab/dvc-webhdfs-3.1.0.tar.gz"
    sha256 "6e894843d15ce766a05c616deda9d9bc361248e93bf9ea338b996e6e51ea0fea"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/ea/8d/a7121ffe5f402dc015277d2d31eb82d2187334503a011c18f2e78ecbb9b2/entrypoints-0.4.tar.gz"
    sha256 "b706eddaa9218a19ebcd67b56818f05bb27589b1ca9e8d797b74affad4ccacd4"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/89/c6/5fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3/flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl-lock" do
    url "https://files.pythonhosted.org/packages/a9/fa/885c58f9716063e2ac099f773d0420f20bb834b19538066a2e0d5b848ba4/flufl_lock-8.1.0.tar.gz"
    sha256 "d88302005692a63d98b60080158faf089be5ecae6969f706409da8276fdce7cb"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/62/7c/12b0943011daaaa9c35c2a2e22e5eb929ac90002f08f1259d69aedad84de/fsspec-2024.9.0.tar.gz"
    sha256 "4b0afb90c2f21832df142f292649035d80b421f60a9e1c027802e5a0da2b04e8"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/d9/9d/64fa09b9c392ee79ffaa4b26d0481d2d775ffe03969b38a4ade77bd72d15/gcsfs-2024.9.0.post1.tar.gz"
    sha256 "7ca70ee9d7c7dbce1a3e36b4883e14102c2d7b4284f49e242843a437bc684684"
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

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/cc/0f/1772edb8d75ecf6280f1c7f51cbcebe274e8b17878b382f63738fd96cee5/google_auth_oauthlib-1.2.1.tar.gz"
    sha256 "afd0cad092a2eaa53cd8e8298557d6de1034c6cb4a740500b5357b648af97263"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/b8/1f/9d1e0ba6919668608570418a9a51e47070ac15aeff64261fb092d8be94c0/google-cloud-core-2.4.1.tar.gz"
    sha256 "9b7749272a812bde58fff28868d0c5e2f585b82f37e09a1f6ed2d4d10f134073"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/d6/b7/1554cdeb55d9626a4b8720746cba8119af35527b12e1780164f9ba0f659a/google_cloud_storage-2.18.2.tar.gz"
    sha256 "aaf7acd70cdad9f274d29332673fcab98708d0e1f4dceb5a5356aaef06af4d99"
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

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/95/0e/4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659/grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "gto" do
    url "https://files.pythonhosted.org/packages/4c/5f/1c49a78fef3e040457b4195c4d7d9c315dde8bde134c0d91e9a180e1af57/gto-1.7.1.tar.gz"
    sha256 "24100e735195c0d54539401f42804fc9042998276cdc4233f49f153fd38a7d75"
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

  resource "hydra-core" do
    url "https://files.pythonhosted.org/packages/6d/8e/07e42bc434a847154083b315779b0a81d567154504624e181caf2c71cd98/hydra-core-1.3.2.tar.gz"
    sha256 "8a878ed67216997c3e9d88a8e72e7b4767e81af37afb4ea3334b269a4390a824"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "iterative-telemetry" do
    url "https://files.pythonhosted.org/packages/c7/c9/0c7ec6cfe9d0384bcfbab05f0570878f6859151ef3ce69a8762693b84c03/iterative_telemetry-0.0.9.tar.gz"
    sha256 "53686c3e912a33e8bf6975b878fd4bd0a7d589c8bad0a6a5573714af9e731dc2"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/bb/eb/1f26c9112a4ee84cfa4a0a81bdf844207496a476fa026cfc98545bb702db/knack-0.12.0.tar.gz"
    sha256 "71f2a6b42ae9a302e43243320fa05edb09b19339fcf1f331f5b6d07bf97f5291"
  end

  resource "kombu" do
    url "https://files.pythonhosted.org/packages/38/4d/b93fcb353d279839cc35d0012bee805ed0cf61c07587916bfc35dbfddaf1/kombu-5.4.2.tar.gz"
    sha256 "eef572dd2fd9fc614b37580e3caeafdd5af46c1eff31e7fba89138cdb406f2cf"
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
    url "https://files.pythonhosted.org/packages/59/04/8d7aa5c671a26ca5612257fd419f97380ba89cdd231b2eb67df58483796d/msal-1.31.0.tar.gz"
    sha256 "2c4f189cf9cc8f00c80045f66d39b7c0f3ed45873fd3d1f2af9f22db2e12ff4b"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/2d/38/ad49272d0a5af95f7a0cb64a79bbd75c9c187f3b789385a143d8d537a5eb/msal_extensions-1.2.0.tar.gz"
    sha256 "6f41b320bfd2933d631a215c91ca0dd3e67d84bd1a2f50ce917d5874ec646bef"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/36/2b/20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869/networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
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
    url "https://files.pythonhosted.org/packages/9e/03/821c8197d0515e46ea19439f5c5d5fd9a9889f76800613cfac947b5d7845/orjson-3.10.7.tar.gz"
    sha256 "75ef0640403f945f3a1f9f6400686560dbfb0fb5b16589ad62cd477043c4eee3"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/4a/e7/08b90651a435acde68c537eebff970011422f61c465f6d1c88c4b3af6774/oss2-2.18.1.tar.gz"
    sha256 "5a901f6c0f3ac42f792e16a1e1c04e60f34e6cc9eb2bc4c0c3ce6e7bda2da4cc"
  end

  resource "ossfs" do
    url "https://files.pythonhosted.org/packages/d2/42/4cdce6e1ff4ce53c33cdc0dc1d212207181af3037d0a3a789367da42a266/ossfs-2023.12.0.tar.gz"
    sha256 "f99eb2d74717d22551b1f32ec9434587962627a816a64536dc47d68470536110"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/2d/4f/feb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127/prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a9/4d/5e5a60b78dbc1d464f8a7bbaeb30957257afdc8512cbb9dfd5659304f5cd/propcache-0.2.0.tar.gz"
    sha256 "df81779732feb9d01e5d513fad0122efb3d53bbc75f61b2a4f29a020bc985e70"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/3e/fc/e9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29/proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/b1/a4/4579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549/protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/27/4e/ea6d43f324169f8aec0e57569443a38bab4b398d09769ca64f7b4d467de3/pyarrow-17.0.0.tar.gz"
    sha256 "4beca9521ed2c0921c1023e68d097d0299b62c362639ea315572a58f3f50fd28"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/13/52/13b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6/pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/a9/b7/d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30/pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e2/aa/6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3/pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/85/10/4e4da8c271540dc35914e927546cbb821397f0f9477f4079cd8732946699/pydot-3.0.2.tar.gz"
    sha256 "9180da540b51b3aa09fbf81140b3edfbe2315d778e8589a7d0a4a69c41332bae"
  end

  resource "pydrive2" do
    url "https://files.pythonhosted.org/packages/12/af/f065e829aa5a4e9caa24a7a5dcb00c229bf5c61957cbc56edbe9a910bf5c/pydrive2-1.20.0.tar.gz"
    sha256 "168ba6eb6d83c9b082f05bc8cb95ee93ce62389db3b559ff0e769b5bb8b2b10a"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/a4/85/c848cdf44214bf541c4a725a0a6e271f8db9f18cfccef702d53f83f1e19a/pygit2-1.16.0.tar.gz"
    sha256 "7b29a6796baa15fc89d443ac8d51775411d9b1e5b06dc40d458c56c8576b48a2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/b9/13/55deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5f/pygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/fb/68/ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020e/pyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/83/08/13f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043a/pyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
    url "https://files.pythonhosted.org/packages/aa/9e/1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95/rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/e3/de/1dbadd86b81a587d9d6cce18512ab130062d386edf0e368a1ff7c2e2f462/s3fs-2024.9.0.tar.gz"
    sha256 "6493705abb50374d6b7994f9616d27adbdd8a219c8635100bdc286382efd91f5"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/d6/19/82a0dac4531c486f079c304397acf48bafae80d92ad05161ac9fa1c787fd/scmrepo-3.3.8.tar.gz"
    sha256 "e0d71cef4725dbee2cefab0cfff0a3a65d8cc213a53b468d4e3fa61ba2ec66f4"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/8c/e2/bcf761f3bff95856203f9559baf3741c416071dd200c0fc19fad7f078f86/shortuuid-1.0.13.tar.gz"
    sha256 "3bb9cf07f606260584b1df46399c0b87dd84773e7b25912b7e391e30797c5e72"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/a9/e4/13bf30c7c30ab86a7bc4104b1c943ff2f56c1a07c6d82a71ad034bcef1dc/shtab-1.7.1.tar.gz"
    sha256 "4e4bcb02eeb82ec45920a5d0add92eac9c9b63b2804c9196c1f1fdc2d039243c"
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

  resource "sqltrie" do
    url "https://files.pythonhosted.org/packages/16/03/15df5398fcfe8b5f7fa704a85b44d2bb679c825b22a5cd5592d4cfb11b0b/sqltrie-0.11.1.tar.gz"
    sha256 "56963921dec494881b048e968d5556a90ed273b5dba1ea0aaac462f3b9815d21"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/c8/8d/4ea67c38d2884effaf2874d76ffe6a790ef9998a383a52e920dec966c230/sshfs-2024.9.0.tar.gz"
    sha256 "53589de34083f7f59203473526d80d9b1692267c37bf51f007d589660feaf458"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/c5/58/a79003b91ac2c6890fc5d90145c662fd5771c6f11447f116b63300436bc9/typer-0.12.5.tar.gz"
    sha256 "f592f089bedcc8ec1b974125d64851029c3b1af145f04aca64d69410f0c9b722"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/e1/34/943888654477a574a86a98e9896bae89c7aa15078ec29f490fef2f1e5384/tzdata-2024.2.tar.gz"
    sha256 "7d85cc416e9382e69095b7bdf4afd9e3880418a2413feec7069d533d6b4e31cc"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "vine" do
    url "https://files.pythonhosted.org/packages/bd/e4/d07b5f29d283596b9727dd5275ccbceb63c44a1a82aa9e4bfd20426762ac/vine-5.1.0.tar.gz"
    sha256 "8b62e981d35c41049211cf62a0a1242d8c1ee9bd15bb196ce38aefd6799e61e0"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/91/af/a54ce0fb6f1d867e0b9f0efe5f082a691f51ccf705188fca67a3ecefd7f4/voluptuous-0.15.2.tar.gz"
    sha256 "6ffcab32c4d3230b4d2af3a577c87e1908a714a11f6f95570456b1849b0279aa"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "webdav4" do
    url "https://files.pythonhosted.org/packages/08/3d/d604f9d5195689e578f124f196a5d7e80f3106c8404f5c19b2181691de19/webdav4-0.10.0.tar.gz"
    sha256 "387da6f0ee384e77149dddd9bcfd434afa155882f6c440a529a7cb458624407f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/46/fe/2ca2e5ef45952f3e8adb95659821a4e9169d8bbafab97eb662602ee12834/yarl-1.14.0.tar.gz"
    sha256 "88c7d9d58aab0724b979ab5617330acb1c7030b79379c8138c1c8c94e121d1b3"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/5b/83/a5432aa08312fc834ea594473385c005525e6a80d768a2ad246e78877afd/zc.lockfile-3.0.post1.tar.gz"
    sha256 "adb2ee6d9e6a2333c91178dcb2c9b96a5744c78edb7712dc784a7d75648e81ec"
  end

  def install
    if DevelopmentTools.clang_build_version >= 1500
      # Work around an Xcode 15 linker issue which causes linkage against LLVM's
      # libunwind due to it being present in a library search path.
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    end

    # dvc-hdfs uses fsspec.implementations.arrow.HadoopFileSystem which is
    # a wrapper on top of pyarrow.fs.HadoopFileSystem.
    ENV["PYARROW_WITH_HDFS"] = "1"

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
