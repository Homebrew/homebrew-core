class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/eb/4d/4156ce2810daa3361d5708d684ab5c2d68d743f895f8770d418925e8eae2/aws_sam_cli-1.169.0.tar.gz"
  sha256 "1777145807fb61395d17846084b87260c6d02ad222376154b69fdc977270a15f"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sam-cli.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7f254211cac76073b914fd7dc0df9ffda380b9fc01fb791d2dbbcab85a60bc99"
    sha256 cellar: :any, arm64_tahoe:       "40ce3804ed9cb00e2358cc6bd32de619e3ca98473d352d8e04b7b96b799708f9"
    sha256 cellar: :any, arm64_sequoia:     "81b654d08a3824766e17f18d155543beec9947dc91527de5576c688e78097278"
    sha256 cellar: :any, arm64_linux:       "ee7e2b6512d726c25075a23ed51de24f5b88abf35c669fa6928c5f55e4dc89c3"
    sha256 cellar: :any, x86_64_linux:      "75a4a6c7305e9f8a65a53c95a90d2423d9d32361e738bb3a34c790cb60cdb5ce"
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
    url "https://files.pythonhosted.org/packages/8a/1f/bfe607960a3c4050db2a7488bb48212f581fb60a9f51f2faa3fe0bf5263e/aws_lambda_builders-1.67.0.tar.gz"
    sha256 "5dc24d16433e5d45d2efb1469e9ff50e9a1a322fc7d8ca056304e9067cf679a5"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/27/e1/265c488972e373f8bb8f4843c90297e8678e3452e65db7f77e659064c351/aws_sam_translator-1.115.0.tar.gz"
    sha256 "9766852bd212baa94f240b0b98b82ab1ed5857034bcc87cce5bfc782043d9902"
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
    url "https://files.pythonhosted.org/packages/48/59/fb93b6ebd9ad43eb9a58c7a6da51a0fe24ab0c04bc4d534a0bfc5eba7f59/boto3-1.43.108.tar.gz"
    sha256 "03341f089158368acf83e921aca98b706095322ca52bc4c039a616940aa5ad41"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/1b/71/bc2f423698d26a0b9bf9a15c90fc3b31cf54da1ece00a7b722ca9680b24f/boto3_stubs-1.43.113.tar.gz"
    sha256 "b948d7d6630b20798c6563b8f5f6c6e8887eaaf3b40a38dc17361d0a600ab341"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c5/43/e4b25ea3f83142dc13dda0313d5d818e20173c2c710d658dd206f67763e8/botocore-1.43.113.tar.gz"
    sha256 "941d3f0e289540da7c49d5e2dc022f992e3638127a02a74a0c91df2661bd98ef"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/54/87/86c5d1ab625e8253547e2c1a967b2575c7b00df27d7158cf636d16935b39/botocore_stubs-1.43.113.tar.gz"
    sha256 "49deda166eceee64243cca0b5dc9de5ce005949dee9ead477f8df22bafaee374"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/47/f6/2a8db80df4bcfce834376d570df37472986ed4f277ea3d523830af5ad151/cfn_lint-1.53.3.tar.gz"
    sha256 "2ed701460d68314e905165a9ceed4a9ddf874a03f5022a1070b96e3869b1a931"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
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
    url "https://files.pythonhosted.org/packages/df/f8/48a6033ebdd5013a58b5a79402eacb15ffb6e208f244c1c17f6f1e3b29c2/jsonpatch-1.35.tar.gz"
    sha256 "679ad08672b4663c7ef1e5f3331d940f5e7786661b9acc1530104be1638e7a4f"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/33/a2/c92f0a7ed439c490d2c8ad712fdb074c311afa4f77870987826a3b1483ba/jsonpointer-3.2.1.tar.gz"
    sha256 "47c846513b3a4ec46eecef1105207fba075e2a3659048e362bd7daff0fc33342"
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
    url "https://files.pythonhosted.org/packages/2f/74/eb13e4c6fcb88efb26f77f59129f6aec34ba96425838e588429980341762/mypy_boto3_apigateway-1.43.100.tar.gz"
    sha256 "ac5f525229097a411081dfd457702788efe6bbafb3aba953530d7b6e1809c2e8"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/0b/55/686017e42c03780cf78a3b9765a366c1b9ed11e79e24f5f4851d4978124b/mypy_boto3_cloudformation-1.43.110.tar.gz"
    sha256 "838313a3e25a50fcf969160c4dbebc0bc51407173ffdea163c3444bf533448bd"
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
    url "https://files.pythonhosted.org/packages/8a/02/177c85bb2422acceb6866085c98f183a001f7571807b030d4328ca305d03/mypy_boto3_kinesis-1.43.101.tar.gz"
    sha256 "c53332f7544e5653698c0c2d067fe4948aa1b8b5073a50fd3291c6b174965df5"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/3f/db/ee67bf27227b778114ec87c65387c1c3885283a9e46f21c3b3674c8de816/mypy_boto3_lambda-1.43.112.tar.gz"
    sha256 "ad4364c5f35a0ba0e1b67ac789a0296ac00fded9f0201fd306053094990482cf"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/46/db/e3922d6c62365c1098da97d9a775e78c66827df5cba11619a7d2a11cdae4/mypy_boto3_s3-1.43.106.tar.gz"
    sha256 "731195f15830699a36e29d3c8abb2918bccd3587eb2edcb233f8046967893279"
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
    url "https://files.pythonhosted.org/packages/63/2f/f4b904067f66ca7e754172947da7a4f3e6b1e690825d8beb00bf14018279/mypy_boto3_sts-1.43.94.tar.gz"
    sha256 "d169e309deecf99cb8a897e34733571fcaa605447e29b9f6a8c32202c82690ce"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/76/c3/849d39a853b3b627f5fea6cb552d9c579c80422def2423ef9d8ea4f52a55/mypy_boto3_xray-1.43.0.tar.gz"
    sha256 "68800f2eb955a85d166ad462b5f9563cbd6d0578845807137c93cd3f8e70eb44"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
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
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/bd/e8/26b1af09d728d604dc16427a39f53985b22a170dbd61addac3f48db73f03/python_slugify-9.1.3.tar.gz"
    sha256 "90e997f2e0987239ce95e12f700086eb18e1d1d3ee22624fbbdbd095afca42b6"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/14/21/d83d6ef28c4c912c4bb4d1dcf591f7b8c6bde87b9c66f9f454677314e16d/pytz-2026.5.tar.gz"
    sha256 "fa23724b9c486543b9ff54a327ee7569ac83ade54bb9afd0fc18676620401c86"
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
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
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
    url "https://files.pythonhosted.org/packages/61/29/4df7e8eccfdaac9308e06ae94271eb0e5d2324cbe6df241363c44b70e08c/types_s3transfer-0.19.2.tar.gz"
    sha256 "2a78a806c09b11fc6d59756402ade26b49b93a85ac6f209a39e2498211c6a41b"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/d9/68/f1b440335057bfce71b6e50a9d09445aa2ecbd08359a337976627b8409e7/tzdata-2026.5.tar.gz"
    sha256 "8cc73c0a0bfca7dbfa59235d60b2eff82231dee33f53d206db1acd9173cfc0a7"
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
    url "https://github.com/aws/aws-lambda-runtime-interface-emulator/archive/refs/tags/v1.37.tar.gz"
    sha256 "db221df3a827cd8fd987d7a796f1ee5dbd125b6c0fc1523bafe4627aff82714c"

    livecheck do
      url :url
    end
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"
    # Avoid overlinking to aws-c-* indirect dependencies
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install resources.reject { |r| %w[aws-lambda-rie cfn-lint].include?(r.name) }
    resource("cfn-lint").stage do
      # Allow Python 3.15
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
