class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/98/eb/c807322fd41cfe2c1b5bc85f4e909cf60deb74bfd935a7e229b7acd3e282/aws-sam-cli-1.97.0.tar.gz"
  sha256 "204b7c240de24b466169310a7873492ca2ce39f0f643745867663ad6ea62ff1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ba0c0a47c7a11f6cc97b20cec4bdbbae7f77be09aee649ab2ccd0d03869b123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03b320a62c97b7dfbe270bed705e2ead72f777810073e67b98d393863ba3ed28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84f15abc2631af94a10cfdb5e145af69d04b5d58cb7b3540325e5751a7dd485c"
    sha256 cellar: :any_skip_relocation, ventura:        "78993768d2620440ba596daa664c66ebd798db146fc9adcdc7a5d96e5c65363d"
    sha256 cellar: :any_skip_relocation, monterey:       "920e3f030b84f81243675e0d1864bc49bd3300220143c0da83d7946a635c0eca"
    sha256 cellar: :any_skip_relocation, big_sur:        "108959dc21511d78442f30189c6ceefd64ff114b5fecaf0c7884756b1b077f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdaae5091238101bd1a4d2ae399f292f7fae3b88c52734fb657bc1147fe3c8c3"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-cryptography"
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
    url "https://files.pythonhosted.org/packages/75/8c/ef4fa9ca2e395489c74c53cbc0084791e00b79940a8396622fcc00facc5f/aws-sam-translator-1.71.0.tar.gz"
    sha256 "a3ea80aeb116d7978b26ac916d2a5a24d012b742bf28262b17769c4b886e8fba"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/20/a6/c1fab54e40fdae8d2c835e97c79d5051f59df427222f5adf5b6ed14f6405/boto3-1.28.38.tar.gz"
    sha256 "cdb466e51ebe4c99640269d88d5450328271437d58e6ce089690d0485bef6174"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/db/f2/4719aaa462b3038785fb4f4f76b60c5b26d0f5117e5829f2da44b1d4e7d5/boto3-stubs-1.28.38.tar.gz"
    sha256 "ced704f94b275f498c1213d6d5fa912dc97286c835d99809ec40388ee44bc622"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/bf/d9/e1f6a770eac0e6f1e2bd4913d3758fae36785e33150db19a35d5d5956fd2/botocore-1.31.38.tar.gz"
    sha256 "b02de7898f0a7de0f6569be1c87046035a974006c31fd641f4b97a8dba1fad21"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/1e/95/936de5991cd2f2eede891d1612ccce43d1bbeaf64329d1784357cd8574e6/botocore_stubs-1.31.38.tar.gz"
    sha256 "66076ec073cfa16f913ccb6e76df06b2080974786040d63a9a8d297459ebcae7"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/68/ad/bc3193f294200753b938a75982c5efb5019da3b24dd8d0897decf6b8fb65/cfn-lint-0.79.6.tar.gz"
    sha256 "09fc9cc497fc6d15e8b822a98fa0628ed6f8e9bcce6c289d95b2fc71d50aa63f"
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
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
    url "https://files.pythonhosted.org/packages/5f/76/a4d2c4436dda4b0a12c71e075c508ea7988a1066b06a575f6afe4fecc023/Flask-2.2.5.tar.gz"
    sha256 "edee9b0a7ff26621bd5a8c10ff484ae28737a2410d99b0bb9a6850c7fb977aa0"
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
    url "https://files.pythonhosted.org/packages/2b/3f/dd9bc9c1c9e57c687e8ebc4723e76c48980004244cf8db908a7b2543bd53/jsonpickle-3.0.1.tar.gz"
    sha256 "032538804795e73b94ead410800ac387fdb6de98f8882ac957fcd247e3a85200"
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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
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

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
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
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
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
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
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
    url "https://files.pythonhosted.org/packages/06/77/7580eb28b57a9eb849301d0f80c6e1863a71f66f52236c0239675ad7d8e4/types_awscrt-0.17.0.tar.gz"
    sha256 "4214783a747af900a5f98ec020d52ecae5910b470fd636813637a45b82a97516"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/e2/ce/d5754d2b30292d0e8e37ec677c9175f0a773f2c608ceb2ef35bd645131d2/types_s3transfer-0.6.1.tar.gz"
    sha256 "75ac1d7143d58c1e6af467cfd4a96c67ee058a3adf7c249d9309999e1f5f41e4"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/89/e7/5fc01b31d9df0b914d5bbbea6f5d80ff76c6b5cf11bf23a8beca8407a0f1/tzlocal-3.0.tar.gz"
    sha256 "f4e6e36db50499e0d92f79b67361041f048e2609d166e93456b50746dc4aef12"
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
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/d1/7e/c35cea5749237d40effc50ed1a1c7518d9f2e768fcf30b4e9ea119e74975/Werkzeug-2.3.6.tar.gz"
    sha256 "98c774df2f91b05550078891dee5f0eb0cb797a522c757a2452b9cee5b202330"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/3d/02a14af2b413d7abf856083f327744d286f4468365cddace393a43d9d540/wheel-0.41.1.tar.gz"
    sha256 "12b911f083e876e10c595779709f8a88a59f45aacc646492a67fe9ef796c1b47"
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
