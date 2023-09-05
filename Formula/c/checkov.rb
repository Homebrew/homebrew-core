class Checkov < Formula
  include Language::Python::Virtualenv

  desc "Prevent cloud misconfigurations during build-time for IaC tools"
  homepage "https://www.checkov.io/"
  # checkov should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/bc/86/f26132d8e1e62784b01397ca2830e64b2e93bdaf0aaeeea9efc1c220ebe7/checkov-2.4.20.tar.gz"
  sha256 "b27633b340f4dd62a35e2dbb64e1535b275c82f5d0dba01378b95ebf106234e3"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7ff58258eec957beb1f8a030a65b78a5d4dbda76756e3970d95048d57d61478b"
    sha256 cellar: :any,                 arm64_monterey: "2023844defdbfe49721da6319a947baac707985d0f5bf34249feb29ce5f25c46"
    sha256 cellar: :any,                 arm64_big_sur:  "3c81b45eaeb05895bea0ffede31ed883d45a521deb42ccc10f1b592953096322"
    sha256 cellar: :any,                 ventura:        "84fb7e9485a994cf1721054d8eb331af93b079d27e9a631120aa08896678a3e1"
    sha256 cellar: :any,                 monterey:       "ff071506548d6c81e2628feb8fb3ddbbe224f22a4ec90b8715b1c5de2b4e24de"
    sha256 cellar: :any,                 big_sur:        "bd29eff6c7e4dfe6e3250c946a096c150e4a75d426e06a338b986915f784c260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2f60be0db4795791af8927aaefe851acee0a54cfd28958b0b5134f65e2988c"
  end

  depends_on "cmake" => :build # for igraph
  depends_on "rust" => :build # for rpds-py

  depends_on "cffi"
  depends_on "python-certifi"
  depends_on "python-markdown"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/27/79/df72e25df0fdd9bf5a5ab068539731d27c5f2ae5654621ae0c92ceca94cf/aiodns-3.0.0.tar.gz"
    sha256 "946bdfabe743fceeeb093c8a010f5d1645f708a241be849e17edfb0e49e08cd6"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/d6/12/6fc7c7dcc84e263940e87cbafca17c1ef28f39dae6c0b10f51e4ccc764ee/aiohttp-3.8.5.tar.gz"
    sha256 "b9552ec52cc147dbf1944ac7ac98af7602e51ea2dcd076ed194ca3c0d1c7d0bc"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/59/30/64e01ec7ecb4aa1123b54401ffc36c16bb1d7155b924f7430a651fb956c1/aiomultiprocess-0.9.0.tar.gz"
    sha256 "07e7d5657697678d9d2825d4732dfd7655139762dee665167380797c02c68848"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
    sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bc-detect-secrets" do
    url "https://files.pythonhosted.org/packages/b5/d5/a9686feec143958737b0bb7f713c32760ce46414bc375271f996a09e5139/bc-detect-secrets-1.4.30.tar.gz"
    sha256 "53154e5aee4c3415f20d5be327c9dad240804b113196ec6346c0b5390a7ed52d"
  end

  resource "bc-jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/f8/77/9a5ca9b848f57900f40ef1499cfabc27d62ecc3377a1e5f793c401e4cf60/bc-jsonpath-ng-1.5.9.tar.gz"
    sha256 "5e72d78887521469f8a52966f6f0664ec3d59dcb2cebf85b8131867a241c84ec"
  end

  resource "bc-python-hcl2" do
    url "https://files.pythonhosted.org/packages/83/30/23d56ecb6c572f84abd506a8af9e03fcccd69d342e7eafd25688d0ba46c1/bc-python-hcl2-0.3.51.tar.gz"
    sha256 "15bfecbae882ead998dd9300737237a14e40dfd8c973e5c7de7b4c92040a010f"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/d2/6c/fecfe9c7d7b903a52b732b8f33968a067cad8209848ae8037c4d0ed53055/beartype-0.15.0.tar.gz"
    sha256 "2af6a8d8a7267ccf7d271e1a3bd908afbc025d2a09aa51123567d7d7b37438df"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/a2/d9/b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9/boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/fb/00/20a7ddef854c51347165d114c879203d656e12f7d9b7b30dd8cd244adcf1/boto3-1.28.40.tar.gz"
    sha256 "6ff9a5b815e106656596064d51c9b6ba97a307807baa5f89634384b7d3f7ecc6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/96/b2/810868e32687760da8666ca65d2e307d7f50ed38276b5aef6cdf0a9fde14/botocore-1.31.40.tar.gz"
    sha256 "ce22a82ef8674f49691477d09558992cc87e7331f65c6a5b0da897ab192240ca"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
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
    url "https://files.pythonhosted.org/packages/97/46/cb565d09b650cfe961ff8adcd7a0a8968aa17783b4d897e8fc1837f4468d/cloudsplaining-0.6.1.tar.gz"
    sha256 "afa27770d97720dc4bddb3c11f50bd287f1ab1fdd908538e896e23c70a0d9c5f"
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
    url "https://files.pythonhosted.org/packages/dd/0d/2d77978ff3ebe445c00ffc209eb205d126ef7a8ece69e7f3d014e561bada/cyclonedx_python_lib-3.1.5.tar.gz"
    sha256 "1ccd482024a30b95c4fffb3fe567a9df97b705f34c1075f8abde8537867600c3"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deep-merge" do
    url "https://files.pythonhosted.org/packages/a5/25/aa35c20acd8a4f515f9e4c8dee4c7731446234101a6dae0c34cf498bb342/deep_merge-0.0.4.tar.gz"
    sha256 "b54415f90934c42e334114e2864cb4d4e7335b34ad396e35ad8610c96065a47e"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
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
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/8d/1e/33389155dfe8cebbaa0c5b5ed0d3bd82c5e70064be00b2b3ee938da8b5d2/GitPython-3.1.33.tar.gz"
    sha256 "13aaa3dff88a23afec2d00eb3da3f2e040e2282e41de484c5791669b31146084"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "igraph" do
    url "https://files.pythonhosted.org/packages/75/a9/3351da0a498502707f548ca48b2c4abc9e2f6e1901ad143c8559a95b0985/igraph-0.10.6.tar.gz"
    sha256 "76f7aad294514412f835366a7d9a9c1e7a34c3e6ef0a6c3a1a835234323228e8"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/99/ba/e51d376c6160d27669c7a9ad0b61d9cbd58fa58be6e6ddc0e7e0b6e6aa40/jsonschema-4.19.0.tar.gz"
    sha256 "6e1e7569ac13be8139b2dd2c21a55d350066ee3f80df06c608b398cdc6f30e8f"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/85/70/4465b0b7dc6ea72cc2c4ea25a2c6ad62cca7918eda030db36a4c11f6f5d9/lark-1.1.7.tar.gz"
    sha256 "be7437bf1f37ab08b355f29ff2571d77d777113d0a8c4352b0c513dced6c5a1e"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/90/93/0fc8c72a5c9b65c2fd56154ef9e08c0c7a7fd0596ae69c65ce714ea5cd84/license-expression-30.1.1.tar.gz"
    sha256 "42375df653ad85e6f5b4b0385138b2dbea1f5d66360783d8625c3e4f97f11f0c"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/5e/a8/f8d00a76f3991ff250b6584434ca24c2d275c6f3e97592b44f4ca124c47a/openai-0.28.0.tar.gz"
    sha256 "417b78c4c2864ba696aedaf1ccff77be1f04a581ab1739f0a56e0aae19e5a794"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/33/34/a7843f732e1e0b01e961f6ae835b3fd6bd4e361c1a3a72debd31244cb718/packageurl-python-0.11.2.tar.gz"
    sha256 "01fbf74a41ef85cf413f1ede529a1411f658bda66ed22d45d27280ad9ceba471"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/51/39/dd00a5913cdc6e7d4ca875728447e259d662caf7e9a6e9bf0e8c533aa241/policy_sentry-0.12.8.tar.gz"
    sha256 "0efc4218ef999e069a36676f9e58ef56b45fc8f10b97d6e7df67932175c0ace5"
  end

  resource "policyuniverse" do
    url "https://files.pythonhosted.org/packages/18/47/e58a8e38dd0d69500b473b8d9bc549bb468af037220279c59d9affe84041/policyuniverse-1.5.1.20230817.tar.gz"
    sha256 "7920896195af163230635f1a5cee0958f56003ef8c421f805ec81f134f80a57c"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/18/fa/82e719efc465238383f099c08b5284b974f5002dbe12050bcbbc912366eb/prettytable-3.8.0.tar.gz"
    sha256 "031eae6a9102017e8c7c7906460d150b7ed78b20fd1d8c8be4edaf88556c07ce"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/01/50/e3015e6e03a3cf64113f509e8b86b71af37169b59ccedfcb182f3d031329/pycares-4.3.0.tar.gz"
    sha256 "c542696f6dac978e9d99192384745a65f80a7d9450501151e4a7563e06010d45"
  end

  resource "pycep-parser" do
    url "https://files.pythonhosted.org/packages/1c/fb/3912b366eaae9414758dda5c4b6903f3931bafe25490bd7c6a4a27409ea1/pycep_parser-0.4.1.tar.gz"
    sha256 "a3edd1c3d280c283d614c865a854a693daf56c35cd4095b373016c214baa76dd"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rdflib" do
    url "https://files.pythonhosted.org/packages/0d/a3/63740490a392921a611cfc05b5b17bffd4259b3c9589c7904a4033b3d291/rdflib-7.0.0.tar.gz"
    sha256 "9995eb8569428059b8c1affd26b25eac510d64f5043d9ce8c84e0d0036e995ae"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4f/1d/6998ba539616a4c8f58b07fd7c9b90c6b0f0c0ecbe8db69095a6079537a7/regex-2023.8.8.tar.gz"
    sha256 "fcbdc5f2b0f1cd0f6a56cdb46fe41d2cce1e644e3b68832f3eeebc5fb0f7712e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/77/5a/0c82d0ef1322227e8e997dbbd3d4e235383d51c299dbdfd2fed2625971b0/rpds_py-0.10.0.tar.gz"
    sha256 "e36d7369363d2707d5f68950a64c4e025991eb0177db01ccb6aa6facae48b69f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/9e/780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91/soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
  end

  resource "spdx-tools" do
    url "https://files.pythonhosted.org/packages/28/2d/c3982e35bea2be16c529074a668acd851e8381acd9e2acaa830cc36bd039/spdx-tools-0.8.1.tar.gz"
    sha256 "c83652cd65b5726058dcbdaab85839dbe484c43ea6f61046137516aa1b8428ae"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/e4/84/4686ee611bb020038375c5f11fe7b6b3bb94ee78614a1faba45effe51591/texttable-1.6.7.tar.gz"
    sha256 "290348fb67f7746931bcdfd55ac7584ecd4e5b0846ab164333f0794b121760f2"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "unidiff" do
    url "https://files.pythonhosted.org/packages/a3/48/81be0ac96e423a877754153699731ef439fd7b80b4c8b5425c94ed079ebd/unidiff-0.7.5.tar.gz"
    sha256 "2e5f0162052248946b9f0970a40e9e124236bf86c82b70821143a6fc1dea2574"
  end

  resource "update-checker" do
    url "https://files.pythonhosted.org/packages/5c/0b/1bec4a6cc60d33ce93d11a7bcf1aeffc7ad0aa114986073411be31395c6f/update_checker-0.18.0.tar.gz"
    sha256 "6a2d45bb4ac585884a6b03f9eade9161cedd9e8111545141e9aa9058932acb13"
  end

  resource "uritools" do
    url "https://files.pythonhosted.org/packages/44/71/2712397a459ef0c960141f1f9fdf5a6b48052c521644c7154c508d976373/uritools-4.0.2.tar.gz"
    sha256 "04df2b787d0eb76200e8319382a03562fbfe4741fd66c15506b08d3b8211d573"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/38/44/d747807b707465625ba5e18371bc7c448925314d7217ced1801162b74ca6/websocket-client-1.6.2.tar.gz"
    sha256 "53e95c826bf800c4c465f50093a8c4ff091c7327023b10bfaff40cf1ef170eaa"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
  end

  def install
    virtualenv_install_with_resources
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
