class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/4a/ba/9b77041ddfd31e7e084e7becdb188acdaf9c1ffd6f78ef227fc084769868/aws_sam_cli-1.174.1.tar.gz"
  sha256 "efa3a80a6268d7ca621d20ba5da315061fdf24e08f0a798d1a1309265753fbe4"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sam-cli.git", branch: "develop"

  bottle do
    manifest_sha256 "4af51a65c9c3c270876983d0f04e74162f9e973732808e7e19a1ba837408500f"
    sha256 cellar: :any, arm64_golden_gate: "4beb25e3d7a6135af4a91ac94e08873f7fd894d0af20b21e59bb7330bee87af5"
    sha256 cellar: :any, arm64_tahoe:       "a20051397fba078d951fcabbd9799dcf9cb680af13e5ef6685b21bd1f7f2fe6a"
    sha256 cellar: :any, arm64_sequoia:     "81ab41b4a4df26f9cb26bcd6a4d632ae2d85f29b155f64405b73d0fcbb3ba47c"
    sha256 cellar: :any, arm64_linux:       "e2c9ddfd3376b5385174a98e50a7b42ab5e8f39fb9ffc064995ef279cf1b045b"
    sha256 cellar: :any, x86_64_linux:      "594e8a93c85dac0e2cccdd298eb111ba9088e1daa6523fb8379bd7dbef04d298"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-checksums"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

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
    url "https://files.pythonhosted.org/packages/fe/b9/df67eb8d61cdf65f70b91eee906a4119dea5dc4df0b41eb8403cf6eb5b33/aws_lambda_builders-1.71.0.tar.gz"
    sha256 "d904e1a21c172398eba74d15a9723273751d975fd5a83b36112f0a47f60cf275"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/2d/2b/b47c5c8e7f5f7df694348cc679e03904beb5425b75ff2dd55c96eb51fe9f/aws_sam_translator-1.118.0.tar.gz"
    sha256 "117885ba599c6f890c3a5ed20d80dde2a2a3b8c5a784fa58fdccd8ae822f34ef"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/0c/c4/1f7c4161aa665b06ddb9c34acbe6b5ea8fc8bf72b78de474d65e6f494ca4/awscrt-0.38.0.tar.gz"
    sha256 "4a8423c4a76390c6e5c4f386e3e367dccdcf67d6d1a0bc1c59776bb14cdc2ad9"
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
    url "https://files.pythonhosted.org/packages/aa/b8/149e2c2a599a6a3d3818bb7d9c30996be703d6bfc71b2bbe11b7c1a86ecc/boto3-1.44.5.tar.gz"
    sha256 "667b344e25d2bcbb7c42fcf6b92a07bb1d73ee9d6d12c3a7873ec4c490b6fb64"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/13/a3/cc159729254cf56001ed86cc919e3cd11367fe6d81f6a5d2d26f36c230f0/boto3_stubs-1.44.11.tar.gz"
    sha256 "8ee4fd68b5ad7397e9d110290f4fd2e918549d3d3d664a914e659266c0604e75"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c3/d5/4adb74ed2633ac703e7574d8f48765a3ac7b0b3e38d82e5a24711af55c09/botocore-1.44.11.tar.gz"
    sha256 "c889792a88e04cc9f0b6eebc742112e5edb2710fe932f4c9a3ba784f92f09d75"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/8c/7a/717e3dec2e4721f76621ddb397b4035ec1aff0c174b80f5c439512a352e9/botocore_stubs-1.43.126.tar.gz"
    sha256 "15b14ba9066f6eec50a5861407fede151b4395e986036c8d564f4b908835f820"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/10/7e/d9395fa56b9f0f014e9e319daca03dd53133abefc2451b85f06ae4dc61dc/cfn_lint-1.58.0.tar.gz"
    sha256 "ba02cd7f7e06c8bc160936051a03ec931af52943fcc9cc72ad2748caa0f2a103"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/c2/c3/cae6d3bdefd96a941ffc247c714ac4babc488a69012e11c058f6c17c6c47/charset_normalizer-3.5.3.tar.gz"
    sha256 "a250888753faa289e2997962fbb17c4960cbdb58575533ca6fceee68c224bdff"
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
    url "https://files.pythonhosted.org/packages/89/d9/d15e289b14dd41758bcc89ad41cab96647ed221e7d4fa8b0dc27bf089740/dateparser-1.5.1.tar.gz"
    sha256 "1c3d4a568b4f4d615adfc2945b54596adffc14f955c9b435030b5236226a4366"
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
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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
    url "https://files.pythonhosted.org/packages/9c/b5/0236966b8a3d5b9bf147ea81932c0cd59358a77497bdb95d137e5ee3f080/jsonpatch-1.48.tar.gz"
    sha256 "81e9a03754137a1201d9b534ddd599cc0eb5983fe941bce238dc8a76e442bb94"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/46/cb/2c3112a061a718d93866c2555dad1e9d53865e4703d0f3be550d252b277b/jsonpointer-3.12.tar.gz"
    sha256 "7a3dcc11b64053eaa9c549e85e413f8d40a075215f793a331bed9182a14251ae"
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
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
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
    url "https://files.pythonhosted.org/packages/1e/d3/9cc32192674a6c2cb3825b26337a2be552d03a72355695ad90d108779a97/mypy_boto3_apigateway-1.44.5.tar.gz"
    sha256 "35982acc564e93b70e47cc94d5dc688629eb230f6fb3c4a7d559f1076626716f"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/fe/f0/69005663a7cbe837e6f1ce7884600a25ab8692d505e98bd9d1b874efcb24/mypy_boto3_cloudformation-1.44.7.tar.gz"
    sha256 "2a9063acead9f4dee17107c4dce1903ff46ed3c86248734348c46fd64a25326e"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/e4/39/d61eac1fdaf937024c6e9768f7d7fd5310e5b9877af44d221539fa3122a6/mypy_boto3_ecr-1.44.5.tar.gz"
    sha256 "8d2e3d6dcea16e59382b001197b54cf2169c9b99ad2cca9e9309cd2024bde612"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/b5/eb/4cead4fa4868648ceea40d5bf5ef9270f28e6e50b64d0b028dcbb3271cd5/mypy_boto3_iam-1.44.7.tar.gz"
    sha256 "0d6f72b9a5c902e8a9b77da34b650a08d93dea816b14fcef4914a1ec85364020"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/f3/56/b91ea7bd47dba0657d50a8280f917a936e4af5a57b2203de9b49968e46dd/mypy_boto3_kinesis-1.44.5.tar.gz"
    sha256 "52ea09c795347c954bbcc5c583be796a1d0c146c5d4b3d290fdb895d7b3ee98a"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/f2/38/70cde444979fa3ce1ca2d8c2c5e246e486e0016f642b7ecc31cb0a1f950a/mypy_boto3_lambda-1.44.7.tar.gz"
    sha256 "ed871acff762efd7bf853a780450f1e7a0f2122eddb5baceeaa2b26b7f6fe1ad"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/1b/34/2cfc7c13650830a2d6ab593218a09dbb7fed9bdcfca229f8206c3f1a52a8/mypy_boto3_s3-1.44.6.tar.gz"
    sha256 "82149e61a10ba7e1cab3a2d2c6333370d81143bb93ee2ae2348c355e7df2b7ef"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/75/52/c777ef900c2fbeeb52095e5e85978c4652de26201d1b1f3bca7aff68f9cd/mypy_boto3_schemas-1.44.0.tar.gz"
    sha256 "36115b3e3b35c9b894bdd80e7ebda644d8ad843a982c3d11b5bbe10057b43e57"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/a7/a1/dd89735f1d78c49f22df2b3c44861d09aae1cf66d8e7ecc2da18b8881e87/mypy_boto3_secretsmanager-1.44.2.tar.gz"
    sha256 "298bcffdbff85bf5dbe02ff7b444f2aff46110e0d7ffe5729ce8a2f33c56cfa5"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/71/d0/5dcfdfb8d1223c767181557ca9eb15a59d02e0620883eca6def1d1f08ab3/mypy_boto3_signer-1.44.0.tar.gz"
    sha256 "0ef6cdb0992230a09187493074e8b6f1a3f2e15d28d0db0ac58421b6f8cf7cba"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/c1/ab/b4980ce6108fdc8f3a1ba5c870eddbcb250ba325aa06a42cc32a6aefeebf/mypy_boto3_sqs-1.44.0.tar.gz"
    sha256 "8225fff746c9e69e5067d3aa9f1918b6ade07e5da9eac5f77f3f8f38fb5bb969"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/7c/83/424c7d35ae9e3daa1a0098c22ae704a196c9a91eae970dcf3998c92ec60a/mypy_boto3_stepfunctions-1.44.0.tar.gz"
    sha256 "347ba2b2806bf7b6e01cfa5d728e00e4ceaf1f44708bc27f2232768d13a1a402"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/44/98/6d4675b428757b0b161829944fcd1f424e5f59a39c7af31241910b87e380/mypy_boto3_sts-1.44.7.tar.gz"
    sha256 "f509aa03f558698f8eec9c629f928c1ce5ec4dd7459668932bbdaa3eb30765a4"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/0b/28/df0731e863f191682f36600416d938f961d58932814d4bfa46ddca0f10a3/mypy_boto3_xray-1.44.0.tar.gz"
    sha256 "25630477ff71371608ad2582f114589470c18686ca32e8554c31a5a89ed23fbc"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
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
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/5a/e6/8527e71118340258eb7e81def3f4377924528eda1e1be70fad008a31b70f/python_slugify-9.2.0.tar.gz"
    sha256 "cee32948083476013804de1667724fb1362dacb71e47b1d5d92adf8db6ee3298"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f5/b0/168030b0bfcc334cf09fa3313afdb888d892c8a0027324683d1de0ec277e/pytz-2026.6.tar.gz"
    sha256 "3b0fc2727707663d6e517936f444fd8a8b240f1fc32f4bf7ee03274245945284"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/e7/32/7c768de6489417ef32a49480af8a2dfba3adc5b1784d6e7142f32972018a/regex-2026.11.24.tar.gz"
    sha256 "07f222de81cdcfd39eef8671e92d14f50f61f1666f756659b0e649cf700b1b10"
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
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
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
    url "https://files.pythonhosted.org/packages/89/b2/4f2d72b5d234c81caa07dee688cacee2c8dc5bd793e9ae70a573f00d6425/types_s3transfer-0.19.3.tar.gz"
    sha256 "99422ef028a5f854cd92d1e72cf4208bd0569f68a87936ca02fb9f91a68cdcd3"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/4f/38/764baaa25eb5e35c9a043d4c4588f9836edfe52a708950f4b6d5f714fd42/watchdog-4.0.2.tar.gz"
    sha256 "b4dfbb6c49221be4535623ea4474a4d6ee0a9cef4a80b20c28db4d858b64e270"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/a4/34/4dd12fc8bb7d61c91467ec3efe415ffa7d5456f799954b40c5bbaeae470e/werkzeug-3.1.9.tar.gz"
    sha256 "55ca7c70a75689be937aa27f8ff4b018f06ff4838fc73045560bf0f5a1291060"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "aws-lambda-rie" do
    url "https://github.com/aws/aws-lambda-runtime-interface-emulator/archive/refs/tags/v1.38.tar.gz"
    sha256 "6f643377e85e78d75bdbe68217ec55c9774c9b90f4afa49c4efd292fd9a9d1f0"

    livecheck do
      url :url
    end
  end

  allow_network_access! :build

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"
    # Avoid overlinking to aws-c-* indirect dependencies
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install resources.reject { |r| %w[aws-lambda-rie cfn-lint].include?(r.name) }
    resource("cfn-lint").stage do
      # Allow Python 3.15
      # Upstream PR: https://github.com/aws-cloudformation/cfn-lint/pull/4764
      inreplace "pyproject.toml", 'requires-python = ">=3.10,<3.15"', 'requires-python = ">=3.10"'
      venv.pip_install Pathname.pwd
    end
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
