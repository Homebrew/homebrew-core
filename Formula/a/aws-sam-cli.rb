class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/88/d9/4bf0f712bade4e3b2e74b30dd105005564e45ea4b0cfb6f473a96419756d/aws_sam_cli-1.159.1.tar.gz"
  sha256 "4c3766e774dea0d23f156aeefed9f65182551e1b71e9e55cb6e13b330b15fac7"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0784c03c372f7b402f1afd39d1dbab542aa0ede69e368c2c3cb3c44ecfbc2516"
    sha256 cellar: :any,                 arm64_sequoia: "547b8d22e212a8fd460179d05bdcab0ed9895d404172a986ce0a44d2ba358a32"
    sha256 cellar: :any,                 arm64_sonoma:  "a44d179e7ac72d5359e8ba42c0a7dfd95b6bb305ab953a3b2f31eea0c065c1a7"
    sha256 cellar: :any,                 sonoma:        "95b7711d1749f7c70ce98d89fa7eeaa33a41e881e3df5fbdc88a8a9b524ac8d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35086c2c864d6df42d638540e510326ac21a3207d8b49ff9af560a21e9a208b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b4efbea860984db965a607f25f3fb7c45df1c2cf4bcd0894b8e8bb2dadc9a8c"
  end

  depends_on "cmake" => :build # for `awscrt`
  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "openssl@3" # for `awscrt`
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13" # Pydantic v1 is incompatible with Python 3.14, issue ref: https://github.com/aws/serverless-application-model/issues/3831
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
    url "https://files.pythonhosted.org/packages/0c/af/83c27ea62244bde9be475c016d3667e70d42a6b9ba168a21b478f85e8367/aws_lambda_builders-1.64.0.tar.gz"
    sha256 "56ee91ad18a0811c94f546e1a2fe5e76ca56d77eaaf7c612a12563a5b3d5b813"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/e0/09/f62aa8d076f6ba85080ec6291e61af345e9be0daf8a4094101555e054ec7/aws_sam_translator-1.109.0.tar.gz"
    sha256 "0c5e60223ae8434ce0c6bdb9a491d69ba3ec97e15c0d825d3803f7806382d804"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/f6/05/1697c67ad80be475d5deb8961182d10b4a93d29f1cf9f6fdea169bda88c3/awscrt-0.31.2.tar.gz"
    sha256 "552555de1beff02d72a1f6d384cd49c5a7c283418310eae29d21bcb749c65792"
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
    url "https://files.pythonhosted.org/packages/04/7c/d7a533916d1afc9e17f8594203a85799d42f7c5751464fbdb25ead8db9d2/boto3-1.42.70.tar.gz"
    sha256 "d060b0d83d2832e403671b9a895e73c3b025df8bb5896d89e401b0678705aac4"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/65/8d/a2f47f54455d42071034177ac3c9c0bdfd1b51cab76c854f5619970ac57e/boto3_stubs-1.43.6.tar.gz"
    sha256 "6c8b2e2977b5f85cdac82f1e3590cd7e7e452c92341654cc64c93a63da0f7bec"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c6/95/c37edb602948fad2253ffd1bb3dba5b938645bd1845ee4160350136a0f41/botocore-1.42.97.tar.gz"
    sha256 "5c0bb00e32d16ff6d278cc8c9e10dc3672d9c1d569031635ac3c908a60de8310"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/0c/a8/a26608ff39e3a5866c6c79eda10133490205cbddd45074190becece3ff2a/botocore_stubs-1.42.41.tar.gz"
    sha256 "dbeac2f744df6b814ce83ec3f3777b299a015cbea57a2efc41c33b8c38265825"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/0a/fd/81468395bd6bbf3483b64045a247d094cb305fd849a0b044dc3a744baf76/cfn_lint-1.48.1.tar.gz"
    sha256 "1855dce6b97528ff532e3f5a3aa5b659f40e51c338192a0ba82c1af88882b6f7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
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
    url "https://files.pythonhosted.org/packages/46/2d/a0ccdb78788064fa0dc901b8524e50615c42be1d78b78d646d0b28d09180/dateparser-1.4.0.tar.gz"
    sha256 "97a21840d5ecdf7630c584f673338a5afac5dfe84f647baf4d7e8df98f9354a4"
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
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
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
    url "https://files.pythonhosted.org/packages/bc/62/31c099df8c79b2c78a1f48a883049ae5a22a0bf5cf8a22bd332497a3ce1f/mypy_boto3_cloudformation-1.43.0.tar.gz"
    sha256 "5be845bc3dc1b9cdbd8b6b071fad7c42d0221d4087ac0cc7c5b9dd219b324606"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/e5/0a/e79b04e72dfafae0687a8f9da7ab85b27d4a6226b0b2679af5c355b40fa1/mypy_boto3_ecr-1.43.0.tar.gz"
    sha256 "b6c40141060d0b7a8c596ee3c1b473eab5487e1d51ff92a1ff11eaf58e737fab"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/8c/51/ac4c987c0e25c1a27430649dcde68b4775e68505cb71987b8d79c5c31ab4/mypy_boto3_iam-1.43.2.tar.gz"
    sha256 "bb0325ab5e61c5a4627759ffe9fa6fbf4d227146f0b4858555f7a0289622f50a"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/3c/4f/49136b4e3e158494f73b47e89326d3f1b8a628fcb9c4591abbc862e5ac6f/mypy_boto3_kinesis-1.43.0.tar.gz"
    sha256 "5511a9c67a110e1d7b4af7c7834987c2509284cc0aae4c2a3c7b572681652575"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/f8/d9/de2ca1f584ca9522ba94a7b3fd76ecde609d6a67ce3c598d2da705c1067f/mypy_boto3_lambda-1.43.0.tar.gz"
    sha256 "a58de26b5c13be54deab31723ee9ab7aaa922be1dfbd093dc3a4ca12cc853157"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/c8/f9/f6bb5e1b3d8d9087ab9e2142df640a1be853e371ec5e16ea519a60061b56/mypy_boto3_s3-1.43.5.tar.gz"
    sha256 "ba67dbc3da825b6818839db3823722f3b12304dd116e94ed398eb7ade86b0f62"
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
    url "https://files.pythonhosted.org/packages/6d/99/cc9a3fce8102f88c6d49bb020980debc202728f1400a1eec3c8c695c99dc/mypy_boto3_stepfunctions-1.43.0.tar.gz"
    sha256 "bab7b51564350d73a0f1b98ec02cd3a8a9b931c8b42fe8e6fd770fb027bf8d81"
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
    url "https://files.pythonhosted.org/packages/8e/11/a62e1d33b373da2b2c2cd9eb508147871c80f12b1cacde3c5d314922afdd/pyopenssl-26.0.0.tar.gz"
    sha256 "f293934e52936f2e3413b89c6ce36df66a0b34ae1ea3a053b8c5020ff2f513fc"
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
    url "https://files.pythonhosted.org/packages/ff/46/dd499ec9038423421951e4fad73051febaa13d2df82b4064f87af8b8c0c3/pytz-2026.2.tar.gz"
    sha256 "0e60b47b29f21574376f218fe21abc009894a2321ea16c6754f3cad6eb7cdd6a"
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
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e9/67/cae617f1351490c25a4b8ac3b8b63a4dda609295d8222bad12242dfdc629/rich-14.3.4.tar.gz"
    sha256 "817e02727f2b25b40ef56f5aa2217f400c8489f79ca8f46ea2b70dd5e14558a9"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/46/29/af14f4ef3c11a50435308660e2cc68761c9a7742475e0585cd4396b91777/s3transfer-0.16.1.tar.gz"
    sha256 "8e424355754b9ccb32467bdc568edf55be82692ef2002d934b1311dbb3b9e524"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
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
    url "https://files.pythonhosted.org/packages/c3/af/14b24e41977adb296d6bd1fb59402cf7d60ce364f90c890bd2ec65c43b5a/tomlkit-0.14.0.tar.gz"
    sha256 "cf00efca415dbd57575befb1f6634c4f42d2d87dbba376128adb42c121b87064"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/76/26/0aa563e229c269c528a3b8c709fc671ac2a5c564732fab0852ac6ee006cf/types_awscrt-0.31.3.tar.gz"
    sha256 "09d3eaf00231e0f47e101bd9867e430873bc57040050e2a3bd8305cb4fc30865"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/fe/64/42689150509eb3e6e82b33ee3d89045de1592488842ddf23c56957786d05/types_s3transfer-0.16.0.tar.gz"
    sha256 "b4636472024c5e2b62278c5b759661efeb52a81851cde5f092f24100b1ecb443"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
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

  def python3
    "python3.13"
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"

    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install resources.reject { |r| ["awscrt", "aws-lambda-rie"].include?(r.name) }
    # CPU detection is available in AWS C libraries
    ENV.runtime_cpu_detection
    venv.pip_install resource("awscrt")
    venv.pip_install_and_link buildpath, build_isolation: false

    generate_completions_from_executable(bin/"sam", shell_parameter_format: :click)

    # Rebuild pre-built binaries where source is available
    rapid_dir = venv.root/Language::Python.site_packages(python3)/"samcli/local/rapid"
    resource("aws-lambda-rie").stage do
      { "arm64" => "arm64", "x86_64" => "amd64" }.each do |arch, goarch|
        with_env(CGO_ENABLED: "0", GOOS: "linux", GOARCH: goarch) do
          output = rapid_dir/"aws-lambda-rie-#{arch}"
          rm(output)
          system "go", "build", "-buildvcs=false", *std_go_args(ldflags: "-s -w", output:), "./cmd/aws-lambda-rie"
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
