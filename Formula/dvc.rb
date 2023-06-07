class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://files.pythonhosted.org/packages/b4/2f/7bbbc279bffe43a8fb050da1626bf52f2b0f605ecb96744b767453700752/dvc-2.58.2.tar.gz"
  sha256 "d40fff99b76719d1d524f103ad9dc64141bb363492abb9b8a61c6e70efe5a4dc"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "419bb9b33c60e2a4d2e9453cdaecb666541c620abbf34b5eff81610786f3bc8a"
    sha256 cellar: :any,                 arm64_monterey: "af9a6ed6b76836b855740c4d20e7a4af2f683e72086fca24ef51a5c88fc8f809"
    sha256 cellar: :any,                 arm64_big_sur:  "c0afb3902b25de478fc385b5627a099b2e956808e3ca226bf4706fd62e7a0878"
    sha256 cellar: :any,                 ventura:        "06a7a1b7da15e80cba6cc7d43ed86897081b771c6bed0ffdfa9b0526c0fd7440"
    sha256 cellar: :any,                 monterey:       "832223bda81b67acf1e62e797ee789a672c7549560b3882fdf99ec26c98ff6d7"
    sha256 cellar: :any,                 big_sur:        "209172f1e61368df3d0ab0f7dc6859525571d2fc602c7c0f17732b3b762812be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f93d59ce2b8b10d0418d53968dd730f71caa7cd2e3a75ab415b07dc744e6b2c"
  end

  depends_on "openjdk" => :build # for hydra-core
  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for cryptography (required by azure deps)
  depends_on "apache-arrow"
  depends_on "cffi"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf@21"
  depends_on "pycparser"
  depends_on "pygit2"
  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/8a/4d/90ab49b86b63b3139d082d8ccea240d14c4201ec2971d38196c72ff9e06c/adlfs-2023.4.0.tar.gz"
    sha256 "84bf8875c57d6cc7e8b3f38034b117b4f43be1c7010aef9947bb5044c7b2fa37"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/e4/d4/28b8c4c9443ffdd1a97b4b0bb970877697deee43e5956bc86028a2723c17/aiobotocore-2.5.0.tar.gz"
    sha256 "6a5b397cddd4f81026aa91a14c7dd2650727425740a5af8ba75127ff663faf67"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c2/fd/1ff4da09ca29d8933fda3f3514980357e25419ce5e0f689041edb8f17dab/aiohttp-3.8.4.tar.gz"
    sha256 "bf2e1a9162c1e441bf805a1fd166e249d574ca04e03b34f97e2928769e91ab5c"
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
    url "https://files.pythonhosted.org/packages/a7/e8/28994262c4fb5e79720a3051e67cce609684f2127e586314bc5e89d0bd41/aiooss2-0.2.5.tar.gz"
    sha256 "49db023f2b9c8bd8c9ed5d241c2ff3b42831b468b2cfa1b96ac6700b94fd053d"
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
    url "https://files.pythonhosted.org/packages/5c/48/b6b50298e4c6f9a84fd21ab74649d416c38543b2c627c7c4b2443c5583ff/aliyun-python-sdk-kms-2.16.1.tar.gz"
    sha256 "a372737715682014bace68bd40fe83332f4fd925009a3eb110d41bc66f270e7a"
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
    url "https://files.pythonhosted.org/packages/c6/b3/fefbf7e78ab3b805dec67d698dc18dd505af7a18a8dd08868c9b4fa736b5/anyio-3.7.0.tar.gz"
    sha256 "275d9973793619a5374e1c89a4f4ad3f4b0a5510a2b5b939444bee8f4c4d37ce"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/42/cd/fdb872d826b76b65b23147e83b1ca4c033445bbff59f8836a118657dd050/argcomplete-3.0.8.tar.gz"
    sha256 "b9ca96448e14fa459d7450a4ab5a22bbf9cee4ba7adddf03e65c398b5daeea28"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/dc/86/ebdf32baf71ac57d3ee135c0844eda7cce744746bcc9c6399c978e356a2b/asyncssh-2.13.1.tar.gz"
    sha256 "ebbb83c05c0b45cf230de1ef2f06059e360f9afa5c3ddf60fc92faf7b94ff887"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/8e/9a/ff8783e9e181ead59ae612a5df5bcd4f4bb3cc4147ef6aaa96f90020347b/atpublic-3.1.1.tar.gz"
    sha256 "3098ee12d0107cc5009d61f4e80e5edcfac4cda2bdaa04644af75827cb121b18"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/5a/47/f317d1eb9cc7e9260d336c2d1cc7870e9a388deb26d8c8e763c2048c82c5/azure-core-1.26.4.zip"
    sha256 "075fe06b74c3007950dd93d49440c2f3430fd9b4a5a2756ec8c79454afc989c6"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/22/ff/61369d06422b5ac48067215ff404841342651b14a89b46c8d8e1507c8f17/azure-datalake-store-0.0.53.tar.gz"
    sha256 "05b6de62ee3f2a0a6e6941e6933b792b800c3e7f6ffce2fc324bc19875757393"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/ad/3e/34b445ef2f536f4710903cbc3ca33c4272ad37f676609188c4544dc8463a/azure-identity-1.13.0.zip"
    sha256 "c931c27301ffa86b07b4dcf574e29da73e3deba9ab5d1fe4f445bb6a3117e260"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/fb/b1/5f043703c58cb67f113dded485ef3d7610e215b3921c65e52030791b7c76/azure-storage-blob-12.16.0.zip"
    sha256 "43b45f19a518a5c6895632f263b3825ebc23574f25cc84b66e1630a6160e466f"
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
    url "https://files.pythonhosted.org/packages/29/a8/3ffdf9744fd5d0330cd0303ff3bd52c1491934e5bd5fba2353d14641685f/boto3-1.26.76.tar.gz"
    sha256 "30c7d967ed1c6b5a05643e42cae9d4d36c3f1cb6782637ddc7007a104cfd9027"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/fb/4b/87b54878085654cd3a01175b849e273cbf049bc01a141e1b9b512d956a9a/botocore-1.29.76.tar.gz"
    sha256 "c2f67b6b3f8acf2968eafca06526f07b9fb0d27bac4c68a635d51abb675134a7"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/ce/21/41a0028f6d610987c0839250357c1a00f351790b8a448c2eb323caa719ac/celery-5.2.7.tar.gz"
    sha256 "fafbd82934d30f8a004f81e8f7a062e31413a23d444be8ee3326553915958c6d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
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

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/bf/92/3301a5d4fb734290a8bca5a9aad61ea61327ed53cb19be110d4f3548df76/cryptography-41.0.0.tar.gz"
    sha256 "6b71f64beeea341c9b4f963b48ee3b62d62d57ba93eb120e1196b31dc1025e78"
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
    url "https://files.pythonhosted.org/packages/7b/65/5d93ced326fe943ca8970848fd0522be81868a9afa169a22fd19cd737d5c/diskcache-5.6.1.tar.gz"
    sha256 "e4c978532feff5814c4cc00fe1e11e40501985946643d73220d41ee7737c72c3"
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
    url "https://files.pythonhosted.org/packages/8c/6c/57adedfc2e1debb62581e9b413d2be78ea62e1da47d21fdd9d0d10317ebc/dulwich-0.21.5.tar.gz"
    sha256 "70955e4e249ddda6e34a4636b90f74e931e558f993b17c52570fa6144b993103"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/40/17/ff242c7e0d00c967239690424ec276e716551b42ddde744fecff25bd79a7/dvc-azure-2.21.2.tar.gz"
    sha256 "013c55209eaa34dbb3e29fc399c6c1adcf0aca97d8aae938cbf5d02bb26694f1"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/d4/04/cd67304609016a72da27515e7dce5bc0adc7e12523576d17030725fd8dfc/dvc-data-0.51.0.tar.gz"
    sha256 "32544bb7d3ae509f91c2d07a9dc3739dd87980be5b41582781efb4f246b58497"
  end

  resource "dvc-gdrive" do
    url "https://files.pythonhosted.org/packages/c2/0c/b1e1e4d514b080caf0499aa1bb293010084030d343578992a22b20f6e6c1/dvc-gdrive-2.19.2.tar.gz"
    sha256 "e1467fdf4a22dbaa676cced1345a53cc5db4ca474f88a9e1e061682396f6322b"
  end

  resource "dvc-gs" do
    url "https://files.pythonhosted.org/packages/bb/0c/16abbf42826e892e65f4d952e8582f6132597e52375a8e4c630ac1049b84/dvc-gs-2.22.0.tar.gz"
    sha256 "533616da253f1af2c9778aba12b70b411a007a1c851773eb3138dbf0f12d98d1"
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
    url "https://files.pythonhosted.org/packages/1a/78/9cf2d0bec6bc4bdd4c5a318fdee9b1b55aa3d701b4da27b48989000ca8e3/dvc-objects-0.22.0.tar.gz"
    sha256 "911a5fc0de89ea40118af3a2752a23f769ab5c865484637f47bd74f1e8577f83"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/a9/76/1f612a3e4c9c734ae8fa091cb9199c1c2ea1d498415ba1ccbb50ef8d6805/dvc-oss-2.19.0.tar.gz"
    sha256 "0927f3b0346a59fd31685ecbda2d6f099b74b3def7d574a6af23992ef3851b4b"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/90/bf/09a963c059405d188dd9290f26855893f0b8fa91e839f4631293ef94449d/dvc-render-0.5.3.tar.gz"
    sha256 "009dc09db44e416285c719324d8e101f675a58d7d846822a9faef307df22c7f2"
  end

  resource "dvc-s3" do
    url "https://files.pythonhosted.org/packages/d1/2e/b2ccb12d8f9d7bedcc3217f4b54508b70f6eb7beaae38336eb73d7344ce7/dvc-s3-2.22.0.tar.gz"
    sha256 "d7d8ff243f0a64440a6a3e791d812e707c21fcb509fbcf0f3c512a016a2fd868"
  end

  resource "dvc-ssh" do
    url "https://files.pythonhosted.org/packages/86/17/632326fb15de6db89d40a090bfb3adef400c9f7f0620e7de0f2fe702e5aa/dvc-ssh-2.22.1.tar.gz"
    sha256 "58715fab40b0d7b01682652591950e3bab7a5dc3d88cb1d4cf8b34c1c5589257"
  end

  resource "dvc-studio-client" do
    url "https://files.pythonhosted.org/packages/fd/bc/1344dc295451c2c15d21c1402f2b751c3d2d07bc768727431b8476cf75b7/dvc-studio-client-0.10.0.tar.gz"
    sha256 "1d6c70d7c802e150a61e71c0205555a972898c340f25ab1f759564bd88c0f248"
  end

  resource "dvc-task" do
    url "https://files.pythonhosted.org/packages/cd/b2/1c292c5edeb252585143e84d82ba26b8d9b1090f170ab5101b0099cdea7d/dvc-task-0.2.1.tar.gz"
    sha256 "c42b9bb6a8e64c80e20728926f0f8147aa25b696c78876e5dfff0a293d14c735"
  end

  resource "dvc-webdav" do
    url "https://files.pythonhosted.org/packages/65/68/49aac94af79dbc7662384c943fc0fa021adfe586f7f5899b232d5ab8a326/dvc-webdav-2.19.1.tar.gz"
    sha256 "1f24207d2ec94ed295e438a5182c4c817ab60d067c0cf0f6a0d4f9dbfe5e8ad1"
  end

  resource "dvc-webhdfs" do
    url "https://files.pythonhosted.org/packages/d2/a4/f975f7ebac05fe70b3fc2621a30958d330b827fc8814c6a6ca388f503cf3/dvc-webhdfs-2.19.0.tar.gz"
    sha256 "fc438e40fe9c0b5cc213c0b0f8767f5bd5025397bc58fc61b097f86ae0028ff9"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
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
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/4e/5f/faee1c6261997e5b0782f48db9d01dc8ce7aa817d2016dd5cd64c60b1d86/fsspec-2023.5.0.tar.gz"
    sha256 "b3b56e00fb93ea321bc9e5d9cf6f8522a0198b20eb24e02774d329e9c6fb84ce"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/7e/fd/286c393076e7a101af5a2ff621413800a0055c17f64975d5e185904c1400/gcsfs-2023.5.0.tar.gz"
    sha256 "02a815e1cf28197ab4f57335e89dc5df8744a065c7c956d42692b50a9e8f1625"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/2b/15/7bafa5379a228ed72baf769eea5e6019a944469fe637ea0742c0351109bf/google-api-core-2.11.0.tar.gz"
    sha256 "4b9bb5d5a380a0befa0573b302651b8a9a89262c1730e37bf423cec511804c22"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/82/9d/22aac91db2ae696423ef5d5331781b7119e54cad0807da81ee8a6ba6129e/google-api-python-client-2.88.0.tar.gz"
    sha256 "37068453f79ea28e5394a8fe20a4ba620594e7f8541068bea2e844dacdcc9d33"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/97/e8/a3e918ab46e91e87019e2f96aec2390e11177da536b7bc75d14c8534d9c9/google-auth-2.19.0.tar.gz"
    sha256 "f39d528077ac540793dd3c22a8706178f157642a67d874db25c640b7fead277e"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/e3/b4/ef2170c5f6aa5bc2461bab959a84e56d2819ce26662b50038d2d0602223e/google-auth-oauthlib-1.0.0.tar.gz"
    sha256 "e375064964820b47221a7e1b7ee1fd77051b6323c3f9e3e19785f78ab67ecfc5"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/40/4b/f4cebb92fe965f02f4a9c06f16355cf83a61a2d5db110df9af71191c830a/google-cloud-core-2.3.2.tar.gz"
    sha256 "b9529ee7047fd8d4bf4a2182de619154240df17fbe60ead399078c1ae152af9a"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/fc/50/c9998f84fd8ce8799d7f8020466bbc5c9e3b1126b04a09fdb02378d451b0/google-cloud-storage-2.9.0.tar.gz"
    sha256 "9b6ae7b509fc294bdacb84d0f3ea8e20e2c54a8b4bbe39c5707635fec214eff3"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/d3/a5/4bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352/google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/c0/1b/173eacfeb03e6d026c932cb810ace18987dc9ca219154c89d7746b348b9c/google-resumable-media-2.5.0.tar.gz"
    sha256 "218931e8e2b2a73a58eb354a288e03a0fd5fb1c4583261ac6e4c078666468c93"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/9a/19/02a6256e00653b0fec9f356678df0ed996cb9d89aeb472c8c4df9490cac0/googleapis-common-protos-1.59.0.tar.gz"
    sha256 "4168fcb568a826a52f23510412da405abd93f4d23ba544bb68d943b14ba3cb44"
  end

  resource "grandalf" do
    url "https://files.pythonhosted.org/packages/95/0e/4ac934b416857969f9135dec17ac80660634327e003a870835dd1f382659/grandalf-0.8.tar.gz"
    sha256 "2813f7aab87f0d20f334a3162ccfbcbf085977134a17a5b516940a93a77ea974"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/b3/ad/7002a6f8e6ce0a246c991e00ba79b26ad06d307421a160214df24de5651f/httpcore-0.17.2.tar.gz"
    sha256 "125f8375ab60036db632f34f4b627a9ad085048eef7cb7d2616fea0f739f98af"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f8/2a/114d454cb77657dbf6a293e69390b96318930ace9cd96b51b99682493276/httpx-0.24.1.tar.gz"
    sha256 "5853a43053df830c20f8110c5e69fe44d035d850b2dfe795e196f00fdb774bdd"
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
    url "https://files.pythonhosted.org/packages/2e/9c/b6fc4ca774d3730fd1c2c9fe516afc223562976a4bcf0cec6e9e4dbf38c5/knack-0.10.1.tar.gz"
    sha256 "c5728128297e6d269791085cf96c2ffdfcef58cf83c634a5cb92eb03b2929838"
  end

  # pin kombu==5.3.0b3, see discussions in https://github.com/iterative/dvc/issues/9328
  resource "kombu" do
    url "https://files.pythonhosted.org/packages/d4/a2/22b38b4e629ce01b918e6678686fd9c157dd049cb98081b2119efae3b979/kombu-5.3.0b3.tar.gz"
    sha256 "316df5e840f284d0671b9000bbf747da2b00f3b81433c720de66a5f659e5711d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/10/b1/a648bdd3116d0028685987fb4120a37bb91d268509e09dfbafd6ae8bed87/msal-1.22.0.tar.gz"
    sha256 "8a82f5375642c1625c89058018430294c109440dce42ea667d466c2cab520acd"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "nanotime" do
    url "https://files.pythonhosted.org/packages/d5/54/6d5924f59cf671326e7809f4b3f70fa8df535d67e952ad0b6fea02f52faf/nanotime-0.5.2.tar.gz"
    sha256 "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b"
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
    url "https://files.pythonhosted.org/packages/c8/a1/c7ded18ed1952bed15439f2331752b5ef0d33f1d9a0f9fdeee7549a84c8d/orjson-3.8.14.tar.gz"
    sha256 "5ea93fd3ef7be7386f2516d728c877156de1559cda09453fc7dd7b696d0439b3"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/86/e7/017f8a5948d70e130815eebd14c25dfad916bd574590f2d7e046f19eee3f/oss2-2.17.0.tar.gz"
    sha256 "da4489b89c76ec72c9dd4888bd2787c9e106cdd412cf6e14be00898e7dbcc859"
  end

  resource "ossfs" do
    url "https://files.pythonhosted.org/packages/d1/be/378b7beef20f2e72241ce90f1002c65292568b9ce9cb9931422e196a006a/ossfs-2023.5.0.tar.gz"
    sha256 "99df5b678c516bb24b56d5a54ad60b726f0b1989d6d89f893a471b3aa982f366"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/95/60/d93628975242cc515ab2b8f5b2fc831d8be2eff32f5a1be4776d49305d13/pathspec-0.11.1.tar.gz"
    sha256 "2798de800fa92780e33acca925945e9a19a133b715067cf165b8866c15a31687"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9c/0e/ae9ef1049d4b5697e79250c4b2e72796e4152228e67733389868229c92bb/platformdirs-3.5.1.tar.gz"
    sha256 "412dae91f52a6f84830f39a8078cecd0e866cb72294a5c66808e74d5e88d251f"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/1f/f8/969e6f280201b40b31bcb62843c619f343dcc351dff83a5891530c9dd60e/portalocker-2.7.0.tar.gz"
    sha256 "032e81d534a88ec1736d03f780ba073f047a06c478b06e2937486f334e955c51"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
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
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "pydrive2" do
    url "https://files.pythonhosted.org/packages/45/74/b591079fa588351cec61861b85ba26f7deb96f3b445556c100e17db5572b/PyDrive2-1.15.4.tar.gz"
    sha256 "0c011b74ebc24f3c6ca72820626b77f1dfe0ae88f5740c5a5cf96e83dd79ba99"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/b9/13/55deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5f/pygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e0/f0/9804c72e9a314360c135f42c434eb42eaabb5e7ebad760cbd8fc7023be38/PyJWT-2.7.0.tar.gz"
    sha256 "bd6ca4a3c4285c1a2d4349e5a035fdf8fb94e04ccd0fcbe6ba289dae9cc3e074"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
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
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
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
    url "https://files.pythonhosted.org/packages/3d/0b/8dd34d20929c4b5e474db2e64426175469c2b7fea5ba71c6d4b3397a9729/rich-13.3.5.tar.gz"
    sha256 "2d11b9b8dd03868f09b4fffadc84a6a8cda574e40dc90821bd845720ebb8e89c"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/97/03674459c459b9b69ef71eba039205a72867e5c6c409df3136858f6836f3/ruamel.yaml-0.17.31.tar.gz"
    sha256 "098ed1eb6d338a684891a72380277c1e6fc4d4ae0e120de9a447275056dda335"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/17/44/513d90e312d31d3f6ff9d171a411a6fbcf9f51a04d8cb600ee2d3a220835/s3fs-2023.5.0.tar.gz"
    sha256 "106b5d9a1000e6af413f918156ba4b96789ac832b7e08c99d186eb08164e6981"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/4f/88/e72784ec9559927e405bd946b7564583973ac258aa39ae327e362b5927a2/scmrepo-1.0.3.tar.gz"
    sha256 "70e65e3d614040e6698c1a2c876a82ea1b2b6b85cb4e0a65e5b8c19320f3597d"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/1e/c6/ba2dd56e3996a1919984645ca0aaf20c4879cc1227c50a4be08f52b19ad0/shortuuid-1.0.11.tar.gz"
    sha256 "fc75f2615914815a8e4cb1501b3a513745cb66ef0fd5fc6fb9f8c3fa3481f789"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/ac/7e/a59eabcdf911cb2288ca83ce04d1a2ecec02bbe7c4fd8d52c3cc112e7c8f/shtab-1.6.1.tar.gz"
    sha256 "decc78082c3ffb518c1dfd3a8da99653a2d47e58e3104197bce8ae6507dad78b"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sqltrie" do
    url "https://files.pythonhosted.org/packages/c8/d0/b9258b8de5ba63f3c3d7e86e4a033726fe3e93ef5c579d9bb74b40ebb028/sqltrie-0.3.1.tar.gz"
    sha256 "63d562dc90dc88f1de6bacb3c1c8796b127544f84fd670bcca64f96c92695e53"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/01/a1/20f5ed702a87b3c2b501698613e8b4d8ce3fa61722c937937658dfd78249/sshfs-2023.4.1.tar.gz"
    sha256 "d4aba679144e5bc47491395b929c48450daa13738986b41959e1d3673addff7c"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/10/37/dd53019ccb72ef7d73fff0bee9e20b16faff9658b47913a35d79e89978af/tomlkit-0.11.8.tar.gz"
    sha256 "9330fc7faa1db67b541b28e62018c17d20be733177d290a13b24c62d1614e0c3"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
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
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
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
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.write("dvc/utils/build.py", "PKG = \"brew\"")

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dvc", "completion", "-s", shells: [:bash, :zsh])

    # Remove the lines below when we depend on unversioned protobuf.
    # This is needed because protobuf@21 is keg-only.
    odie "`.pth` file writing can be removed!" if deps.none? { |d| d.name.start_with?("protobuf@") }
    site_packages = Language::Python.site_packages("python3")
    protobuf = Formula["protobuf@21"].opt_prefix
    (libexec/site_packages/"homebrew-protobuf.pth").write protobuf/site_packages
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
