class Checkov < Formula
  include Language::Python::Virtualenv

  desc "Prevent cloud misconfigurations during build-time for IaC tools"
  homepage "https://www.checkov.io/"
  url "https://files.pythonhosted.org/packages/73/28/91b6524cc8bc3aee301df95cb26534e259ffa9275adda308a903367a941f/checkov-3.2.330.tar.gz"
  sha256 "a672e96fe290608267be9aa556add10a5dc8b6801e888d41226e7019f5fef3a3"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://pypi.org/rss/project/checkov/releases.xml"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :xml do |xml, regex|
      xml.get_elements("//item/title").map { |item| item.text[regex, 1] }
    end
    throttle 10
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ecc7f4a2e5bd622e024847c42f4f696e37683d1f86f3a8ce7a35f8dbc25a642c"
    sha256 cellar: :any,                 arm64_sonoma:  "01cc5b072abe069479397d95ffd59e78490e5958fe1af556013c01e112aa2807"
    sha256 cellar: :any,                 arm64_ventura: "5ff2739d1e80a656f6a46b36f4a4ec2ed164f1bdee069f1578f581f838c06633"
    sha256 cellar: :any,                 sonoma:        "39572eae199bb9d42940f1a30e97ff92f31e469418be67c0b0186f58453b3aad"
    sha256 cellar: :any,                 ventura:       "c7b211747f96464f63b6f6ace6d64cab43fe2584fa1b12d1c140c38197a658d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45309439962e1b3bf76f77b3fbde3b22987d43728364dcc3e6cf2c29041e6f63"
  end

  depends_on "cmake" => :build # for igraph
  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/e7/84/41a6a2765abc124563f5380e76b9b24118977729e25a84112f8dfb2b33dc/aiodns-3.2.0.tar.gz"
    sha256 "62869b23409349c21b072883ec8998316b234c9a9e36675756e8e317e8768f72"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/7f/55/e4373e888fdacb15563ef6fa9fa8c8252476ea071e96fb46defac9f18bf2/aiohappyeyeballs-2.4.4.tar.gz"
    sha256 "5fdd7d87889c63183afc18ce9271f9b0a7d32c2303e394468dd45d514a757745"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/3f/24/d5c0aed3ed90896f8505786e3a1e348fd9c61284ef21f54ee9cdf8b92e4f/aiohttp-3.11.9.tar.gz"
    sha256 "a9266644064779840feec0e34f10a89b3ff1d2d6b751fe90017abcad1864fa7c"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/02/d4/1e69e17dda5df91734b70d03dbbf9f222ddb438e1f3bf4ea8fa135ce46de/aiomultiprocess-0.9.1.tar.gz"
    sha256 "f0231dbe0291e15325d7896ebeae0002d95a4f2675426ca05eb35f24c60e495b"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/7f/03/581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0/argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "bc-detect-secrets" do
    url "https://files.pythonhosted.org/packages/f6/2d/494fb3902bd1b1b51b8995389f96374a36782f0b1d62d04ba9c702f584c3/bc_detect_secrets-1.5.27.tar.gz"
    sha256 "1da39c1254b894b68c52c7d4e69f9e94f227ceea69f3e15bf29920d883f50abd"
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
    url "https://files.pythonhosted.org/packages/6f/e1/00515b97afa3993b4a314e4bc168fbde0917fd5845435cb6f16a19770746/beartype-0.19.0.tar.gz"
    sha256 "de42dfc1ba5c3710fde6c3002e3bd2cad236ed4d2aabe876345ab0b4234a6573"
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
    url "https://files.pythonhosted.org/packages/73/c6/a18789b17138bc4f3001bfee42c07f85b9432475f5e8188c5699d481a376/boto3-1.35.49.tar.gz"
    sha256 "ddecb27f5699ca9f97711c52b6c0652c2e63bf6c2bfbc13b819b4f523b4d30ff"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/bb/73/c3f127c48869a3555e59c5cd381de119d96a02912dc789443fdaefa44807/botocore-1.35.76.tar.gz"
    sha256 "a75a42ae53395796b8300c5fefb2d65a8696dc40dc85e49cf3a769e0c0202b13"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/76/4b/3d870836119dbe9a5e3c9a61af8cc1a8b69d75aea564572e385882d5aefb/cached_property-2.0.1.tar.gz"
    sha256 "484d617105e3ee0e4f1f58725e72a8ef9e93deee462222dbd51cd91230897641"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https://files.pythonhosted.org/packages/27/c3/a41d0974e00291798d3a5a18c7c0c7fd2880d8fbf69ebe115e89325bde85/cloudsplaining-0.7.0.tar.gz"
    sha256 "2d8a1d1a3261368a39359bb23aa7d6ac9add274728ff24877b710cdfa96d96af"
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
    url "https://files.pythonhosted.org/packages/f9/7e/3e7c1ca7937ca87d29e6c720a6ddfe2fee714628e59c66c33fe6b32721fa/cyclonedx_python_lib-6.4.4.tar.gz"
    sha256 "1b6f9109b6b9e91636dff822c2de90a05c0c8af120317713c1b879dbfdebdff8"
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
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
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
    url "https://files.pythonhosted.org/packages/8f/ed/0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3/frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/72/33d1bb4be61f1327d3cd76fc41e2d001a6b748a0648d944c646643f123fe/importlib_metadata-7.2.1.tar.gz"
    sha256 "509ecb2ab77071db5137c655e24ceb3eee66e7bbc6574165d0d114d9fc4bbe68"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/c7/97/df5570fe2f1046bb5f6eeed55815ef11e371e9310d53bd94ec8efe4173f4/license_expression-30.4.0.tar.gz"
    sha256 "6464397f8ed4353cc778999caec43b099f8d8d5b335f282e26a9eb9435522f05"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/49/fe/c21d95cc120928b0f5b44d8c522e48df122be3f1f9d61dfb7bf3d597c95d/openai-0.28.1.tar.gz"
    sha256 "4be1dad329a65b4ce1a660fe6d5431b438f429b5855c883435f0f7fcb6d2dcc8"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/e0/04/bb9f72987e7f62fb591d6c880c0caaa16238e4e530cbc3bdc84a7372d75f/orjson-3.10.12.tar.gz"
    sha256 "0a78bbda3aea0f9f079057ee1ee8a1ecf790d4f1af88dd67493c6b8ee52506ff"
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
    url "https://files.pythonhosted.org/packages/a4/05/75e8953eb5fa564e45fc5afc61696d38ce779169309ca270224561926fa8/policy_sentry-0.13.2.tar.gz"
    sha256 "db2b39f92989077f83fc4dd1d064e3ff20b69cfed82168ebdc060e7dce292e77"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/3b/8a/de4dc1a6098621781c266b3fb3964009af1e9023527180cb8a3b0dd9d09e/prettytable-3.12.0.tar.gz"
    sha256 "f04b3e1ba35747ac86e96ec33e3bb9748ce08e254dc2a1c6253945901beec804"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/20/c8/2a13f78d82211490855b2fb303b6721348d0787fdd9a12ac46d99d3acde1/propcache-0.2.1.tar.gz"
    sha256 "3f77ce728b19cb537714499928fe800c3dda29e8d9428778fc7c186da4c09a64"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/16/cf/6e482507764034d6c41423a19f33fdd59655052fdb2ca4358faa3b0bcfd1/py_serializable-1.1.2.tar.gz"
    sha256 "89af30bc319047d4aa0d8708af412f6ce73835e18bacf1a080028bb9e2f42bdb"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/d7/b1/94daaa50b6d2fa14c6b4981ca24fa4e7aa33a7519962c76170072ffb06ee/pycares-4.5.0.tar.gz"
    sha256 "025b6c2ffea4e9fb8f9a097381c2fecb24aff23fbd6906e70da22ec9ba60e19d"
  end

  resource "pycep-parser" do
    url "https://files.pythonhosted.org/packages/a5/fa/be9c4c78d36f095ce4801021f367febe232b4f299e172bb271e4a895968e/pycep_parser-0.5.1.tar.gz"
    sha256 "683bb001077c09f98408285b1b6ba10cfb3941610966c45d0638a0e1a5e1d2a4"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/45/0f/27908242621b14e649a84e62b133de45f84c255eecb350ab02979844a788/pydantic-2.10.3.tar.gz"
    sha256 "cb5ac360ce894ceacd69c403187900a02c4b20b693a9dd1d643e1effab9eadf9"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/a6/9f/7de1f19b6aea45aeb441838782d68352e71bfa98ee6fa048d5041991b33e/pydantic_core-2.27.1.tar.gz"
    sha256 "62a763352879b84aa31058fc931884055fd75089cccbd9d58bb6afd01141b235"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rdflib" do
    url "https://files.pythonhosted.org/packages/62/b6/4cee25689c7a3dfafeb481d358e74696fe3a8543da4cb2c1b71c0cb6583d/rdflib-7.1.1.tar.gz"
    sha256 "164de86bd3564558802ca983d84f6616a4a1a420c7a17a8152f5016076b2913e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/01/80/cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfd/rpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "rustworkx" do
    url "https://files.pythonhosted.org/packages/23/f3/b0644cf12d82e8fd5536bbf4f8caf11dabea4d541abe822e307568d7dfc9/rustworkx-0.13.2.tar.gz"
    sha256 "0276cf0b989211859e8797b67d4c16ed6ac9eb32edb67e0a47e70d7d71e80574"
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
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "spdx-tools" do
    url "https://files.pythonhosted.org/packages/f1/99/3470b28dc4b64fd29db3b1dcf5e84c743ec88e25ea7b214794f5930f0319/spdx-tools-0.8.3.tar.gz"
    sha256 "68b8f9ce2893b5216bd90b2e63f1c821c2884e4ebc4fd295ebbf1fa8b8a94b93"
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
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "unidiff" do
    url "https://files.pythonhosted.org/packages/a3/48/81be0ac96e423a877754153699731ef439fd7b80b4c8b5425c94ed079ebd/unidiff-0.7.5.tar.gz"
    sha256 "2e5f0162052248946b9f0970a40e9e124236bf86c82b70821143a6fc1dea2574"
  end

  resource "uritools" do
    url "https://files.pythonhosted.org/packages/d3/43/4182fb2a03145e6d38698e38b49114ce59bc8c79063452eb585a58f8ce78/uritools-4.0.3.tar.gz"
    sha256 "ee06a182a9c849464ce9d5fa917539aacc8edd2a4924d1b7aabeeecabcae3bc2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/50/05/51dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958f/xmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/b7/9d/4b94a8e6d2b51b599516a5cb88e5bc99b4d8d4583e468057eaa29d5f0918/yarl-1.18.3.tar.gz"
    sha256 "ac1801c45cbf77b6c99242eeff4fffb5e4e73a800b5c4ad4fc0be5def634d2e1"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources

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
