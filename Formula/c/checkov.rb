class Checkov < Formula
  include Language::Python::Virtualenv

  desc "Prevent cloud misconfigurations during build-time for IaC tools"
  homepage "https://www.checkov.io/"
  url "https://files.pythonhosted.org/packages/cb/93/919055143c942c39df2f14e50aa4127d2be109052b0eed0d80404af1fcbb/checkov-3.4.11.tar.gz"
  sha256 "c0ffd36a53b3c9fa9e75db5d6a6ee0d7b0c23be2a1ea2cb10ea07f71732930e1"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "790347dfd086636deccdeedf6103f53c521f3f2222991115e450376030c75424"
    sha256 cellar: :any, arm64_golden_gate: "ee4cfbde31b4c7e94e574cd533844feb4ebf8d7d4f9439a7b86c560532557ec4"
    sha256 cellar: :any, arm64_tahoe:       "38cbadc6dac4a2b1dac906e9c1ee1ab31ecaf38ea90577d3cc9d05c73f786a2a"
    sha256 cellar: :any, arm64_sequoia:     "15c0a9a415775534ac178ee77f634e0197180b994d4b86d0a610389e3d74ecc8"
    sha256 cellar: :any, arm64_linux:       "e4e270ddc4fd9a64d52dd3029fad4b147bff269db7710ffbfe945bf6d2bb1c07"
    sha256 cellar: :any, x86_64_linux:      "604de2a36d06534f2446f65e9760dd5e471c044bab3036741d952430106167fa"
  end

  depends_on "cmake" => :build # for igraph
  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[certifi cffi numpy pydantic rpds-py]

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/85/2f/9d1ee4f937addda60220f47925dac6c6b3782f6851fd578987284a8d2491/aiodns-3.6.1.tar.gz"
    sha256 "b0e9ce98718a5b8f7ca8cd16fc393163374bc2412236b91f6c851d066e3324b6"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/02/d4/1e69e17dda5df91734b70d03dbbf9f222ddb438e1f3bf4ea8fa135ce46de/aiomultiprocess-0.9.1.tar.gz"
    sha256 "f0231dbe0291e15325d7896ebeae0002d95a4f2675426ca05eb35f24c60e495b"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/19/0d/ca63f1b8b706c70590d0a4acc9c3c94ea8ed4dd9c83b4f7af195868abe76/argcomplete-3.8.0.tar.gz"
    sha256 "0114d634013e11ac92cc329b3a7d886c3506e98ddc7bb23c99b1782aacc8b8bd"
  end

  resource "asteval" do
    url "https://files.pythonhosted.org/packages/2b/f0/ad92c4bc565918713f9a4b54f06d06ec370e48079fdb50cf432befabee8b/asteval-1.0.6.tar.gz"
    sha256 "1aa8e7304b2e171a90d64dd269b648cacac4e46fe5de54ac0db24776c0c4a19f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "bc-detect-secrets" do
    url "https://files.pythonhosted.org/packages/5e/15/0b96fa6d08e5a60fbacec144a5b132412a3b54f1e6479c74a0476b52b9fd/bc_detect_secrets-1.5.55.tar.gz"
    sha256 "67fee7aa5d5c35767a4a81ba5dd11c68f3a0714721f588fe6d9734456b0b806d"
  end

  resource "bc-jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/3a/ad/b6745e21e050fac1ea499fdcafb689391ebf2ff01f2a96da275bb189c2ed/bc-jsonpath-ng-1.6.1.tar.gz"
    sha256 "6ea4e379c4400a511d07605b8d981950292dd098a5619d143328af4e841a2320"
  end

  resource "bc-python-hcl2" do
    url "https://files.pythonhosted.org/packages/c5/b8/dadd3aa0e56723b8e1af7772131ae300da28fe800d5c7179608b0cee4cfa/bc_python_hcl2-0.4.5.tar.gz"
    sha256 "62a2cab872757c0183fd92270c5ea013820c197de889a195ab107148406c8e27"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/79/34/c0cfdaee9c796c8381439fed0fcab62810753b8b0adb1ec88fa7f41eaa5d/beartype-0.23.1.tar.gz"
    sha256 "8b805f246b32931c74f2b321ea0939fe5bb2ff43c12a3eff19cc4c854b832e1d"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/73/c6/a18789b17138bc4f3001bfee42c07f85b9432475f5e8188c5699d481a376/boto3-1.35.49.tar.gz"
    sha256 "ddecb27f5699ca9f97711c52b6c0652c2e63bf6c2bfbc13b819b4f523b4d30ff"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/7c/9c/1df6deceee17c88f7170bad8325aa91452529d683486273928eecfd946d8/botocore-1.35.99.tar.gz"
    sha256 "1eab44e969c39c5f3d9a3104a0836c24715579a455f12b3979a31d7cde51b3c3"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/76/4b/3d870836119dbe9a5e3c9a61af8cc1a8b69d75aea564572e385882d5aefb/cached_property-2.0.1.tar.gz"
    sha256 "484d617105e3ee0e4f1f58725e72a8ef9e93deee462222dbd51cd91230897641"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/c2/c3/cae6d3bdefd96a941ffc247c714ac4babc488a69012e11c058f6c17c6c47/charset_normalizer-3.5.3.tar.gz"
    sha256 "a250888753faa289e2997962fbb17c4960cbdb58575533ca6fceee68c224bdff"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/1d/03/454dafcda21ca579bfa3d3583edd91f283cf6fb7b9a63d00a3212e8e2d4c/click_option_group-0.5.10.tar.gz"
    sha256 "22d6a7d102b4ead6a0b8601d577386d390deae91038662f2bd1d013806184ab7"
  end

  resource "cloudsplaining" do
    url "https://files.pythonhosted.org/packages/27/c3/a41d0974e00291798d3a5a18c7c0c7fd2880d8fbf69ebe115e89325bde85/cloudsplaining-0.7.0.tar.gz"
    sha256 "2d8a1d1a3261368a39359bb23aa7d6ac9add274728ff24877b710cdfa96d96af"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/14/94/269624ec6e8fc8fd5ab6a81c208aea9e02327b8874f9bc254f5379d5a2ec/configargparse-1.10.2.tar.gz"
    sha256 "2deb0b3d6d46ff6e3218fcd350127507c5e3c11e21c8072a9fb24531dfc9bd4a"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/17/40/6509e6cfd7f2f3255501690f46375fdd224949e21fd1e96f4f4c8a9041b1/cyclonedx_python_lib-11.12.0.tar.gz"
    sha256 "16767c4039de90c04e9f03348f8f0ed4b8ff842eaa7eefcad3a95685f970dacf"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/4e/a2/dc08c667e7e51cb035ffab38ae98d7d0f249092591130db4f67dc26b0021/decorator-5.3.2.tar.gz"
    sha256 "d9883f1b8259e3bfc42565d0bc6fdc760012008552aa449f75efd2d48319b82b"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/88/7f/731ff914b0255d3d065f45fd4e626d4b8c95dbcbaada049f337a6ac16410/docker-7.2.0.tar.gz"
    sha256 "cebb93773d334f778e023a7ee352a8d6e13ab1bd3b863a4d4a59dec897df43ac"
  end

  resource "dockerfile-parse" do
    url "https://files.pythonhosted.org/packages/92/df/929ee0b5d2c8bd8d713c45e71b94ab57c7e11e322130724d54f469b2cd48/dockerfile-parse-2.0.1.tar.gz"
    sha256 "3184ccdc513221983e503ac00e1aa504a2aa8f84e5de673c46b0b6eee99ec7bc"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/1f/2c/a4213cdbbc43b8fdf34b6e2afb415fd5d46e171d32a4bb92e7924548aa9f/dpath-2.1.3.tar.gz"
    sha256 "d1a7a0e6427d0a4156c792c82caf1f0109603f68ace792e36ca4596fd2cb8d9d"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/25/ca/8de7744cb3bc966c85430ca2d0fcaeea872507c6a4cf6e007f7fe269ed9d/ecdsa-0.19.2.tar.gz"
    sha256 "62635b0ac1ca2e027f82122b5b81cb706edc38cd91c63dda28e4f3455a2bf930"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/ff/fee293f1ec3e1b64db6eb270e00964f29c086d769201474cedb8d1608930/gitpython-3.2.1.tar.gz"
    sha256 "0f1229ec5c057bdabdeeda8bda4f17bda679ab33dbccc00f24e6a480553c8613"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/72/33d1bb4be61f1327d3cd76fc41e2d001a6b748a0648d944c646643f123fe/importlib_metadata-7.2.1.tar.gz"
    sha256 "509ecb2ab77071db5137c655e24ceb3eee66e7bbc6574165d0d114d9fc4bbe68"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/1c/ff/8644daa33bfdf552c9cfec8d1fc2c690f57a347808f62c406ac6557329c2/markdown-3.11.4.tar.gz"
    sha256 "c911a757f33d64a2578bed2d20c57e007b2aedd8a67bceabd593b31143d54ead"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/7b/6b/29ef8e752f5854dcc267ded0652c475bec99b86f255957a0d4fcad657b18/multidict-7.2.1.tar.gz"
    sha256 "e8af3e6f1bdbc31fd762b094133b478b89988eaebc63cbe82b1d9e3bbd15cede"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/8c/33/e50adf6a6cd4cde7ccd140e4538d898cea7a609f7aee5d6365e5cd44b6c8/packageurl-python-0.13.4.tar.gz"
    sha256 "6eb5e995009cc73387095e0b507ab65df51357d25ddc5fce3d3545ad6dcbbee8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/a4/05/75e8953eb5fa564e45fc5afc61696d38ce779169309ca270224561926fa8/policy_sentry-0.13.2.tar.gz"
    sha256 "db2b39f92989077f83fc4dd1d064e3ff20b69cfed82168ebdc060e7dce292e77"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/a5/40/61fccab02f0021d99251c4a34d989a72a1b76da658f84d87541af709773e/prettytable-3.19.0.tar.gz"
    sha256 "0ecedd6d9a560b330503bef15791b77954fa46b7123203d91e463330b61959ba"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/48/8c/cad9596066de835b304be48b0eefa30dae1834afae6e670805831cc05ea2/py_serializable-2.2.0.tar.gz"
    sha256 "8e4fa02e8de819c0488ccdb69c2d3109274adcf224c02357fd8729cb12727aab"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/8d/ad/9d1e96486d2eb5a2672c4d9a2dd372d015b8d7a332c6ac2722c4c8e6bbbf/pycares-4.11.0.tar.gz"
    sha256 "c863d9003ca0ce7df26429007859afd2a621d3276ed9fef154a9123db9252557"
  end

  resource "pycep-parser" do
    url "https://files.pythonhosted.org/packages/a5/fa/be9c4c78d36f095ce4801021f367febe232b4f299e172bb271e4a895968e/pycep_parser-0.5.1.tar.gz"
    sha256 "683bb001077c09f98408285b1b6ba10cfb3941610966c45d0638a0e1a5e1d2a4"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "rdflib" do
    url "https://files.pythonhosted.org/packages/98/f5/18bb77b7af9526add0c727a3b2048959847dc5fb030913e2918bf384fec3/rdflib-7.6.0.tar.gz"
    sha256 "6c831288d5e4a5a7ece85d0ccde9877d512a3d0f02d7c06455d00d6d0ea379df"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fa/b8/61d96601b737305a04161da340499cbb3299029d4ea0f9c717bc35977c2b/regex-2026.11.25.tar.gz"
    sha256 "d3ea8d9698f13f3fd08c65f9bed0bb07bcfff80b61dfa14d86b8cc398f886588"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rustworkx" do
    url "https://files.pythonhosted.org/packages/86/0d/5b6b48005bbc19622ea7f295f2d5f1339474cb7893e57fd30e6553b2b534/rustworkx-0.18.1.tar.gz"
    sha256 "30affe6ee52a6257a01152418f9c1686ca114e7ab4a3bf87bb87fe35b7350f3e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/c0/0a/1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069/s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/82/77/d59ca6aa338bdd8d880234d15b7c466cb176e44502899a9df81ba2e13cd0/soupsieve-4.1.3.tar.gz"
    sha256 "13f70186c8f40bf8d0ff7bbab09a18fb149600b465269207b5e5b588f55fda08"
  end

  resource "spdx-tools" do
    url "https://files.pythonhosted.org/packages/2f/99/33383f587b59cbd191cc1c0fd5408e550b9275e0090d32561cbddc973fdc/spdx_tools-0.8.5.tar.gz"
    sha256 "be600beb2f762f0116025e05490d399e724f668bef84025a7c421bb266688bdb"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "unidiff" do
    url "https://files.pythonhosted.org/packages/9f/7a/f891dba8225c20cce4417443073e67f33e01fae9715a6477f59eb32654ae/unidiff-1.0.1.tar.gz"
    sha256 "d9425bc516390c54743a1045b2c1c97f02d245a913a241dd499f958adb2df998"
  end

  resource "uritools" do
    url "https://files.pythonhosted.org/packages/60/02/88acd6b71ad0984fb8e1886f988f3a8ecd1eedfff2b27a11d1ce2302ef48/uritools-7.0.1.tar.gz"
    sha256 "abf09f899b925fad05407d7f39061318c6be62cce065db727a024daadf96eebf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/8e/da/d59374b2c893ae70a41fdb064637ccef218f25df8c67e5431a96708235d9/wcwidth-0.9.5.tar.gz"
    sha256 "713534e2ecb16e0fc39f19e0a5dda997da76d010953e9e8f803e7971f8accd80"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/18/05/ba1458dee0ac485b2a01071c1b88f5199fe878a485df482e10e1ef2205cc/zipp-4.1.2.tar.gz"
    sha256 "cf474b90b07ea932637e17c6b9479de2b2882900b0d311bdaf4f5c000a15a97f"
  end

  allow_network_access! :build

  def install
    venv = virtualenv_install_with_resources(without: "rustworkx")

    resource("rustworkx").stage do
      # Prune Cargo.lock entries for the fuzz workspace member missing from the sdist
      system "cargo", "update", "--workspace"
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "checkov",
                                         shell_parameter_format: :arg)
  end

  test do
    (testpath/"test.tf").write <<~HCL
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    HCL

    output = shell_output("#{bin}/checkov -f #{testpath}/test.tf 2>&1")
    assert_match "Passed checks: 1, Failed checks: 0, Skipped checks: 0", output

    (testpath/"test2.tf").write <<~HCL
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        #checkov:skip=CKV_AWS_52
        #checkov:skip=CKV_AWS_20:The bucket is a public static content host
        versioning {
          enabled = true
        }
      }
    HCL
    output = shell_output("#{bin}/checkov -f #{testpath}/test2.tf 2>&1")
    assert_match "Passed checks: 1, Failed checks: 0, Skipped checks: 0", output
  end
end
