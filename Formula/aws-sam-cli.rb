class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/5f/10/9fb21550e9c819278bebfa00c5ba058a2afae6fab5b2d62c8d40e36a78df/aws-sam-cli-1.76.0.tar.gz"
  sha256 "1d2ab13b415d73bbdf5ecde0dc6ff2eb952873fe1bba53c3910362453afcca70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "344404855342077316009641917199b66d75fa96af1756297d430ffb7421ee43"
    sha256 cellar: :any,                 arm64_monterey: "71f851fe298c4c0576b7bb4ff1249ba1b28ff62a201c625fac83eb0245771730"
    sha256 cellar: :any,                 arm64_big_sur:  "a2615c98cf18a92fe3f884e2a81035cc9916f37076e4346cf387f645473e7ae7"
    sha256 cellar: :any,                 ventura:        "30d82a62fe93f5df9de99347ef1c072bd0b15f031d39b07fbf0cdadf05c308b0"
    sha256 cellar: :any,                 monterey:       "adbca4357860926b785a7ba08bac44ab557fa4ad28093b8fbe83692135e2b2d2"
    sha256 cellar: :any,                 big_sur:        "cff7090215f121841f385bfae032c4d7bd85044ade4a3a458e1da346f31c8cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d16b19fd0bd14d5cf3bd4f89d122b52a6471aaddb27ece35172f8bc162e7061e"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/ab/67/29dca093bf230c675047e2d690070eb5b9d5909aa345834b1be541739eee/aws_lambda_builders-1.27.0.tar.gz"
    sha256 "8019d5d5d7de32b159e33ff447672308fc20dd58bc7452f82af15f6667037e1f"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/a9/f3/1992ced4e2fc69137f37c563b23249a5bd142979214fb77fb6258c04edb4/aws-sam-translator-1.60.1.tar.gz"
    sha256 "a73f5ad997e63f36ffc77dcfbe23fbaa68bafdfea993420b7a9c40b2f190e985"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1e/27/51c9b88c4c8cd2001efa3f628085553ecea9bcdad95baade3cc187f0980f/boto3-1.26.84.tar.gz"
    sha256 "7ab7bb335b726e2f472b5c050028198d16338560c83c40b2bd2bd4e4018ec802"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/cc/70/baa9c9383e52da51fc52b508770ccbff6c203027f27b4959feeb3000bffe/botocore-1.29.84.tar.gz"
    sha256 "a36f7f6f8eae5dbd4a1cc8cb6fc747f6315500541181eff2093ee0529fc8e4bc"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/e5/ab/896d52b8dbaa08a35c99eef6001a1700ba0ae03e7d32f89e806161447854/cfn-lint-0.74.0.tar.gz"
    sha256 "b5096fe3d1a1f6ff99cfd1b219b9237ec10759a92784391b98d586dc345a39ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/96/43/65a3dad94dceaaaa12807ce4d4eff1064db6e91a8c6fb6945e3e61e63552/cookiecutter-2.1.1.tar.gz"
    sha256 "f3982be8d9c53dac1261864013fdec7f83afd2e42ede6f6dd069c5e149c540d5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/f3/f4b8c175ea9a1de650b0085858059050b7953a93d66c97ed89b93b232996/cryptography-39.0.2.tar.gz"
    sha256 "bc5b871e977c8ee5a1bbc42fa8d19bcc08baf0c51cbf1586b0e87a2694dde42f"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/44/ea/cbf18a84d7b97261ec8f2d5d6ef5e1c44101189d33aca22a18bd52c4e73a/dateparser-1.1.7.tar.gz"
    sha256 "ff047d9cffad4d3113ead8ec0faf8a7fc43bab7d853ac8715e071312b53c465a"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/d8/19/25ddbe30edff87274afb2b364c653c7f7bbdd515337700377f1adf0834c5/docker-4.2.2.tar.gz"
    sha256 "26eebadce7e298f55b76a88c4f8802476c5eaddbdbe38dbc6cce8781c47c9b54"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/84/9d/66347e6b3e2eb78647392d3969c23bdc2d8b2fdc32bd078c817c15cb81ad/Flask-2.0.3.tar.gz"
    sha256 "e1120c228ca2f553b470df4a5fa927ab66258467526069981b3eb0a91902687d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/2b/3f/dd9bc9c1c9e57c687e8ebc4723e76c48980004244cf8db908a7b2543bd53/jsonpickle-3.0.1.tar.gz"
    sha256 "032538804795e73b94ead410800ac387fdb6de98f8882ac957fcd247e3a85200"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/99/f9/d45c9ecf50a6b67a200e0bbd324201b5cd777dfc0e6c8f6d1620ce5a7ada/networkx-3.0.tar.gz"
    sha256 "9a9992345353618ae98339c2b63d8201c381c2944f38a2ab49cb45a4c667e412"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/af/6e/0706d5e0eac08fcff586366f5198c9bf0a8b46f0f45b1858324e0d94c295/pyOpenSSL-23.0.0.tar.gz"
    sha256 "c1cc5f86bcacefc84dada7d31175cae1b1518d5f60d3d0bb595a67822a868a6f"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/de/63/0f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1/python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4c/69/acbf9b28cc1b699ef8d5152c40e0fc130d120ef13187f0fd54dd4afb7770/regex-2021.9.30.tar.gz"
    sha256 "81e125d9ba54c34579e4539a967e976a3c56150796674aec318b1b2f49251be7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "serverlessrepo" do
    url "https://files.pythonhosted.org/packages/30/99/c19bb97609a2f8089082f7f882c90393fb2e99027d8c2094e8cc4ac3d83b/serverlessrepo-0.1.10.tar.gz"
    sha256 "671f48038123f121437b717ed51f253a55775590f00fbab6fbc6a01f8d05c017"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/65/ed/7b7216101bc48627b630693b03392f33827901b81d4e1360a76515e3abc4/tomlkit-0.7.2.tar.gz"
    sha256 "d7a454f319a7e9bd2e249f239168729327e4dd2d27b17dc68be264ad1ce36754"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/89/e7/5fc01b31d9df0b914d5bbbea6f5d80ff76c6b5cf11bf23a8beca8407a0f1/tzlocal-3.0.tar.gz"
    sha256 "f4e6e36db50499e0d92f79b67361041f048e2609d166e93456b50746dc4aef12"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/ad/9e/df37da9de16e02d8a4230dcd09d4bf7ced6cd97e1f421cbade133a011e3f/watchdog-2.1.2.tar.gz"
    sha256 "0237db4d9024859bea27d0efb59fe75eef290833fd988b8ead7a879b0308c2db"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/8b/94/696484b0c13234c91b316bc3d82d432f9b589a9ef09d016875a31c670b76/websocket-client-1.5.1.tar.gz"
    sha256 "3f09e6d8230892547132177f575a4e3e73cfdf06526e20cc02aa1c3b47184d40"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/02/3c/baaebf3235c87d61d6593467056d5a8fba7c75ac838b8d100a5e64eba7a0/Werkzeug-2.2.3.tar.gz"
    sha256 "2e1ccc9417d4da358b9de6f174e3ac094391ea1d4fbef2d667865d819dfd0afe"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a2/b8/6a06ff0f13a00fc3c3e7d222a995526cbca26c1ad107691b6b1badbbabf1/wheel-0.38.4.tar.gz"
    sha256 "965f5259b566725405b05e7cf774052044b1ed30119b5d586b2703aafe8719ac"
  end

  def python3
    "python3.11"
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
