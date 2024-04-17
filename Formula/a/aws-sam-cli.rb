class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/dc/12/56f2d6079cbc0deb81203cba7904bbd362ec15571211bece8e323f09877c/aws-sam-cli-1.115.0.tar.gz"
  sha256 "cf24b5642bafcb59434de5f8092c2b8cf48227a3357b4a221c39612eebda087a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4da3baccd646a362324f29ea997ecd748a59dfaa3ad31d68a48a510d5d7ae7d"
    sha256 cellar: :any,                 arm64_ventura:  "e9c6d51326392549f12eca1fc1b3abd48560a1923dcf185bf74c8c9e28eb2943"
    sha256 cellar: :any,                 arm64_monterey: "9a655cc681e44032624b76ce6eb307d0d85f2fd3d6fc29b175f745575a63fdf4"
    sha256 cellar: :any,                 sonoma:         "deb763cef33b5a3bfa7242fa3cd9a63b15b1f742e3a5a5c70c53212acac89c9f"
    sha256 cellar: :any,                 ventura:        "98d0f9156881eb6dda87260b0ae293a8b806057616d918374f4f4183524d5e86"
    sha256 cellar: :any,                 monterey:       "9698368d62476456f4a001e3e116048636fca2dcebe3802f8e267b5976115ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6cc32942535ad85b12254e79093ee5d354433d489cb8ee1f8a8ccf17cb741c8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/3b/df/a50269bbe1574d7c927c03830626f117aa8d1dea5ab15e012786dc5b54ee/aws_lambda_builders-1.48.0.tar.gz"
    sha256 "683155f44f373aa72eba0ea74dd324d688881de65984e9ca391ca1ec10aee6ed"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/a5/b8/41fcb7d76ac74dcdfedf34c73b6ce4f75c19e68534806df319531315c47c/aws-sam-translator-1.87.0.tar.gz"
    sha256 "80f4fb6d53774634b6ea84af5fdfa9ad94a46945bc4ad4ef11c8008540dfa7f8"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/46/6d/8f361c95d4f948dae469a3072cf998f62300ca3bc1a311c1c029a2793313/boto3-1.34.83.tar.gz"
    sha256 "9733ce811bd82feab506ad9309e375a79cabe8c6149061971c17754ce8997551"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/cb/7e/66dcbfce173ff332bf4215b6f4c53b71c157118f26cfa37ac9add0dbbdcb/boto3-stubs-1.34.82.tar.gz"
    sha256 "be9e84af538fee69fc1c9cb0bb7cba254bb7b488cc87cea7038c336758d53253"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0c/b8/6d1ec4802de76d21851784ca2b1d26575f193c31ebd194a196d08dac0d0d/botocore-1.34.83.tar.gz"
    sha256 "0f302aa76283d4df62b4fbb6d3d20115c1a8957fc02171257fc93904d69d5636"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/8a/07/58235a1f53666f2dda03687499b20fb7711d1ac377c5a6a7759701989156/botocore_stubs-1.34.69.tar.gz"
    sha256 "463248fd1d6e7b68a0c57bdd758d04c6bd0c5c2c3bfa81afdf9d64f0930b59bc"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/42/dc/c6afb068eddaba2ba462a0c62645484f6b0d0bc77859c16339f1ba8a6718/cfn-lint-0.86.2.tar.gz"
    sha256 "c140c814b6a7db048ac881a4f9b7f4e8335afd706f523f3fbf884eb6322f16f9"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/52/17/9f2cd228eb949a91915acd38d3eecdc9d8893dde353b603f0db7e9f6be55/cookiecutter-2.6.0.tar.gz"
    sha256 "db21f8169ea4f4fdc2408d48ca44859349de2647fbe494a9d6c3edfc0542c21c"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
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
    url "https://files.pythonhosted.org/packages/72/4b/8c2df97303521f99a0a2cc9be7373ee175dbc01d4befb653ff7b8d32b442/jsonpickle-3.0.4.tar.gz"
    sha256 "a1b14c8d6221cd8f394f2a97e735ea1d7edc927fbd135b26f2f8700657c8c62b"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
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

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
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
    url "https://files.pythonhosted.org/packages/f4/ee/581cbb27d33af3564868810fa9eb66a38fbcc2bc8831dc2e961fb9931075/mypy-boto3-apigateway-1.34.56.tar.gz"
    sha256 "5ab15db30d730198384d6445d50cc1fec98361b85366dd092b10e9b9f4a1a2cb"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/2f/df/ad6af2bf4326aa2928a4757ffbae170eaa30130e85527aec57e59a412928/mypy-boto3-cloudformation-1.34.77.tar.gz"
    sha256 "990014182681f9df2257f185056126c0db30bf1260f6cd3d46cedb3cf467f0ad"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/52/05/3cb67f373c30340e0043d5d8f5f07a163e263a691b3254ce361c2c9090cd/mypy-boto3-ecr-1.34.0.tar.gz"
    sha256 "b83fb0311e968a42d4ca821b006c18d4a3e3e364b8cebee758ea4fa97c5ac345"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/e5/db/a790cb091d77007268bdf0ced0e9a6c79f25b820bd309d33f0ef86ab47b0/mypy-boto3-iam-1.34.83.tar.gz"
    sha256 "7261315616757ebf7509df0e9b091d5942e470eb51c4b23c662a06873a9a8eca"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/7d/14/fd707a18485ebf99ac10388b3f1bd2a40f49c8f04dbcd1e2aa86cc7991f9/mypy-boto3-kinesis-1.34.0.tar.gz"
    sha256 "f404e75badd5977e9f09741b769b8888854bdd411c631344686ab889efe98741"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/21/b3/49903a707edbe4f67ba5c4876288041e3841553c3c99b0172bc6682c18f5/mypy-boto3-lambda-1.34.77.tar.gz"
    sha256 "7b81d2a5604fb592e92fe0b284ecd259de071703360a33b71c9b54df46d81c9c"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/d2/a3/f1edebdb192960102579795d4acd25431daeae7f4ef6ef58719eb5934b22/mypy-boto3-s3-1.34.65.tar.gz"
    sha256 "2fcdf412ce2924b2f0b34db59abf06a9c0bbe4cd3361f14f0d2c1e211c0f7ddd"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/0b/7e/1850db88a985b7b044ab3c49e2cb5f2cebd531f01f228b86504cdffedef7/mypy-boto3-schemas-1.34.0.tar.gz"
    sha256 "3b25a71944192b0980c3bb5132deb7c06ee9b88580ed63f257fad97cf3bf2927"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/89/af/741842ef149f2ca8bc3e3c4e4888fb0fce770137c44eb1d61d9178f82b98/mypy-boto3-secretsmanager-1.34.72.tar.gz"
    sha256 "d0733c5b53e8b5e7bda00f4b42ed84af12e36a20c848917e49c173a0422ef03c"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/ea/69/7c5455482360efb2705f0253c2f7e5069ac4a0bc3038280eb2336409e25e/mypy-boto3-signer-1.34.0.tar.gz"
    sha256 "c11ed943ccd38ee54fc0ca90ed347ef770d695df49535eab96dd97fb3dbdc592"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/f7/79/d70757f58c90c1d530023e18bc45b33eb6fa4435121c965f8921c4bc1ca5/mypy-boto3-sqs-1.34.0.tar.gz"
    sha256 "0bf8995f58919ab295398100e72eaa7da898adcfd9d339a42f3c48ce473419d5"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/8d/95/857d5b47f42815c95d4bc118e5c1b5decad44a169b1766f07c6233724326/mypy-boto3-stepfunctions-1.34.0.tar.gz"
    sha256 "06d2296cee750d17cb62171420eea4614f20f29be45ee361854f8b599a6e8110"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/cc/73/e93911b3451f252f375967b77f816719bef549488293918c3a4a7b0afd54/mypy-boto3-sts-1.34.0.tar.gz"
    sha256 "b347e0a336d60162dd94074d9d10f614f2b09a455c9b42415850d54d676e2067"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/eb/46/c35eddcbfb026f46e7ad0d934c888f45401bd51844c5edaecdb3d5a5b1b3/mypy-boto3-xray-1.34.0.tar.gz"
    sha256 "f30785798022b7f0c114e851790af9b92cb4026ed28757e962d30fb4391af8e2"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/cd/fc/70fe71ff78f680d584eba9c55a30092f6ef0b9cf0c75a74bd35a24151a83/pydantic-2.7.0.tar.gz"
    sha256 "b5ecdd42262ca2462e2624793551e80911a1e989f462910bb81aef974b4bb383"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/3d/28/d693aab237fca82da327990a88a983b2b84b890032076ee4a87e18038dbb/pydantic_core-2.18.1.tar.gz"
    sha256 "de9d3e8717560eb05e28739d1b35e4eac2e458553a52a301e51352a7ffc86a35"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/91/a8/cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1/pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/59/d7/48b862b8133da2e0ed091195028f0d45c4d0be0f7f23dbe046a767282f37/referencing-0.34.0.tar.gz"
    sha256 "5773bd84ef41799a5a8ca72dc34590c041eb01bf9aa02632b4a973fb0181a844"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/ba/ce7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5e/rpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
    url "https://files.pythonhosted.org/packages/7d/49/4c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797/tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/32/b2/accbd6ead195853bd5c3a51dfb06c5438eaa1c49924c33bc877cf7062b55/types_awscrt-0.20.5.tar.gz"
    sha256 "61811bbf4de95248939f9276a434be93d2b95f6ccfe8aa94e56999e9778cfcc2"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/61/c5/c3a4d72ffa8efc2e78f7897b1c69ec760553246b67d3ce8c4431fac5d4e3/types-python-dateutil-2.9.0.20240316.tar.gz"
    sha256 "5d2f2e240b86905e40944dd787db6da9263f0deabef1076ddaed797351ec0202"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/5b/90/f00658473474581f334c43993f3cfd518955d4eb125cffa1279c94cf1605/types_s3transfer-0.10.0.tar.gz"
    sha256 "35e4998c25df7f8985ad69dedc8e4860e8af3b43b7615e940d53c00d413bdc69"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/cd/3c/43eeaa9ea17a2657d639aa3827beaa77042809410f86fb76f0d0ea6a2102/watchdog-4.0.0.tar.gz"
    sha256 "e3e7065cbdabe6183ab82199d7a4f6b3ba0a438c5a512a68559846ccb76a78ec"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0f/84/00f7193d7bd88ced26cd5f868903e431054424610dc7c041bbe87d2a4d66/werkzeug-3.0.2.tar.gz"
    sha256 "e39b645a6ac92822588e7b39a692e7828724ceae0b0d702ef96701f90e70128d"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b8/d6/ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69/wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
