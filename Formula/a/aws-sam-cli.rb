class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/9f/f8/af8a25e955ad132e346b1bf036fd479407de3d07fbf89c3e796bd19d39c2/aws_sam_cli-1.166.1.tar.gz"
  sha256 "32a4c5c1f03211d51d93b58e3cc5f4fb331c3dee4bff4105cbe0a24c71b770b3"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sam-cli.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3022159c5d8a7abf2c9ba60efd8b8e38aec7153402d36b63eb7a2603ba261d82"
    sha256 cellar: :any, arm64_sequoia: "c12a6985ffb3fc48327d7f9f0e118497deb58d5ef4e85c532de442dafbd06a25"
    sha256 cellar: :any, arm64_sonoma:  "91a79b548f7df89307853c6bf8578772c04c0d286ffec6d0ce02ed3f3f053bfe"
    sha256 cellar: :any, arm64_linux:   "48cfebc6633599d2312f1435e2af939ffab222f9d1328ca465aeecd19b37ba14"
    sha256 cellar: :any, x86_64_linux:  "c04b032445989abba2bba10670f74ff32be651fcf9134da4ab97209d7090ae0c"
  end

  depends_on "cmake" => :build # for `awscrt`
  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "openssl@3" # for `awscrt`
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic rpds-py]

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/8a/1f/bfe607960a3c4050db2a7488bb48212f581fb60a9f51f2faa3fe0bf5263e/aws_lambda_builders-1.67.0.tar.gz"
    sha256 "5dc24d16433e5d45d2efb1469e9ff50e9a1a322fc7d8ca056304e9067cf679a5"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/21/a4/a0d384f9dcd3960fb4942e5665ad4c11f10d92a8ba7f517dd6b11df768a9/aws_sam_translator-1.113.0.tar.gz"
    sha256 "3a24b3c5bab9c24b6389cdf18a7a745d338363c57803364e028718fb078259e5"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/6a/7d/fd87588cffbef8fbdb8436f14fa673ee3735cf8600a1a2a36ef78718cfd6/awscrt-0.36.0.tar.gz"
    sha256 "ad2198461f3b2a2851f37891d75dcb9173bfe2474d8550ad6260bf9970b4064a"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/86/72/4755b85101f37707c71526a301c1203e413c715a0016ecb592de3d2dcfff/binaryornot-0.6.0.tar.gz"
    sha256 "cc8d57cfa71d74ff8c28a7726734d53a851d02fad9e3a5581fb807f989f702f0"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ec/30/96cf7d324e75cd2c349e2911ae2334d987fb8525d551495a2ef6758c26f3/boto3-1.43.83.tar.gz"
    sha256 "6413d6e99f716af5d333a732db140e4b3359cac005a1271b11777b6d9ca82194"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/d6/c8/1870e13be5528f80ec80e1b0db4c97fb13d144a7ddf152efa8e3fe4d68e4/boto3_stubs-1.43.88.tar.gz"
    sha256 "619e49bf83d3841ec1b8b0f955568c4b53dffce58ab80d3c4038d8cbf2d79029"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/49/16/8944ffdbd6df92c463b77e933bae41a46fb1ec903c48a286e855761ce115/botocore-1.43.88.tar.gz"
    sha256 "3c8a6e2292f05c590c5d5299934dd23c81d19a2b6dd70b9eb724f79bd432d04f"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/3f/45/53d662227dc4787b2c854445ee7eb4751cb5d74cfb5c686a6ecbe1f94c17/botocore_stubs-1.43.67.tar.gz"
    sha256 "853e74014a1f557055c4ffae5fb38d7c65c7c0520e1aab366cac41d5428f419d"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/47/f6/2a8db80df4bcfce834376d570df37472986ed4f277ea3d523830af5ad151/cfn_lint-1.53.3.tar.gz"
    sha256 "2ed701460d68314e905165a9ceed4a9ddf874a03f5022a1070b96e3869b1a931"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/92/03/f4c96d8fd4f5e8af0210bf896eb63927f35d3014a8e8f3bf9d2c43ad3332/cookiecutter-2.7.1.tar.gz"
    sha256 "ca7bb7bc8c6ff441fbf53921b5537668000e38d56e28d763a1b73975c66c6138"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/c7/5d/bd21ba1519b6b1e222b29878301d2e1fb928e890dc7d085fa4222ac5671b/dateparser-1.4.3.tar.gz"
    sha256 "bab8c43a746266e68142f4926e69438ce551441aa88e54e78bb6410bf3ee7000"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/88/7f/731ff914b0255d3d065f45fd4e626d4b8c95dbcbaada049f337a6ac16410/docker-7.2.0.tar.gz"
    sha256 "cebb93773d334f778e023a7ee352a8d6e13ab1bd3b863a4d4a59dec897df43ac"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
    url "https://files.pythonhosted.org/packages/e6/6b/bde8856300e8d51f6d41d86fc9396f99274323d9e831c54c1fe48cc0a21c/mypy_boto3_apigateway-1.43.0.tar.gz"
    sha256 "2e828b1725ac3e44a6e033839d7929ab36e542c7b8a2c5092c07ad8ad47efd54"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/fe/fb/23525da8851dccef6e45cc9f334b89766fcc56cd5cf6d2f21dc3772e4586/mypy_boto3_cloudformation-1.43.62.tar.gz"
    sha256 "75c066d1a172497f6eee629ed7e4479787da4e4929194eb979fea87311805e19"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/e9/f1/704db62d36b42b8bf5b43a913c1d9ee0a85e9e45c28ce7604e6a28dc8d30/mypy_boto3_ecr-1.43.73.tar.gz"
    sha256 "d8ec39f4be668aa9e8835c4f36ccc6fe832ee2d24e7de3e261dc69186462c90a"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/04/eb/fc615caf1a4ba6e28c874e286f0bb9f4af5af5b1b2b493e09d655f6bc0bc/mypy_boto3_iam-1.43.70.tar.gz"
    sha256 "68bf4e6890ecaae76852d501090b8fd0b0438424009082a20bfe612f93de28fa"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/bb/7f/d1e4c05d65a712cf64473ef6d7558642bd7b0c67c0225eeb88761613b6d1/mypy_boto3_kinesis-1.43.86.tar.gz"
    sha256 "69df1d88fefcf755840b0cdf6c5312b48a9c04d7910a1c90fdeb852105fb6ac7"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/aa/41/327af6cf88a913c5eb562cc931a9c9a6688582e2f00b67d77cd1f0cddc95/mypy_boto3_lambda-1.43.86.tar.gz"
    sha256 "8b31847e36ecf676bc9ec0ceefd114051682176f28a5332a31c5c2b9203d29b1"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/5f/b4/d9af4054a80a46e27bfec10ead824ac1d39a974179b47db4ad9844bc5658/mypy_boto3_s3-1.43.66.tar.gz"
    sha256 "b2f74763e373b3f3d64cfcd2f00cdb1c10c8a4cefe6d4cdbc1ed4a6ade085c07"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/6c/54/01890422f25c1d475a429d7aae75ce5fe17b73b74a7cc6a05ffe0ec0a306/mypy_boto3_schemas-1.43.0.tar.gz"
    sha256 "c60f096160d69baf97af48eecebadf921eeb9900c6b94ed1b5d774cf9e48d5c8"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/c6/e0/3b9f954dcce063407224e6601ed5af2d684185387b0572901c5f984fc8f6/mypy_boto3_secretsmanager-1.43.0.tar.gz"
    sha256 "265ee2fddf9d3e42ae39685625fb7861a539110d8e324372847c0e1cbd666b20"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/fc/f1/9e3f053313d0a58c6f3b8095a14e9ac948c54b1cb02f0b19b8f8dd3aaf8c/mypy_boto3_signer-1.43.0.tar.gz"
    sha256 "3bf9a84a11f78bb6af2f9a73677367980c0c026d14505a7d83f4d54eeae92b39"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/42/1e/226725696a99c7dadfe8ebfba01575107fa15146029a7fb0082c650d8689/mypy_boto3_sqs-1.43.0.tar.gz"
    sha256 "3ec8e1e651e830affcf7fe151b2e3090b8ea98d73cb069053b09ca4c7f4c8636"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/72/7e/7e4b7288b22800161959e2b16c3e4de29a9e78498b8d6b4d4c135518300e/mypy_boto3_stepfunctions-1.43.88.tar.gz"
    sha256 "09f166489439887f0b2300e9101cd469c7ed3f937c73213b33f60dc5ca7a4ab0"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/af/fd/74a557327cc0a5f6cecb9671ab983bc186bcabb9ae95372c467f4fd32669/mypy_boto3_sts-1.43.0.tar.gz"
    sha256 "7c38cffd0f07ff226d0b8016610bf5fa19bd6fa2a75a04cfdeecba2cabea8a4c"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/76/c3/849d39a853b3b627f5fea6cb552d9c579c80422def2423ef9d8ea4f52a55/mypy_boto3_xray-1.43.0.tar.gz"
    sha256 "68800f2eb955a85d166ad462b5f9563cbd6d0578845807137c93cd3f8e70eb44"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/fb/48/fb042503b6ca6cd271261dc559fd6432f7d8c713153e9ec5c591af4dfc1c/pytz-2026.3.post1.tar.gz"
    sha256 "2211d3fcf9a797d3405cac96ac7f61d80e6a644f72a3309607282fe8a2010c5d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/19/c1/6b30b775c7bcc6cf6506a4d4741c2123e8d99cd50f3fe8cbd731f5fef526/regex-2026.9.3.tar.gz"
    sha256 "aabd43208e335f4c3f0b56de3464b066dd425983a58f6eeb5738bcd7465403db"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/fe/64/42689150509eb3e6e82b33ee3d89045de1592488842ddf23c56957786d05/types_s3transfer-0.16.0.tar.gz"
    sha256 "b4636472024c5e2b62278c5b759661efeb52a81851cde5f092f24100b1ecb443"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/92/ff/5a28bdfd8c3ebec42564ac7d0e54ca3db65044a9314a97f9564fa7a1e926/tzdata-2026.3.tar.gz"
    sha256 "4a1518b8993086a7982523e071643f3c0e5f213e75b21318e78bcabfff9d1415"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/4f/38/764baaa25eb5e35c9a043d4c4588f9836edfe52a708950f4b6d5f714fd42/watchdog-4.0.2.tar.gz"
    sha256 "b4dfbb6c49221be4535623ea4474a4d6ee0a9cef4a80b20c28db4d858b64e270"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "aws-lambda-rie" do
    url "https://github.com/aws/aws-lambda-runtime-interface-emulator/archive/refs/tags/v1.37.tar.gz"
    sha256 "db221df3a827cd8fd987d7a796f1ee5dbd125b6c0fc1523bafe4627aff82714c"

    livecheck do
      url :url
    end
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"

    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install resources.reject { |r| ["awscrt", "aws-lambda-rie"].include?(r.name) }
    # CPU detection is available in AWS C libraries
    ENV.runtime_cpu_detection
    venv.pip_install resource("awscrt")
    venv.pip_install_and_link buildpath, build_isolation: false

    generate_completions_from_executable(bin/"sam", shell_parameter_format: :click)

    # Rebuild pre-built binaries where source is available
    rapid_dir = venv.site_packages/"samcli/local/rapid"
    resource("aws-lambda-rie").stage do
      { "arm64" => "arm64", "x86_64" => "amd64" }.each do |arch, goarch|
        with_env(CGO_ENABLED: "0", GOOS: "linux", GOARCH: goarch) do
          output = rapid_dir/"aws-lambda-rie-#{arch}"
          rm(output)
          system "go", "build", "-buildvcs=false", *std_go_args(output:), "./cmd/aws-lambda-rie"
        end
      end
    end
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
