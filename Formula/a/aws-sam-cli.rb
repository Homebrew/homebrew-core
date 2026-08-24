class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/6d/66/c41a2a48d79dc63210da344fee668c6e3e017cb1fdafab31067ff761f5e3/aws_sam_cli-1.165.0.tar.gz"
  sha256 "cd738cc09d4914f43cd980eb7dc193213d025b5aa502345038b16a00e03f4312"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sam-cli.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc78f58a0d3ca82ac47922e69c9c5e8aa5d4e3b2bc80588b5b61a4a279ddd9b7"
    sha256 cellar: :any, arm64_sequoia: "8da493b28aad84a405217bc7dca8ac8865ad294be99869c2a7e2dc0174f0c288"
    sha256 cellar: :any, arm64_sonoma:  "bb66ae3a33bf69fb63e0059c6b3bf02224394f889cbfca799605d21ec9be21cf"
    sha256 cellar: :any, sonoma:        "c5cad93a5b69f83754ff5a4e431ab577edac0babbabc35dbf7542f6d57babd24"
    sha256 cellar: :any, arm64_linux:   "2a13ed5fc62b5981c7eb89ba04c905a158a2b214d6753d536e4b4090ee1bfe00"
    sha256 cellar: :any, x86_64_linux:  "b60adfe542b0c630040d103901c4d872d49d5ef0a760a169f9f008e0fe57cc65"
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
    url "https://files.pythonhosted.org/packages/48/e9/cbe600212518d4b71c61f96206354ab3095cd1506050ae9cf52dfc19a04b/aws_lambda_builders-1.66.0.tar.gz"
    sha256 "a4844aa3c751f4faf544e616ca71525939b2202c7189b94e4c7e9c4f29f77f5e"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/8e/31/4e6d6f0b9d4ead8eaa1c13a14d86834e7691acf5726fb49de98f8e195028/aws_sam_translator-1.111.0.tar.gz"
    sha256 "6884d94e28dc20384e5e0396e9386a456fe59303d706924deb2646329b4d97d3"
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
    url "https://files.pythonhosted.org/packages/eb/ee/97798453d8e9dba0c60458870b07c78ac685fc21cdddd8eb3e20190249c6/boto3-1.43.38.tar.gz"
    sha256 "a8d1e175a87a743e755237d884d7e5f4606e61e5602e9823469a1a630e379b3c"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/d0/4e/c7ede5ac1c1769e7e418c16223fe452922c7e91b38a114241d6405f7f995/boto3_stubs-1.43.62.tar.gz"
    sha256 "a541bf0d20424ad427940b8938fff34bea28fc0d399906bdf3d193371016455a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4e/8d/36af6d99269a701f83809b87a01f4728699eb825ebdedee3a3d515b18f61/botocore-1.43.62.tar.gz"
    sha256 "94efc419c9f0f41dc2415e4b6b62f04ae21b3ce3930fac47214c4d3f361ea8b8"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/7f/81/79693e833291c00dc89ee610e5e915381b6f08233912e28df50106840780/botocore_stubs-1.43.14.tar.gz"
    sha256 "9e3bc1fdd51da7473f0df726c82747a1b0ae913449d629659765c247fecc2039"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/ed/67/6e8416db23ac67854c66123dd97d1758d2dd0ff2603653a97d9dd872bed5/cfn_lint-1.52.1.tar.gz"
    sha256 "696cf93fc3c20c257eb7c5ce4622621bc8f5b0823cb5e0ea2d042e1eb0c2cd0c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
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
    url "https://files.pythonhosted.org/packages/d3/f4/561c49bca97af561d34eed27e3e831135eb5cb88e754c1150be41820f5c6/dateparser-1.4.1.tar.gz"
    sha256 "f265df13c0380e2e07543ba74b67c0681aaa1096981ffcd35227e1aa0cb81c7c"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
    url "https://files.pythonhosted.org/packages/e5/0a/e79b04e72dfafae0687a8f9da7ab85b27d4a6226b0b2679af5c355b40fa1/mypy_boto3_ecr-1.43.0.tar.gz"
    sha256 "b6c40141060d0b7a8c596ee3c1b473eab5487e1d51ff92a1ff11eaf58e737fab"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/5e/9b/f34afc2b2d2760203f9ee48df5f660206972f43a31905ce2995b4fa6f999/mypy_boto3_iam-1.43.60.tar.gz"
    sha256 "4a1f36a68cb3f962c000f2056204346d1c19616a1227997c5707b2639e734d83"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/3c/4f/49136b4e3e158494f73b47e89326d3f1b8a628fcb9c4591abbc862e5ac6f/mypy_boto3_kinesis-1.43.0.tar.gz"
    sha256 "5511a9c67a110e1d7b4af7c7834987c2509284cc0aae4c2a3c7b572681652575"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/07/77/7cebb2f0b88680cdf91eaa1c33fb88e0cbd27b4387fd352a8d7bcbc4c68d/mypy_boto3_lambda-1.43.60.tar.gz"
    sha256 "c0f7e6d984c0fc5120966786915ef3012e9ccc9d382de412e0b71f309667851c"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/97/e6/83141bd1cb8e060ecfd98ba23cfc295eae0123194add7d02e16d6d7e211e/mypy_boto3_s3-1.43.50.tar.gz"
    sha256 "206817d22e80795da35daf704225f2e2a2b561fa4bf8c609f2150b04800ae811"
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
    url "https://files.pythonhosted.org/packages/eb/c7/9b5d40afdc9e8f772bfea842231c0fb0d6b162d078a6245f8be8d1487010/mypy_boto3_stepfunctions-1.43.7.tar.gz"
    sha256 "beee206867dae74e2f1f45055e2ca7c8003f502cd0c5b31dd784129758e61e4e"
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
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/74/b7/da07bae88f5a9506b4def6f2f4903cf4c3b8831e560dba8fa18ca08f758f/pyopenssl-26.3.0.tar.gz"
    sha256 "589de7fae1c9ea670d18422ed00fc04da787bbde8e1454aea872aa57b49ad341"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
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
    url "https://files.pythonhosted.org/packages/20/98/04b13f1ddfb63158025291c02e03eb42fbb7acb51d091d541050eb4e35e8/regex-2026.7.19.tar.gz"
    sha256 "7e77b324909c1617cbb4c668677e2c6ae13f44d7c1de0d4f15f2e3c10f3315b5"
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
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
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
    url "https://files.pythonhosted.org/packages/51/db/03eaf4331631ef6b27d6e3c9b68c54dc6f0d63d87201fed600cc409307fd/tomlkit-0.15.0.tar.gz"
    sha256 "7d1a9ecba3086638211b13814ea79c90dd54dd11993564376f3aa92271f5c7a3"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/3e/59/44409a8fc06b444ab1a6f71dcb29d49a6e17e02424345eb51b051bebb345/types_awscrt-0.34.1.tar.gz"
    sha256 "559aa04250f6a419a617dfb788f3e10903aaf74700ef23e521b64a411b83b803"
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
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
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
    url "https://files.pythonhosted.org/packages/39/62/75f18a0f03b4219c456652c7780e4d749b929eb605c098ce3a5b6b6bc081/wheel-0.47.0.tar.gz"
    sha256 "cc72bd1009ba0cf63922e28f94d9d83b920aa2bb28f798a31d0691b02fa3c9b3"
  end

  resource "aws-lambda-rie" do
    url "https://github.com/aws/aws-lambda-runtime-interface-emulator/archive/refs/tags/v1.35.tar.gz"
    sha256 "b16996104d94f26b312bb16699b0fccc156185a41523cb3993e0c97536a29b56"

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
