class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/98/eb/c807322fd41cfe2c1b5bc85f4e909cf60deb74bfd935a7e229b7acd3e282/aws-sam-cli-1.97.0.tar.gz"
  sha256 "204b7c240de24b466169310a7873492ca2ce39f0f643745867663ad6ea62ff1b"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "052d0c6ef6a1847c23cd89e4e1a71c0a0c231a9d597a9215ba2685204d35b652"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e253e6bbfadbc8de146e54472a3039fa0cb0df28dd42f80e0eef14be94bf50f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6be5210be942b26e4a1377ebaf4476de66f6ca5a2975663c3442ddff660b1355"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0138c5152c90c02f64f1f77db7695f2c7ad57dbaea0a9e1411fdd731eb8f249a"
    sha256 cellar: :any_skip_relocation, sonoma:         "476912fb4e202c2dd40f406ee25b506dec9ab66beb95abd7f8c75806d3d22280"
    sha256 cellar: :any_skip_relocation, ventura:        "89c4ff3145438f41e52289072d85c11b543f365656221514613e9cf544246bc1"
    sha256 cellar: :any_skip_relocation, monterey:       "034227c87eb29e39a84d88904224cc42da60010fe709e74bfa1324fa18e0d0c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbe89151ed12f45224042bd149ce728c7ace852e0ada9fb9c36b069bfd61a8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a883b4a31a0f6eb0330002b380b943a647738e58c7f0b4999f290c3c4332f31"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
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
    url "https://files.pythonhosted.org/packages/fb/c5/dae34e28715f57594618a63461750eeaa5aec1629d3f7c1f735e0145bc00/aws_lambda_builders-1.37.0.tar.gz"
    sha256 "18df6b852e56d6754422d37b7c7a4637cbcc9e91e329955812424aefcc716f24"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/44/a0/16e847f550dca486926a1cbe54596ba5bc6ed8a4579a792533ce5396d931/aws-sam-translator-1.73.0.tar.gz"
    sha256 "bfa7cad3a78f002edeec5e39fd61b616cf84f34f61010c5dc2f7a76845fe7a02"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/e8/f9/a05287f3d5c54d20f51a235ace01f50620984bc7ca5ceee781dc645211c5/blinker-1.6.2.tar.gz"
    sha256 "4afd3de66ef3a9f8067559fb7a1cbe555c17dcbe15971b05d1b625c3e7abe213"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/15/d8/941c274e7e53ecc98179369f917dd0ea62f24b4b75e204153fe1e7713d09/boto3-1.28.41.tar.gz"
    sha256 "2f655ab7e577c7543f9ee4e42d98641ccf02230d2f33695a6b39617b765401f5"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/db/f2/4719aaa462b3038785fb4f4f76b60c5b26d0f5117e5829f2da44b1d4e7d5/boto3-stubs-1.28.38.tar.gz"
    sha256 "ced704f94b275f498c1213d6d5fa912dc97286c835d99809ec40388ee44bc622"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/48/b7/ef48fae435742bb890b0d4d8b095f06fe8e92beb275e906e1a851469c340/botocore-1.31.41.tar.gz"
    sha256 "4dad7c5a5e70940de54ebf8de3955450c1f092f43cacff8103819d1e7d5374fa"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/ed/12/96088ab5757cdb2491b1873332c08d13c7d8ff663999c4688f1ff6987ce6/botocore_stubs-1.31.41.tar.gz"
    sha256 "8738438ba52a6d97b3f5491290b72f5165d8be10d2e8f50a473081bb1eb1447a"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/1a/82/56adeb16c2a73c6d6e468a25e88f423f9b11b1744e8eefe458d463a2df7f/cfn-lint-0.79.9.tar.gz"
    sha256 "fb8a5fc674ce39469a66d37de19130f4b31fbe4685a19b65ec51c8c8f35e8990"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
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
    url "https://files.pythonhosted.org/packages/96/43/65a3dad94dceaaaa12807ce4d4eff1064db6e91a8c6fb6945e3e61e63552/cookiecutter-2.1.1.tar.gz"
    sha256 "f3982be8d9c53dac1261864013fdec7f83afd2e42ede6f6dd069c5e149c540d5"
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

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
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
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
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
    url "https://files.pythonhosted.org/packages/b4/a9/7c21c19e7a72e3c18bdc31cac4dddeced36036d82fbe652158d248671577/mypy-boto3-cloudformation-1.28.36.tar.gz"
    sha256 "0e1eeca0f44b8907ba9acd2547f5f68fe4ac6c3b226432561d189cca94544686"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/55/f7/fb23a8721b827434949378bc115512e80fffea94166d452f2abaf6a30e99/mypy-boto3-ecr-1.28.36.tar.gz"
    sha256 "435f81684a35c5a882810145ebd521609cfca1488d92ed038302b189df284451"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/63/5f/63688f6b6072d03c030c911846959913bbe56d7f56c7dbc45aac534589eb/mypy-boto3-iam-1.28.37.tar.gz"
    sha256 "39bd5b8b9a48cb47d909d45c13c713c099c2f84719612a0a848d7a0497c6fcf4"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/b4/56/67e14c37d7d59009498c4a26724e24488faa09273ec76bb27eef8102e987/mypy-boto3-lambda-1.28.36.tar.gz"
    sha256 "70498e6ff6bfd60b758553d27fadf691ba169572faca01c2bd457da0b48b9cff"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/d5/cc/ea7b050a104acc7d3ff9339eb4675b49b0a0cbefaf51019c4db11f89ebee/mypy-boto3-s3-1.28.36.tar.gz"
    sha256 "44da375fd4d75b1c5ccc26dcd3be48294c7061445efd6d90ebfca43ffebbb3e4"
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
    url "https://files.pythonhosted.org/packages/dd/d9/0d0bd879adaa3fec0489c4d7eeb7dba5a87c295d140a5f1464998823d33b/mypy-boto3-sts-1.28.37.tar.gz"
    sha256 "54d64ca695ab90a51c68ac1e67ff9eae7ec69f926649e320a3b90ed1ec841a95"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/c4/ac/b44e1ebee5adb190876946ed4ad6b368ac27333f4087d3f28edb49080747/mypy-boto3-xray-1.28.36.tar.gz"
    sha256 "fc7dfbd85d78c14bc45a823165c61dd084a36d7700b4935f88ff3a7b8e8dac48"
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
    url "https://files.pythonhosted.org/packages/3b/9b/a7631bf35e55326fd74654fe6bd896478f47d65e97ca69e60ddb1b3823ee/pydantic-1.10.12.tar.gz"
    sha256 "0fe8a415cea8f340e7a9af9c54fc71a649b43e8ca3cc732986116b3cb135d303"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
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

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4f/1d/6998ba539616a4c8f58b07fd7c9b90c6b0f0c0ecbe8db69095a6079537a7/regex-2023.8.8.tar.gz"
    sha256 "fcbdc5f2b0f1cd0f6a56cdb46fe41d2cce1e644e3b68832f3eeebc5fb0f7712e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ad/1a/94fe086875350afbd61795c3805e38ef085af466a695db605bcdd34b4c9c/rich-13.5.2.tar.gz"
    sha256 "fb9d6c0a0f643c99eed3875b5377a184132ba9be4d61516a55273d3554d75a39"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
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
    url "https://files.pythonhosted.org/packages/e7/50/7d6d4bfcce85ad92860eed2b9d3ebbbe415e8f5f132846c5fede3950eb81/types_awscrt-0.19.1.tar.gz"
    sha256 "61833aa140e724a9098025610f4b8cde3dcf65b842631d7447378f9f5db4e1fd"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/76/06/de027550b2935b9353748dc7f005aa20bdac5eac5df39398e8b63301f273/types_s3transfer-0.6.2.tar.gz"
    sha256 "4ba9b483796fdcd026aa162ee03bdcedd2bf7d08e9387c820dcdd158b0102057"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/38/44/d747807b707465625ba5e18371bc7c448925314d7217ced1801162b74ca6/websocket-client-1.6.2.tar.gz"
    sha256 "53e95c826bf800c4c465f50093a8c4ff091c7327023b10bfaff40cf1ef170eaa"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/ef/56/0acc9f560053478a4987fa35c95d904f04b6915f6b5c4d1c14dc8862ba0a/werkzeug-2.3.7.tar.gz"
    sha256 "2b8c0e447b4b9dbcc85dd97b6eeb4dcbaf6c8b6c3be0bd654e25553e0a2157d8"
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
