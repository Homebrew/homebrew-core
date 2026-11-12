class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/3e/de/0dbaf8ad33f527fcfa03602e8c4d428f94ae2b9c9c806bb30b4a65c4d11f/aws_sam_cli-1.172.1.tar.gz"
  sha256 "621988d1ce586dde0edd2531cd7d9e797a48f1d6336700a2e5d0a5d7f136e63b"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sam-cli.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ba2da666b9510a7aee714b4f4230d827efbedd1b04c34ab51d8e576d5d4b0c8c"
    sha256 cellar: :any, arm64_tahoe:       "88f482db8c6751fa01b4d67eaabb3c3f6a617b696f7fb125308d3da692e7c512"
    sha256 cellar: :any, arm64_sequoia:     "7c33621ed8a35a264dfe9370a99501fbb92d44b0a3b2f5ebc36e6bf3d177204e"
    sha256 cellar: :any, arm64_linux:       "e470770f3acf3782e2f8ac2739eff05223724f37d3032ab2d6f80e485e53f9d3"
    sha256 cellar: :any, x86_64_linux:      "5338a8c26ff9cc830d737836bc048be9ca49b7663bcb2f8e720fb5d01a37cb2f"
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
    url "https://files.pythonhosted.org/packages/0d/f5/747988e9df154282690d9fdb5d2c69f017d71cf3b5c59bce554d6791c804/aws_lambda_builders-1.68.0.tar.gz"
    sha256 "89b23de84ac51b917b331b39eb0f52954f60305af2f5cdf63deec051b063e679"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/bd/af/f68d87f0d17b0b87edf2ba061fb4f1529e80964ac818435631d08eba5e2e/aws_sam_translator-1.116.0.tar.gz"
    sha256 "6d19629a94c68f81967ee5c58311a4bcf7cc419dbd1a1db5e341fd4e79623a42"
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
    url "https://files.pythonhosted.org/packages/48/59/fb93b6ebd9ad43eb9a58c7a6da51a0fe24ab0c04bc4d534a0bfc5eba7f59/boto3-1.43.108.tar.gz"
    sha256 "03341f089158368acf83e921aca98b706095322ca52bc4c039a616940aa5ad41"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/15/16/2abb69eb953e2951d9685651089bbe1ed4cd6716633c1c7160656c2d0c47/boto3_stubs-1.44.0.tar.gz"
    sha256 "ed70d60279f9af355d6236b8b8fe42664c0ee45af0be703e42d9b1a3123f6667"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8f/45/b4e606b0f66c11c6bd44e91381aa562c6b4dacf478b97b461a429036a89a/botocore-1.43.127.tar.gz"
    sha256 "93bae360fb3a6f1b8e36593faa8bbbfa05b19866f7a37e9606a98f13394156f8"
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
    url "https://files.pythonhosted.org/packages/da/c6/8bb3f0584e7affe13f092906b42fac0a22b6375bf80ed3896bb31fdcb497/dateparser-1.5.0.tar.gz"
    sha256 "08d62f2c00d3a1e806fc59d40c79e7554e31d84d3b8c6145820af051c92e7292"
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
    url "https://files.pythonhosted.org/packages/8f/13/43ae689f9340dc7339dc7f5a3b1772edcd48fb1eb62fd5d801a2aa09d382/jsonpatch-1.47.tar.gz"
    sha256 "5ed650b7517789e0f43428aa7b09442c0b90de0a0fd17a53fd0ebf55205c601e"
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
    url "https://files.pythonhosted.org/packages/65/ad/f5bd4fb2e4fcddc5cce0e49f3dc466f324203ffadb4b7aebf9eb616d9d7d/mypy_boto3_apigateway-1.44.0.tar.gz"
    sha256 "bf6e3f8515e80ae6d8d83b24013158848fafecee2e60a482b460758c9c440d27"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/89/a5/93be64dc9903dc5a51f634485a21ff9ff203cc9e76e9b0b4786dd5d188b6/mypy_boto3_cloudformation-1.44.0.tar.gz"
    sha256 "212378546655a54a1adc11d285aefd8aacd237f5b8568e7ad270172d7dfe47ef"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/3d/e8/d27e6be617dde1419ec746cb0aa94bb93da263b295e1b53562e229fc2db9/mypy_boto3_ecr-1.44.0.tar.gz"
    sha256 "fd74c9d25245e55d3c386ec39f7b41332e6c6174547fba428872ada531573e0e"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/9e/d0/f0a27e6977da712d4eeba8cb709a4d247739140866c68b91a8a2d6f4d154/mypy_boto3_iam-1.44.0.tar.gz"
    sha256 "f0556efafb96e41073ba288d36916daa358ef8f07a851ef46e3ed286db335ace"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/47/04/962f6025afb17667ad8ab80bc08557f99e096ec96bf3d4b4af406fa60d62/mypy_boto3_kinesis-1.44.0.tar.gz"
    sha256 "ac549267f7f7415566dc888e1038bf972447d50e75f411966726b25fa0dcd8e3"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/1e/fe/4f1045181b084d2c7a7b70307bf8cda2b4085a5d6a489c79bff4e312f527/mypy_boto3_lambda-1.44.0.tar.gz"
    sha256 "5ef3af390496ff71398514addb0b1d6c3bfea37ae45c8884fcaa333a855c7409"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/37/29/2276d9f646696587202b27324aa006a3cdcb54391d7adef34438e4a23b7f/mypy_boto3_s3-1.44.0.tar.gz"
    sha256 "ed98f0c6abeadbb36a96da2619c8f68f212f6671658defdd3eb80c018c7179da"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/75/52/c777ef900c2fbeeb52095e5e85978c4652de26201d1b1f3bca7aff68f9cd/mypy_boto3_schemas-1.44.0.tar.gz"
    sha256 "36115b3e3b35c9b894bdd80e7ebda644d8ad843a982c3d11b5bbe10057b43e57"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/ca/76/3ffc7407259256a7556cff1e3a515b979be4ca7721210fa7efa812e7dbb5/mypy_boto3_secretsmanager-1.44.0.tar.gz"
    sha256 "f18241ddcf7173bc9cd5cadef777891848b8b412729afd5e4c681b4f98c88915"
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
    url "https://files.pythonhosted.org/packages/e4/4b/e43939ab6078aa31d362ced9b22b6cee26856d8cebac5178928c605b85a2/mypy_boto3_sts-1.44.0.tar.gz"
    sha256 "4828500c2c7b2c55c9c2aa5ad23997430db24a6c19a548e80a421e2d0533f67c"
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
    url "https://files.pythonhosted.org/packages/f5/b0/168030b0bfcc334cf09fa3313afdb888d892c8a0027324683d1de0ec277e/pytz-2026.6.tar.gz"
    sha256 "3b0fc2727707663d6e517936f444fd8a8b240f1fc32f4bf7ee03274245945284"
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
    url "https://files.pythonhosted.org/packages/61/27/a5afeb952577b84ee5fe48b8b9ce47ae662dbb69cc5b76c28eff98f83b1e/regex-2026.11.9.tar.gz"
    sha256 "316a70fbd70e999c9664681cb0eb5b4982b2cc0f623c7c86a8a112e1bd4c6277"
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
