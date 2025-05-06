class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/f3/9d/c7c143684a87119213dcbe1a7da36d5e5d701467a2da3a9d0ae1d428e3b9/dvc-3.59.2.tar.gz"
  sha256 "3eecc058b5d43e4e3ff7dfa72970a5c7d26e7b19f48395946ab314ce479bc1ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c01237910bd753e3907b8a46e98e5469a2e0f09881904581678606cf1dfbf8d0"
    sha256 cellar: :any,                 arm64_sonoma:  "2cbf501a191637cf2d808634e1fffd969f5af2f51327f0893419ef91c701382e"
    sha256 cellar: :any,                 arm64_ventura: "fc8e7cc8b3617e0c7081c3b018b63b6dd9a5aaf695175c44041cbe92e3559c92"
    sha256 cellar: :any,                 sonoma:        "e26eb7148d04d1903872e08d70a11174c66513146ddbacb377948699201a7195"
    sha256 cellar: :any,                 ventura:       "72d11017a107ad1898bfee3e711dda45e35d1ac71288952fa77e7df8b8f963b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab56d99dd8fd9fc9e267a48fee69a6efa87cf6bcd8929c561cc986745f1cc531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94694d476ef7dfe9030abfbd0f2d692a3fa68f2d8b28db219992c175eaf8c788"
  end

  depends_on "cmake" => :build # for pyarrow
  depends_on "ninja" => :build # for pyarrow
  depends_on "openjdk" => :build # for hydra-core
  depends_on "rust" => :build # for bcrypt
  depends_on "apache-arrow"
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pygit2"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/76/82/e30891af574fb358449fb9436aac53569814452cb88b0cba4f488171b8dc/adlfs-2024.12.0.tar.gz"
    sha256 "04582bf7461a57365766d01a295a0a88b2b8c42c4fea06e2d673f62675cac5c6"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/9c/4c/113c4f5611103bba8e5252805fbee7944f5d9541addba9a96b091c0c4308/aiobotocore-2.22.0.tar.gz"
    sha256 "11091477266b75c2b5d28421c1f2bc9a87d175d0b8619cb830805e7a113a170b"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/63/e7/fa1a8c00e2c54b05dc8cb5d1439f627f7c267874e3f7bb047146116020f9/aiohttp-3.11.18.tar.gz"
    sha256 "ae856e1138612b7e412db63b7708735cff4d38d0399f6a5435d3dac2669f558a"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/9d/61/ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033/aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
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
    url "https://files.pythonhosted.org/packages/ba/b5/6d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473d/aiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
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
    url "https://files.pythonhosted.org/packages/79/fc/ec94a357dfc6683d8c86f8b4cfa5416a4c36b28052ec8260c77aca96a443/amqp-5.3.1.tar.gz"
    sha256 "cddc00c725449522023bad949f70fff7b48f0b1ade74d170a6f10ab044739432"
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
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/e8/d6/823ed5a227f7da70b33681e49eec4a36fae31b9296b27a8d6aead2bd3f77/asyncssh-2.21.0.tar.gz"
    sha256 "450fe13bb8d86a8f4e7d7b5fafce7791181ca3e7c92e15bbc45dfb25866e48b3"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/fa/af/d5113daf3947044e43d74305cbd31502915c784e158c0c098db03ceeff17/atpublic-5.1.tar.gz"
    sha256 "abc1f4b3dbdd841cc3539e4b5e4f3ad41d658359de704e30cb36da4d4e9d3022"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/c9/29/ff7a519a315e41c85bab92a7478c6acd1cf0b14353139a08caee4c691f77/azure_core-1.34.0.tar.gz"
    sha256 "bdb544989f246a0ad1c85d72eeb45f2f835afdcbc5b45e43f0dbde7461c81ece"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/22/ff/61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17/azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/b5/a1/f1a683672e7a88ea0e3119f57b6c7843ed52650fdcac8bfa66ed84e86e40/azure_identity-1.21.0.tar.gz"
    sha256 "ea22ce6e6b0f429bc1b8d9212d5b9f9877bd4c82f1724bfa910760612c07a9a6"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/8b/f3/f764536c25cc3829d36857167f03933ce9aee2262293179075439f3cd3ad/azure_storage_blob-12.25.1.tar.gz"
    sha256 "4f294ddc9bc47909ac66b8934bd26b50d2000278b10ad82cc109764fdc6e0e3b"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/bb/5d/6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77b/bcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/7c/58/1546c970afcd2a2428b1bfafecf2371d8951cc34b46701bea73f4280989e/billiard-4.2.1.tar.gz"
    sha256 "12b641b0c539073fc8d3f5b8b7be998956665c4233c7c1fcd66a7e677c4fb36f"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/7e/3f/135ec0771e6d0e1af2ad7023a15df6677d96112072838d948c9b5075efe1/boto3-1.37.3.tar.gz"
    sha256 "21f3ce0ef111297e63a6eb998a25197b8c10982970c320d4c6e8db08be2157be"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/74/fb/b243ab806d2e1e6b8a475b731cc59a1f1e4709eded4884b988a27bbc996b/botocore-1.37.3.tar.gz"
    sha256 "fe8403eb55a88faf9b0f9da6615e5bee7be056d75e17af66c3c8f0a3b0648da4"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/bf/03/5d9c6c449248958f1a5870e633a29d7419ff3724c452a98ffd22688a1a6a/celery-5.5.2.tar.gz"
    sha256 "4d6930f354f9d29295425d7a37261245c74a32807c45d764bedc286afd0e724e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
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
    url "https://files.pythonhosted.org/packages/d4/8b/0f2de00c0c0d5881dc39be147ec2918725fb3628deeeb1f27d1c6cf6d9f4/dulwich-0.22.8.tar.gz"
    sha256 "701547310415de300269331abe29cb5717aa1ea377af826bf513d0adfb1c209b"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/b1/cd/5cf47247c82e7b8eba42890a23e6700f4baade329d24722140d290c32dc3/dvc-azure-3.1.0.tar.gz"
    sha256 "52cbc70d5414b50219b3db0a16f68ad25daba76e3f220aebe4e49b3c6498ae20"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/da/64/459483623d867d2161e3aacecc5f9f172e8a57438cfcfc029e00be5fb594/dvc_data-3.16.10.tar.gz"
    sha256 "abca33f2169eabc70d1966e2ef3cd290127ebdf141fb0e84db3d37fef49205c6"
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
    url "https://files.pythonhosted.org/packages/2d/84/7cb9ee1eb82bd384f36eabc3afd18a659d9a669c16e3c78d947e6e0be7c1/dvc_ssh-4.2.1.tar.gz"
    sha256 "95deae680200fbc9472bf4e32adae3b6618a8f9f38ed204c618bca28df8c912e"
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
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
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
    url "https://files.pythonhosted.org/packages/ee/f4/d744cba2da59b5c1d88823cf9e8a6c74e4659e2b27604ed973be2a0bf5ab/frozenlist-1.6.0.tar.gz"
    sha256 "b99655c32c1c8e06d111e7f41c06c29a5318cb1835df23a45518e02a47c63b68"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/45/d8/8425e6ba5fcec61a1d16e41b1b71d2bf9344f1fe48012c2b48b9620feae5/fsspec-2025.3.2.tar.gz"
    sha256 "e52c77ef398680bbd6a98c0e628fbc469491282981209907bbc8aea76a04fdc6"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/28/66/b606240ebe8f6e85db225e1ab6f9c73f0f3929d2af9dee59807d5d5088cb/gcsfs-2025.3.2.tar.gz"
    sha256 "fe300179492e63e309fecb11e4de7c15a51172eefa2b846d4b3659960216bba8"
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
    url "https://files.pythonhosted.org/packages/8b/03/6b824ef961fb2ab74f3b54adf2a357f742d88e0667a3471621cb9477da96/google_auth-2.40.0.tar.gz"
    sha256 "c277cf39f7c192d8540eb6331c08b5a0796e8041af8343ae73dd6b269732ca6c"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/fb/87/e10bf24f7bcffc1421b84d6f9c3377c30ec305d082cd737ddaa6d8f77f7c/google_auth_oauthlib-1.2.2.tar.gz"
    sha256 "11046fb8d3348b296302dd939ace8af0a724042e8029c1b872d87fabc9f41684"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/d6/b8/2b53838d2acd6ec6168fd284a990c76695e84c65deee79c9f3a4276f6b4f/google_cloud_core-2.4.3.tar.gz"
    sha256 "1fab62d7102844b278fe6dead3af32408b1df3eb06f5c7e8634cbd40edc4da53"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/f3/08/52143124415a889bbab60a8ecede1e31ea0e8d992ca078317886f26dc3be/google_cloud_storage-3.1.0.tar.gz"
    sha256 "944273179897c7c8a07ee15f2e6466a02da0c7c4b9ecceac2a26017cb2972049"
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

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/95/0e/4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659/grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "gto" do
    url "https://files.pythonhosted.org/packages/d6/ea/ea6267da29ac54a53944106e46337e3e8e43eaa24bb6b7cf5da18043758c/gto-1.7.2.tar.gz"
    sha256 "98994f43d02ef6d4e77c4087b1c0c70a038e4a753a5583c23116246d33b89742"
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
    url "https://files.pythonhosted.org/packages/d2/b6/f17d6e80252b7be6ca4d9463db226ce7863d26287f16f1347e981cd2f3d8/iterative_telemetry-0.0.10.tar.gz"
    sha256 "7fde6111de6fa4acf5a95a6190cc9cc5d17d835a815f0a18ece201f6031f4ed6"
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
    url "https://files.pythonhosted.org/packages/60/0a/128b65651ed8120460fc5af754241ad595eac74993115ec0de4f2d7bc459/kombu-5.5.3.tar.gz"
    sha256 "021a0e11fcfcd9b0260ef1fb64088c0e92beb976eb59c1dfca7ddd4ad4562ea2"
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
    url "https://files.pythonhosted.org/packages/3f/90/81dcc50f0be11a8c4dcbae1a9f761a26e5f905231330a7cacc9f04ec4c61/msal-1.32.3.tar.gz"
    sha256 "5eea038689c78a5a70ca8ecbe1245458b55a857bd096efb6989c69ba15985d35"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/01/99/5d239b6156eddf761a636bded1118414d161bd6b7b37a9335549ed159396/msal_extensions-1.3.1.tar.gz"
    sha256 "c5b0fd10f65ef62b5f1d62f4251d51cbcaf003fcedae8c91b040a488614be1a4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/da/2c/e367dfb4c6538614a0c9453e510d75d66099edf1c4e69da1b5ce691a1931/multidict-6.4.3.tar.gz"
    sha256 "3ada0b058c9f213c5f95ba301f922d402ac234f1111a7d8fd70f1b99f3c281ec"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
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
    url "https://files.pythonhosted.org/packages/81/0b/fea456a3ffe74e70ba30e01ec183a9b26bec4d497f61dcfce1b601059c60/orjson-3.10.18.tar.gz"
    sha256 "e8da3947d92123eda795b68228cafe2724815621fe35e8e320a9e9593a4bcd53"
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
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/07/c8/fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40/propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c8/8c/cf2ac658216eebe49eaedf1e06bc06cbf6a143469236294a1171a51357c3/protobuf-6.30.2.tar.gz"
    sha256 "35c859ae076d8c56054c25b59e5e59638d86545ed6e2b6efac6be0b6ea3ba048"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/7f/09/a9046344212690f0632b9c709f9bf18506522feb333c894d0de81d62341a/pyarrow-19.0.1.tar.gz"
    sha256 "3bf266b485df66a400f282ac0b6d1b500b9d2ae73314a153dbe97d6d5cc8a99e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/44/e6/099310419df5ada522ff34ffc2f1a48a11b37fc6a76f51a6854c182dbd3e/pycryptodome-3.22.0.tar.gz"
    sha256 "fd7ab568b3ad7b77c908d7c3f7e167ec5a8f035c64ff74f10d47a4edd043d723"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/77/ab/5250d56ad03884ab5efd07f734203943c8a8ab40d551e208af81d0257bf2/pydantic-2.11.4.tar.gz"
    sha256 "32738d19d63a226a52eed76645a98ee07c1f410ee41d93b4afbfa85ed8111c2d"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/d1/c3/6034ed1ebf2e3ba95a0e35fa7c43104e40444c0ed2b5325702c63e824dbf/pydot-4.0.0.tar.gz"
    sha256 "12f16493337cade2f7631b87c8ccd299ba2e251f3ee5d0732a058df2887afe97"
  end

  resource "pydrive2" do
    url "https://files.pythonhosted.org/packages/3f/dc/92b0beba58f09441219bb6720bebdb895317632db4778cfe1d21532d27e5/pydrive2-1.21.3.tar.gz"
    sha256 "649b84d60c637bc7146485039535aa8f1254ad156423739f07e5d32507447c13"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/b9/13/55deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5f/pygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
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
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/72/df/559dc6d796c38f1b8a09a5f6dcf62a467a84f3c87a837ee07c59f60a26ad/s3fs-2025.3.2.tar.gz"
    sha256 "6798f896ec76dd3bfd8beb89f0bb7c5263cb2760e038bae0978505cd172a307c"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/39/24/1390172471d569e281fcfd29b92f2f73774e95972c965d14b6c802ff2352/s3transfer-0.11.3.tar.gz"
    sha256 "edae4977e3a122445660c7c114bba949f9d191bae3b34a096f18a1c8c354527a"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/25/c9/a05b8ce93ce8470e44f430f664396396b6b183cbe899407e8cd286a29165/scmrepo-3.3.11.tar.gz"
    sha256 "eb25424a7cc1290e3e0aeaa8a39bb8347b9abc5fab33356e8a70db530d7d06b6"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/dc/3976b322de9d2e87ed0007cf04cc7553969b6c7b3f48a565d0333748fbcd/setuptools-80.3.1.tar.gz"
    sha256 "31e2c58dbb67c99c289f51c16d899afedae292b978f8051efaf6262d8212f927"
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
    url "https://files.pythonhosted.org/packages/5a/3e/837067b970c1d2ffa936c72f384a63fdec4e186b74da781e921354a94024/shtab-1.7.2.tar.gz"
    sha256 "8c16673ade76a2d42417f03e57acf239bfb5968e842204c17990cae357d07d6f"
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

  resource "sqltrie" do
    url "https://files.pythonhosted.org/packages/8a/e6/f3832264bcd98b9e71c93c579ab6b39eb1db659cab305e59f8f7c1adc777/sqltrie-0.11.2.tar.gz"
    sha256 "4df47089b3abfe347bcf81044e633b8c7737ebda4ce1fec8b636a85954ac36da"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/5a/e6/74b6119fdaf81cadc4b404f6abf681836209a9d22f7f0c1b08760460e5c5/sshfs-2025.2.0.tar.gz"
    sha256 "1a60b872062078cfb9d954d9c728f3e72e5bc81aa913dc0f91e687305a005fe1"
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
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/98/1a/5f36851f439884bcfe8539f6a20ff7516e7b60f319bbaf69a90dc35cc2eb/typer-0.15.3.tar.gz"
    sha256 "818873625d0569653438316567861899f7e9972f2e6e0c16dab608345ced713c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
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
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/62/51/c0edba5219027f6eab262e139f73e2417b0f4efffa23bf562f6e18f76ca5/yarl-1.20.0.tar.gz"
    sha256 "686d51e51ee5dfe62dec86e4866ee0e9ed66df700d55c828a615640adc885307"
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
