class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/7a/6c/b028e3128229318d75b328458395e99be2281ad06b71e97c86d86664334d/aws-sam-cli-1.98.0.tar.gz"
  sha256 "4fb4f2c24ceb7fb86d5db25c714ccbc5f40fa7a2a4f664202396653ce3a6397e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20a8959c3ebd7a4fb3c1877ef017ce1da5452da4f2f4c6f0055dafec1e45bfb3"
    sha256 cellar: :any,                 arm64_ventura:  "834608a6e6f08231a6bce8fc5e0e85eb25160f827a7073cca82ee041e70ed7a7"
    sha256 cellar: :any,                 arm64_monterey: "ca6da26fee7a7437099fab6700e3a164c0568d4340dc2695291ce1d0d080ac5c"
    sha256 cellar: :any,                 sonoma:         "863af6445b3d7b8e71e3b6427b9041499c6660d4bcacf87a1b5f820277f48b07"
    sha256 cellar: :any,                 ventura:        "fc0e7a3e5bffbc5f6198a92ec239e7a31a193f1e94cc664dff61a1adc5a86e4f"
    sha256 cellar: :any,                 monterey:       "20e8139d3ff3ecfa690641150b6174d7c57820cf3ac5744cdb70e0e1d051d5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50621b3e7041c4847e90a645329d54a399f3ecfb098c81051d9dfd94fa3771dc"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/8d/55/68d3f33ff87ab3e17430df112a994e4fc20efebf107ea40d0d42b2d21af0/aws_lambda_builders-1.38.0.tar.gz"
    sha256 "c0ea144878e1a802b6face83c3342d0af02e2cbe9d083fc6cce547c2bd5bcc20"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/8e/db/852dbb2962c4b113af1faf7f0ec9258b6ba5d9e405b6e9c7396237d28f86/aws-sam-translator-1.75.0.tar.gz"
    sha256 "18c83abcae594de084947befb9c80f689f8b99ece2d38729d27a9cea634da15c"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/ea/96/ed1420a974540da7419094f2553bc198c454cee5f72576e7c7629dd12d6e/blinker-1.6.3.tar.gz"
    sha256 "152090d27c1c5c722ee7e48504b02d76502811ce02e1523553b4cf8c8b3d3a8d"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/2f/4ccd05e765a9aa3222125da37ceced40b4133094069c4d011ca7ae37681f/boto3-1.28.65.tar.gz"
    sha256 "9d52a1605657aeb5b19b09cfc01d9a92f88a616a5daf5479a59656d6341ea6b3"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/fa/dc/84f4da14b169824d03e33793cabcd9ff169ab3bfdd327a43ec24ac46389a/boto3-stubs-1.28.55.tar.gz"
    sha256 "5121b26e4c4bb8adc7ac1a19dd27d3bfe236b18bec2ace5f987b9df6e2511cd3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/30/e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555/botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/7d/d2/15cefec416da240a4261422bfe01f81cfa35431650e5c6f3da9d2668cbc1/botocore_stubs-1.31.65.tar.gz"
    sha256 "466d448eb4da3e808999b8cb2eabdc3d8c6f851b017ab06af48a598a2443082d"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/44/e8/f677fb4b83bbad27986acee442907848ff853c9eedbb465b3936cd390f70/cfn-lint-0.80.4.tar.gz"
    sha256 "53589cc4c2002bdf6c21c91f43e78a17dfbef2e870d7f45b0cbcb57bc76418d0"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/f0/d2/6301fc9bd1c8715d1393af7bba91be5e1593b692b9598f8d70f3b3bb68aa/cookiecutter-2.3.1.tar.gz"
    sha256 "42aa1d27368f58be600d13e56d5d2177684f8f69a40d9cbad84851ba44f842de"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/7e/16/e95f1d2f8014bac38e00d037e192222e52de7db7c71268ed3b2e12d4893c/dateparser-1.1.8.tar.gz"
    sha256 "86b8b7517efcc558f085a142cdb7620f0921543fcabdb538c8a4c4001d8178e3"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/46/b7/4ace17e37abd9c21715dea5ee11774a25e404c486a7893fa18e764326ead/flask-2.3.3.tar.gz"
    sha256 "09c347a92aa7ff4a8e7f3206795f30d826654baf38b873d0744cd571ca609efc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/6e/92/62fdc2f6b468b870dd171ad21748ef0ec2bff1b258c25ce6db3545cccc90/jsonpickle-3.0.2.tar.gz"
    sha256 "e37abba4bfb3ca4a4647d28bb9f4706436f7b46c8a8333b4a718abafa8e46b37"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/e4/43/087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5/jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "mypy-boto3-apigateway" do
    url "https://files.pythonhosted.org/packages/e2/5a/8e9af94dca5d4766b23cd97eae8b648f70eea78809191795a5ca4b57099c/mypy-boto3-apigateway-1.28.36.tar.gz"
    sha256 "e460e5b40b28fbe292f842993e7bf3ad514d0073774b30f1c5e137de6abac681"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/4d/d5/ce06e3c01a6c1f0b1865c97d64cfb509ca9f52d739425dcaa7369c564186/mypy-boto3-cloudformation-1.28.64.tar.gz"
    sha256 "b353d52a5607c54d2916f4bde26e9be90920635beb9ffb9255cd862dca3b56bf"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/00/8d/29ae794c78ff339231583aabc6fd021b1782eae2cc4ec4ea3e1b8d750f99/mypy-boto3-ecr-1.28.45.tar.gz"
    sha256 "3584a19a018bacd7b6e8147bc9ef6932967815c0918c6cf3929ff55f1c9be601"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/63/5f/63688f6b6072d03c030c911846959913bbe56d7f56c7dbc45aac534589eb/mypy-boto3-iam-1.28.37.tar.gz"
    sha256 "39bd5b8b9a48cb47d909d45c13c713c099c2f84719612a0a848d7a0497c6fcf4"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/a3/9d/f24a27bf3d39c315d2207ac9a92e9c806cd5d5d98d70a1fc7806ee4f3b7f/mypy-boto3-lambda-1.28.63.tar.gz"
    sha256 "7cbbee5560f347548a8f43324b31b2abfa1f56ec7380f20dadb837533fc0552a"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/18/39/faa8e38b928baf0a8b78eddf5582ba0370bd303c058c04a2903e97cc9e57/mypy-boto3-s3-1.28.55.tar.gz"
    sha256 "b008809f448e74075012d4fc54b0176de0b4f49bc38e39de30ca0e764eb75056"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/bb/ff/931e29e422bb586a8e9e8cb89224fa9998010647cbdf2ca3d6f4d1526020/mypy-boto3-schemas-1.28.36.tar.gz"
    sha256 "82af1ad64d0c1275c576607920f13dcc7605d6b7e8483dd58aced8395c824d5f"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/f7/c2/bfb40db9e002e8bc259b4f00fbf6b732d7845f0bc0bf07a508aa88b8ab11/mypy-boto3-secretsmanager-1.28.36.tar.gz"
    sha256 "7e390887d35bd3708d8c0ce9409525dad08053ea8da5fd047f72ec7bcf093fd3"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/32/7f/d8c9860b9bf609f3fc95cc3128ab36972db3e761510c770110cbb26f8955/mypy-boto3-signer-1.28.36.tar.gz"
    sha256 "e008e2f4bf8023aea207d35a8ae57de9879fba8109d2cf813ddb0ebbf5300e93"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/49/49/cec0697f3a58dd3a2a4eb6c10a0e245ac4a7ce1e8e87f6e766df977003f4/mypy-boto3-stepfunctions-1.28.36.tar.gz"
    sha256 "8c794e98abc5ca23ef13e351f46bb849de634baca6f35286e31e58dede40b687"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/1b/2c/fb20dfe37be29cb4a9356496adb24b9c3305e624cf248f0f7648a7008ffb/mypy-boto3-sts-1.28.58.tar.gz"
    sha256 "beffec705f1f0b449da3c1f52ac7658627bb289aecec1a4408266479c46e053b"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/74/f6/44fae37678a47e10190c467a9235b4bea3532aeab1d0ac7e02a3d7db678a/mypy-boto3-xray-1.28.64.tar.gz"
    sha256 "0657a2317de5e296fe4e0c784a3594c4c8bd8d63f801594650472e773a9619de"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/a1/47b974da1a73f063c158a1f4cc33ed0abf7c04f98a19050e80c533c31f0c/networkx-3.1.tar.gz"
    sha256 "de346335408f84de0eada6ff9fafafff9bcda11f0a0dfaa931133debb146ab61"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/e8/4f94ebd6972eff3babcea695d9634a4d60bea63955b9a4a413ec2fd3dd41/pydantic-2.4.2.tar.gz"
    sha256 "94f336138093a5d7f426aac732dcfe7ab4eb4da243c88f891d65deb4a2556ee7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/31/8e466c6ed47cddf23013d2f2ccf3fdb5b908ffa1d5c444150c41690d6eca/pydantic_core-2.10.1.tar.gz"
    sha256 "0f8682dbdd2f67f8e1edddcbffcc29f60a6182b4901c367fc8c1c40d30bb0a82"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/de/63/0f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1/python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/1d/d6/9773d48804d085962c4f522db96f6a9ea9bd2e0480b3959a929176d92f01/rich-13.5.3.tar.gz"
    sha256 "87b43e0543149efa1253f485cd845bb7ee54df16c9617b8a893650ab84b4acb6"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/ee/12/d6cfa2699916e5ece53a42e486e03b5a14e672c76ddb16d4649efcf9efb8/rpds_py-0.10.6.tar.gz"
    sha256 "4ce5a708d65a8dbf3748d2474b580d606b1b9f91b5c6ab2a316e0b0cf7a4ba50"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/de/7d/4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54/ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/11/7c/7df098b60b90df319b712ad3c700afa6c693dbf34b81e47ae6585716dfba/types_awscrt-0.19.3.tar.gz"
    sha256 "9a21caac4287c113dd52665707785c45bb1d3242b7a2b8aeb57c49e9e749a330"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/d0/7f/bcb4025a389d53d1cfc9d592d710bff173ac98945ac28c67b58bd98089fe/types_s3transfer-0.7.0.tar.gz"
    sha256 "aca0f2486d0a3a5037cd5b8f3e20a4522a29579a8dd183281ff0aa1c4e2c8aa7"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/8c/47/75c7099c78dc207486e30cdb2b16059ca6d5c6cdcf9290f4621368bd06e4/werkzeug-3.0.0.tar.gz"
    sha256 "3ffff4dcc32db52ef3cc94dff3000a3c2846890f3a5a51800a27b909c5e770f0"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a4/99/78c4f3bd50619d772168bec6a0f34379b02c19c9cced0ed833ecd021fd0d/wheel-0.41.2.tar.gz"
    sha256 "0c5ac5ff2afb79ac23ab82bab027a0be7b5dbcf2e54dc50efe4bf507de1f7985"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
