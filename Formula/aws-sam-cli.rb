class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/70/77/8f466d5d084a127f8ba1f9f2944f3032e372e7b5ab664e0af5ec33446826/aws-sam-cli-1.80.0.tar.gz"
  sha256 "ccc787ff259eb185a0e478f56f8db4c85b7ffd546801dd73c2777847ea21889e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01eac770221cd7a354848e01dd962e48b2e5f115895b241a85105cb480ba1507"
    sha256 cellar: :any,                 arm64_monterey: "a067217a5852e18681701ec58523f5106852c135f12ad6dbf3e12f6acf966d12"
    sha256 cellar: :any,                 arm64_big_sur:  "43d2667cefd834392ea00e2752b70a4af71e1380bb3d7c0f13b608e399930ca4"
    sha256 cellar: :any,                 ventura:        "84915c6cded3019fbedff8ee98f2f3da3005f5d1d198d9347afa60d50fac3568"
    sha256 cellar: :any,                 monterey:       "be7c4fb7702a35d5ca1d6bad550f857c4523f50d74768aaa7a773a8463454b5b"
    sha256 cellar: :any,                 big_sur:        "89046eca7f8651a4e67875e07e00f9862129a5de09251b85baeda217fe135d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8e316ff84163d0ece2b2d97dd5ef1d330764bb7d63ad235ab7ab89b193590d5"
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
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/93/b3/6714b5d3455b3e115c04d420d98314f3342234d04681885ed2c62e288de6/aws_lambda_builders-1.29.0.tar.gz"
    sha256 "292e4a52550a27a80a46f66b3d3256840f252df343ef82c38f5d89f3073e9820"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/e5/49/a14ff9c35cf44f2c94ddc0cc04d9c3adf764812312d4a66d310e120a26ee/aws-sam-translator-1.64.0.tar.gz"
    sha256 "0cc5b07dd6ef1de3525d887a3b9557168e04cb44327706a43661653bad30687f"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/78/a8/b07686bd9a56e2556708d562c6b8ade423f3cf4cb1b7c3cbc9ed6c24d022/boto3-1.26.115.tar.gz"
    sha256 "2272a060005bf8299f7342cbf1344304eb44b7060cddba6784f676e3bc737bb8"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9e/00/4560081a431aaa14c2257040d43f56c2ccba816d8bce3b8e1577a19f4076/botocore-1.29.115.tar.gz"
    sha256 "58eee8cf8f4f3e515df29f6dc535dd86ed3f4cea40999c5bc74640ff40bdc71f"
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
    url "https://files.pythonhosted.org/packages/3c/aa/3d0fa2b5d250e3238cb34030cfda527cd52c6acf58aeb5cb239766f9ce46/cfn-lint-0.77.1.tar.gz"
    sha256 "f2861748ef8ba4bcb9f47bd12ea396f11b0f29ff50ca98fec39de52695544b61"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
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
    url "https://files.pythonhosted.org/packages/7e/16/e95f1d2f8014bac38e00d037e192222e52de7db7c71268ed3b2e12d4893c/dateparser-1.1.8.tar.gz"
    sha256 "86b8b7517efcc558f085a142cdb7620f0921543fcabdb538c8a4c4001d8178e3"
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
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/a1/47b974da1a73f063c158a1f4cc33ed0abf7c04f98a19050e80c533c31f0c/networkx-3.1.tar.gz"
    sha256 "de346335408f84de0eada6ff9fafafff9bcda11f0a0dfaa931133debb146ab61"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/43/5f/e53a850fd32dddefc998b6bfcbda843d4ff5b0dcac02a92e414ba6c97d46/pydantic-1.10.7.tar.gz"
    sha256 "cfc83c0678b6ba51b0532bea66860617c4cd4251ecf76e9846fa5a9f3454e97e"
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
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/d8/29/bd8de07107bc952e0e2783243024e1c125e787fd685725a622e4ac7aeb3c/regex-2023.3.23.tar.gz"
    sha256 "dc80df325b43ffea5cdea2e3eaa97a44f3dd298262b1c7fe9dbb2a9522b956a7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
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

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/5a/36/4667b08bc45131fe655a27b1a112c1730f3244343c53a338f44d730bd6ba/sympy-1.11.1.tar.gz"
    sha256 "e32380dce63cb7c0108ed525570092fd45168bdae2faa17e528221ef72e88658"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4d/4e/6cb8a301134315e37929763f7a45c3598dfb21e8d9b94e6846c87531886c/tomlkit-0.11.7.tar.gz"
    sha256 "f392ef70ad87a672f02519f99967d28a4d3047133e2d1df936511465fbb3791d"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/89/e7/5fc01b31d9df0b914d5bbbea6f5d80ff76c6b5cf11bf23a8beca8407a0f1/tzlocal-3.0.tar.gz"
    sha256 "f4e6e36db50499e0d92f79b67361041f048e2609d166e93456b50746dc4aef12"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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
    url "https://files.pythonhosted.org/packages/fc/ef/0335f7217dd1e8096a9e8383e1d472aa14717878ffe07c4772e68b6e8735/wheel-0.40.0.tar.gz"
    sha256 "cd1196f3faee2b31968d626e1731c94f99cbdb67cf5a46e4f5656cbee7738873"
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
