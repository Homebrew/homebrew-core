class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/d6/58/c3b73370b3190e652404e3a737d1347fb4336f6236c76a801a0d193069ab/aws-sam-cli-1.105.0.tar.gz"
  sha256 "4c57b9d305214373c0ba2a745a9c55e8c6c6fa01c5e9a15ca0553aef4a14ae78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81ccd8b2d9113ecb6d704b1e4f9867e3c1b93f9a18545d4872f4a4bf874f5f8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b370b664856de814ca29e706fa75dd350adbd26f81d5f9c9d13c622b5db56134"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b6c3faec00ba48a6fea5329b5a85c2759453ddaa70ece5269e43c8c5c4ca76"
    sha256 cellar: :any_skip_relocation, sonoma:         "19d79cd5776e9b7a4d6dc4b30a611d6bce4f696aec41f190a646780a34fef67c"
    sha256 cellar: :any_skip_relocation, ventura:        "6a73e923c4873dab541f0aee5b14097785b8e18d4268f25f5da300e810ca2733"
    sha256 cellar: :any_skip_relocation, monterey:       "cf7e0f72a567cbc7a86b419802589150c6471801467c1ac2c2f11a6229ebf492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36b5501383a85e2e666451de8ebca2e8b19db835fcf9351acd4b3edb94255e28"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "cfn-lint"
  depends_on "cookiecutter"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python-networkx"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python-requests"
  depends_on "python-sympy"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/76/c1/bf8459df09d67e79d2eab73e4c3c40b8e18a2f296c788ed9d591ce57a690/aws_lambda_builders-1.43.0.tar.gz"
    sha256 "15c4b497824a296690e9497dba93186544fbe8cf6af9afb1da2d3834ab84ab20"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/3f/0c/83a4f94d44059d90d7d22de6e154958f684b5504d2ff3aac809833b0dbb1/boto3-stubs-1.33.5.tar.gz"
    sha256 "40d7a52e60d477822655938083be43a9097a405f1d748ce86f5233685e0cddcc"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/8c/a6/032b037da415015e5f9e098e0dadb5a699714f22ec9051fa1529126dcaf4/botocore_stubs-1.33.13.tar.gz"
    sha256 "b7b08a1beec9e6605fba12ffcd007b695bfc0a29f379a039f1ed69ec8eb1f7c7"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/d8/09/c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5/flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "mypy-boto3-apigateway" do
    url "https://files.pythonhosted.org/packages/b5/ee/b2a2b367647dabcd022df3b077d34fd912d185aa4bfdfe643bb14edcc069/mypy-boto3-apigateway-1.33.0.tar.gz"
    sha256 "1f8eba3d043b591383101f8fd9675a6ee7f3c14d69dec26a51915ff3367f25ec"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/6c/52/65d95edbad63b3f8d0bf58a0c2973d26ef2a6c6366ccaff80b73a26e57a8/mypy-boto3-cloudformation-1.33.8.tar.gz"
    sha256 "24cc84f2c89da3f68425fd75763e9f1e83e4d9293ba4a49afa7909006e89e579"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/a0/15/272f04a21348ae937dce8e50bb25fe290f088a2e1e694d0f42b539f47669/mypy-boto3-ecr-1.33.0.tar.gz"
    sha256 "76b0a53f9826f5d52fd9242ace420f1d54db35dcccc391c5137480bfb68a1689"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/a9/49/5b31c6a0fe81666a6a459bd1ac014da84a1f17a32db068b0e24d91f6d8bd/mypy-boto3-iam-1.33.0.tar.gz"
    sha256 "7e6b7634eb4e1aa8dcbc6bd7e1d8d157e95353d3ef1c6ce79f3fd294fc5682cb"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/79/cd/64fa0b01085f4d553908d0e726e7e00ff56a061f4b71e7d09f24bb8839f2/mypy-boto3-kinesis-1.33.0.tar.gz"
    sha256 "cee6f4a447f09bc181ef31d11ad6f29694c5754c095e1637f75c441fca98a44f"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/ed/ea/78e9766a624869c12a12b4e7099dada2962468a19455fcbc2653f5e847b5/mypy-boto3-lambda-1.33.0.tar.gz"
    sha256 "beac0cb4b94f83a444242db16f601405bdfb6c15808c2c52720224d907e7af40"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/63/71/dd8de6a988e10781536fcf2b16daeba01123c047c7944bd472208cc8c138/mypy-boto3-s3-1.33.2.tar.gz"
    sha256 "f54a3ad3288f4e4719ebada3dde68c320507b0fc451d59bc68af7e6ab15cbdad"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/ce/7d/ed23494deabffe02cc02f4fe56c25fe192446822b7ddc9fc0f6d7532f737/mypy-boto3-schemas-1.33.0.tar.gz"
    sha256 "df11a93ec5b05d3eee53bcbf6bfa933fa3f5f28d5f19abdfa32d9380f9804e12"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/07/a9/74a239ea43c136256cf6685c6a365954d82d86d9950aadceb29549b71d28/mypy-boto3-secretsmanager-1.33.0.tar.gz"
    sha256 "ea765e79988689a2cf6ba9307666aa8a3784f715b371b8fdebcb7694f4e92b9a"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/8a/f2/0cf6a2fcd02dd5f73a4c7d5e7ec4af94e97dfd18caa29bdde74e7dac37bf/mypy-boto3-signer-1.33.0.tar.gz"
    sha256 "4b55bd3724a7544a49837f11f217c54a28374d7fedad59294f113d6525067025"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/1d/79/c0bd3c53cb0dbf0c09fb277b3143c9e4babfac961aa7cc6ce7080a24db51/mypy-boto3-sqs-1.33.0.tar.gz"
    sha256 "81f4838e81cbb0c088a10e287922fdf6a3f317cbab6647993ab9dbd567c0e8fb"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/85/c0/bf997a64ca847bf7bf8027c154d214aa4bc3406d1355bf2c09ac36b39cd2/mypy-boto3-stepfunctions-1.33.0.tar.gz"
    sha256 "09d9a520ba870e368dbffc48771745908cb2f0c427f9b3faff5ce53719a9638d"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/88/dc/8ddbb62bc423c385ea236475384896a2ce71f6297d61e15b3134831b4847/mypy-boto3-sts-1.33.3.tar.gz"
    sha256 "d008d75486ab03d9042ccfbbe2ebd6aa3e03c8660d48dc68177ae5db54fbabf8"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/f6/ce/23d416b95e30b34b2e17ffaaf4d0c1691c8c4c37c4c26c1ee775073f27aa/mypy-boto3-xray-1.33.0.tar.gz"
    sha256 "c75e6fc5b827ddb082d7d3794bd920e3f7103e066d8c97cccd4e684acc47bf3b"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/69/f7/952c6ddc3e7b336e5388e788b0e6bce51ca1cbefe0dcd4d321e321f5c6e2/types_awscrt-0.19.19.tar.gz"
    sha256 "850d5ad95d8f337b15fb154790f39af077faf5c08d43758fd750f379a87d5f73"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/18/55/d834e97f558ab0f6b49c49bc63434fe88be9d09ca4423dc93131fd3f1ac4/types_s3transfer-0.8.2.tar.gz"
    sha256 "2e41756fcf94775a9949afa856489ac4570308609b0493dfbd7b4d333eb423e6"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[cfn-lint cookiecutter].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
