class Checkov < Formula
  include Language::Python::Virtualenv

  desc "Prevent cloud misconfigurations during build-time for IaC tools"
  homepage "https://www.checkov.io/"
  url "https://files.pythonhosted.org/packages/1a/a0/55aa80115ad3b6011ece55ed1e2e2ee8fa352c9d2b6a066d5ea56c72be1b/checkov-3.2.30.tar.gz"
  sha256 "dca00fe8f0e04fd4fde88de5143bbe01aae7966351cd0f70f69456313bd43428"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6650301b491fea31b686c042acc4ae7ffcc26fccdc0e3c0f8c0af8e45d512d25"
    sha256 cellar: :any,                 arm64_ventura:  "a4e206fc90bd293f450d1be8f7a6bc6c914f56197cd79b54ea44cfde173abeef"
    sha256 cellar: :any,                 arm64_monterey: "b7e2ed4c841006b2a50c1da8058e79d4ebbb2c27d15f4b90ebfb639601ba42d6"
    sha256 cellar: :any,                 sonoma:         "090db920c03e7f6cb165a089b80841914f85a25d9ab7c8156ebe8b62ae3d9a07"
    sha256 cellar: :any,                 ventura:        "6e0cc6d075c9a03919fd9bed13ef5bdd29eaa2928079d53ea7f3b8b3a178a779"
    sha256 cellar: :any,                 monterey:       "b85faadd64a1b70f2bb3d7a0669d2596d5e501699e5e34311e9da3c233814e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dd607f449488075cefaae2c433697b89a6c8e800ad8c33f4e4c66cc13052069"
  end

  depends_on "cmake" => :build # for igraph
  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/fa/10/4de99e6e67703d8f6b10ea92a4d2a6c5b96a9c0708b75389a00203387925/aiodns-3.1.1.tar.gz"
    sha256 "1073eac48185f7a4150cad7f96a5192d6911f12b4fb894de80a088508c9b3a99"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/18/93/1f005bbe044471a0444a82cdd7356f5120b9cf94fe2c50c0cdbf28f1258b/aiohttp-3.9.3.tar.gz"
    sha256 "90842933e5d1ff760fae6caca4b2b3edba53ba8f4b71e95dacf2818a2aca06f7"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/59/30/64e01ec7ecb4aa1123b54401ffc36c16bb1d7155b924f7430a651fb956c1/aiomultiprocess-0.9.0.tar.gz"
    sha256 "07e7d5657697678d9d2825d4732dfd7655139762dee665167380797c02c68848"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/f0/a2/ce706abe166457d5ef68fac3ffa6cf0f93580755b7d5f883c456e94fab7b/argcomplete-3.2.2.tar.gz"
    sha256 "f3e49e8ea59b4026ee29548e24488af46e30c9de57d48638e24f54a1ea1000a2"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "bc-detect-secrets" do
    url "https://files.pythonhosted.org/packages/2f/d3/ad86d060c9cabe8a9654bc52566b4b831e8593655488c8b7e4c36648618f/bc-detect-secrets-1.5.4.tar.gz"
    sha256 "4ee47ebff2b86b7538e49476342e22fd014e4e232019e7a2965910949eab1585"
  end

  resource "bc-jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/3a/ad/b6745e21e050fac1ea499fdcafb689391ebf2ff01f2a96da275bb189c2ed/bc-jsonpath-ng-1.6.1.tar.gz"
    sha256 "6ea4e379c4400a511d07605b8d981950292dd098a5619d143328af4e841a2320"
  end

  resource "bc-python-hcl2" do
    url "https://files.pythonhosted.org/packages/d8/9a/1cb1e4c65a75dcc304438d1f941345d5dd5e8819f1a8b7b17991a21a22b3/bc-python-hcl2-0.4.2.tar.gz"
    sha256 "ac8ff59fb9bd437ea29b89a7d7c507fd0a1e957845bae9aeac69f2892b8d681e"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/5f/1c/f11139817b962ae209be07431a6613059c43014466af798b83ec8a5a7ccd/beartype-0.17.2.tar.gz"
    sha256 "e911e1ae7de4bccd15745f7643609d8732f64de5c2fb844e89cbbed1c5a8d495"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/a2/d9/b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9/boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ca/00/2e59e3dafc7deb2fe4e3ba346aea0a6d6061ed41f40cfb0ceb7e483ea310/boto3-1.34.25.tar.gz"
    sha256 "1b415e0553679ea05b9e2aed3eb271431011a67a165e3e0aefa323e13b8b7e92"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/45/e2/adb485d671d6a71fc5b92113b60eca04d020e6de9fc979ea4508d9b8b48f/botocore-1.34.25.tar.gz"
    sha256 "a39070bb760bd9545b0eef52a8bcb2d03918206e67a5a786ea4bd6f4bd949edd"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/b3/4d/27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5b/cachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/e7/b8/91054601a2e05fd9060cb1baf56be5b24145817b059e078669e1099529c7/click-option-group-0.5.6.tar.gz"
    sha256 "97d06703873518cc5038509443742b25069a3c7562d1ea72ff08bfadde1ce777"
  end

  resource "cloudsplaining" do
    url "https://files.pythonhosted.org/packages/36/41/10330ab113c1d40a48f32f536579aff5025ea975098f37def13fd7fdaef6/cloudsplaining-0.6.2.tar.gz"
    sha256 "02fc4f8482b701b0b19b7ad543b579ba50f31b3e0389bb9f6973391891d6ecd1"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/73/c4/13353dc5b801bcc7ddd36f53725bd389965122fd0fb82d22c69a00f44696/cyclonedx_python_lib-6.4.3.tar.gz"
    sha256 "3d9450e500ca6f7cf9625e7bff700599dcca70e4a2180705b61917c59743506e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "dockerfile-parse" do
    url "https://files.pythonhosted.org/packages/92/df/929ee0b5d2c8bd8d713c45e71b94ab57c7e11e322130724d54f469b2cd48/dockerfile-parse-2.0.1.tar.gz"
    sha256 "3184ccdc513221983e503ac00e1aa504a2aa8f84e5de673c46b0b6eee99ec7bc"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/1f/2c/a4213cdbbc43b8fdf34b6e2afb415fd5d46e171d32a4bb92e7924548aa9f/dpath-2.1.3.tar.gz"
    sha256 "d1a7a0e6427d0a4156c792c82caf1f0109603f68ace792e36ca4596fd2cb8d9d"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/cf/3d/2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085/frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/8f/12/71a40ffce4aae431c69c45a191e5f03aca2304639264faf5666c2767acc4/GitPython-3.1.42.tar.gz"
    sha256 "2d99869e0fef71a73cbd242528105af1d6c1b108c60dfabd994bf292f76c3ceb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/b4/206081fca69171b4dc1939e77b378a7b87021b0f43ce07439d49d8ac5c84/importlib_metadata-7.0.1.tar.gz"
    sha256 "f238736bb06590ae52ac1fab06a3a9ef1d8dce2b7a35b5ab329371d6c8f5d2cc"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/2c/e1/804b6196b3fbdd0f8ba785fc62837b034782a891d6f663eea2f30ca23cfa/lark-1.1.9.tar.gz"
    sha256 "15fa5236490824c2c4aba0e22d2d6d823575dcaf4cdd1848e34b6ad836240fba"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/8b/5c/db493282aeb3f05e89b4db45898faddaa339740eaccb752942042410703f/license-expression-30.2.0.tar.gz"
    sha256 "599928edd995c43fc335e0af342076144dc71cb858afa1ed9c1c30c4e81794f5"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/11/28/c5441a6642681d92de56063fa7984df56f783d3f1eba518dc3e7a253b606/Markdown-3.5.2.tar.gz"
    sha256 "e1ac7b3dc550ee80e602e71c1d168002f062e49f1b11e26a36264dafd4df2ef8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f9/79/722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836/multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/49/fe/c21d95cc120928b0f5b44d8c522e48df122be3f1f9d61dfb7bf3d597c95d/openai-0.28.1.tar.gz"
    sha256 "4be1dad329a65b4ce1a660fe6d5431b438f429b5855c883435f0f7fcb6d2dcc8"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/8c/33/e50adf6a6cd4cde7ccd140e4538d898cea7a609f7aee5d6365e5cd44b6c8/packageurl-python-0.13.4.tar.gz"
    sha256 "6eb5e995009cc73387095e0b507ab65df51357d25ddc5fce3d3545ad6dcbbee8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/d9/da/5855ad81cca1a75a88874c00d6d301360a2ff82aea17072604540e48903c/policy_sentry-0.12.10.tar.gz"
    sha256 "b8cf00a11a2a335d2bceba5dc1998182288a4b7848916a77923a6a2e0bc84373"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/19/d3/7cb826e085a254888d8afb4ae3f8d43859b13149ac8450b221120d4964c9/prettytable-3.10.0.tar.gz"
    sha256 "9665594d137fb08a1117518c25551e0ede1687197cf353a4fdc78d27e1073568"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/15/15/464be3feba255f4ae9202898f450a000f7b4156079e61aebde70f413e2d1/py_serializable-1.0.2.tar.gz"
    sha256 "158a98a7ffda067d21f844594ce571d97f36172ba538aee1a93196f8b5888bd8"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/1b/8f/daf60bbc06f4a3cd1cfb0ab807057151287df6f5c78f2e0d298acc9193ac/pycares-4.4.0.tar.gz"
    sha256 "f47579d508f2f56eddd16ce72045782ad3b1b3b678098699e2b6a1b30733e1c2"
  end

  resource "pycep-parser" do
    url "https://files.pythonhosted.org/packages/1c/fb/3912b366eaae9414758dda5c4b6903f3931bafe25490bd7c6a4a27409ea1/pycep_parser-0.4.1.tar.gz"
    sha256 "a3edd1c3d280c283d614c865a854a693daf56c35cd4095b373016c214baa76dd"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/3c/6c/5d3b1c9615726a69a9a1f992e63f8fd0a2d19ae726c15eb9154fdce48217/pydantic-2.6.3.tar.gz"
    sha256 "e07805c4c7f5c6826e33a1d4c9d47950d7eaf34868e2690f8594d2e30241f11f"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/77/3f/65dbe5231946fe02b4e6ea92bc303d2462f45d299890fd5e8bfe4d1c3d66/pydantic_core-2.16.3.tar.gz"
    sha256 "1cac689f80a3abab2d3c0048b29eea5751114054f032a941a32de4c852c59cad"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rdflib" do
    url "https://files.pythonhosted.org/packages/0d/a3/63740490a392921a611cfc05b5b17bffd4259b3c9589c7904a4033b3d291/rdflib-7.0.0.tar.gz"
    sha256 "9995eb8569428059b8c1affd26b25eac510d64f5043d9ce8c84e0d0036e995ae"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/21/c5/b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9a/referencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/ba/ce7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5e/rpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "rustworkx" do
    url "https://files.pythonhosted.org/packages/23/f3/b0644cf12d82e8fd5536bbf4f8caf11dabea4d541abe822e307568d7dfc9/rustworkx-0.13.2.tar.gz"
    sha256 "0276cf0b989211859e8797b67d4c16ed6ac9eb32edb67e0a47e70d7d71e80574"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
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
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "spdx-tools" do
    url "https://files.pythonhosted.org/packages/32/d8/a67445be5981469fdbaf7f765f53c920f699e7e512cc931b650a935c3199/spdx-tools-0.8.2.tar.gz"
    sha256 "aea4ac9c2c375e7f439b1cef5ff32ef34914c083de0f61e08ed67cd3d9deb2a9"
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
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "unidiff" do
    url "https://files.pythonhosted.org/packages/a3/48/81be0ac96e423a877754153699731ef439fd7b80b4c8b5425c94ed079ebd/unidiff-0.7.5.tar.gz"
    sha256 "2e5f0162052248946b9f0970a40e9e124236bf86c82b70821143a6fc1dea2574"
  end

  resource "uritools" do
    url "https://files.pythonhosted.org/packages/44/71/2712397a459ef0c960141f1f9fdf5a6b48052c521644c7154c508d976373/uritools-4.0.2.tar.gz"
    sha256 "04df2b787d0eb76200e8319382a03562fbfe4741fd66c15506b08d3b8211d573"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/e0/ad/bedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28/yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "checkov",
                                         shell_parameter_format: :arg)
  end

  test do
    (testpath/"test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    output = shell_output("#{bin}/checkov -f #{testpath}/test.tf 2>&1")
    assert_match "Passed checks: 1, Failed checks: 0, Skipped checks: 0", output

    (testpath/"test2.tf").write <<~EOS
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
    EOS
    output = shell_output("#{bin}/checkov -f #{testpath}/test2.tf 2>&1")
    assert_match "Passed checks: 1, Failed checks: 0, Skipped checks: 0", output
  end
end
