class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/6d/85/000b8a0851de8a24998b75048540d27bfe187b8f405f229e3fa998b16fc1/aws_sam_cli-1.144.0.tar.gz"
  sha256 "1c87a7bcbfdf937fce13a74dc0931744f12b97a43c3c0915845f531199b33aca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "088418e8ed358bc47bd5c86625df75718bcd9b06b3ccaca637abb6ad9ee4ed44"
    sha256 cellar: :any,                 arm64_sequoia: "bd24749c91e1f4496554fe06a861d4b02f78972145a81330bb467e695fcb9f17"
    sha256 cellar: :any,                 arm64_sonoma:  "4246a4307f87e1bb8fad0802d861056c3f219bd7e151e60790a1d62e2eb3edc5"
    sha256 cellar: :any,                 arm64_ventura: "c8970c97b97bccf5fa0344d89950865213b198dfdc4d240fa039501d01a054e4"
    sha256 cellar: :any,                 sonoma:        "4afe05aa7dc3ce5761994ed5a76ef448cb3c547194f0d9e432e9184953c41655"
    sha256 cellar: :any,                 ventura:       "4648b359d3181087182515c45529c749b2a9a95955b40ffee12b6b136ae83265"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56277eb1aa0cca89edb57b08225f5f559322c9273176c4eedeba7d030576cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "873071adb29aa41c54f9ae51d971c27536e68d096dd527b629170578b6abe887"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/b7/77/32ad8ba660029b8e78a38e1e034ad4c32e408517b7329bafdb9d6f9c7a05/aws_lambda_builders-1.58.0.tar.gz"
    sha256 "95bf2a502bd9cf5abc14b1a27e9d0c7378cf261abb52373ea16be7ca22b7e812"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/0b/63/2f0ef6d6612a16e8eb293d4724d9cdd07b713677d66999dfc93e084ebc87/aws_sam_translator-1.100.0.tar.gz"
    sha256 "be4fb7eef864c971eb305af09de8e4e0bfe98a4eca122a00c069f6346aa00410"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4a/0c/4c4545430e0a0519cb2b17f6a798097673ae265fa3c910b912726cea5cfb/boto3-1.40.28.tar.gz"
    sha256 "dd44710ab908b0b38cf127053cac83608a15358c85fa267a498e3dbac6fd5789"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/47/a0/4efb14b0966b480381ea9dc69e285aa43265c26601d5d367f9142ca4fc38/boto3_stubs-1.40.26.tar.gz"
    sha256 "f9f7538881edd07ebfab1bd7890af2bd0b829ebb16d931860845d448e4505a2d"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/10/b2/fe454104d7321c2e08b8eefa87cbd8c25128f6ba064595d69b2fc61dd29c/botocore-1.40.28.tar.gz"
    sha256 "4a26c662dcce2e675209c23cd3a569e137a59fdc9692b8bb9dabed522cbe2d8c"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/b1/ea/8033cc9399217564d22f8dd80a03e190c64bd4f4f7544b961f4a8db665a9/botocore_stubs-1.40.28.tar.gz"
    sha256 "6866d06beb78a1e9313c8297db4c68afa5174586a511581a1fcf7d24b82fe547"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/1f/a6/f61ded3fe3c6551e3cf1d310e3255e3546807e55ca637168461932dfe625/cfn_lint-1.39.1.tar.gz"
    sha256 "ddad90025c72d7e31bb2d449e2444e5cfd3fe6d2bb30caa69f865aa17e60279f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/52/17/9f2cd228eb949a91915acd38d3eecdc9d8893dde353b603f0db7e9f6be55/cookiecutter-2.6.0.tar.gz"
    sha256 "db21f8169ea4f4fdc2408d48ca44859349de2647fbe494a9d6c3edfc0542c21c"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/a9/30/064144f0df1749e7bb5faaa7f52b007d7c2d08ec08fed8411aba87207f68/dateparser-1.2.2.tar.gz"
    sha256 "986316f17cb8cdc23ea8ce563027c5ef12fc725b6fb1d137c14ca08777c5ecf7"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
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
    url "https://files.pythonhosted.org/packages/2b/4c/c8de2ecbafde4de3ec8fc935726fe672c11f563d37bf70d8e68df8502be6/mypy_boto3_apigateway-1.40.0.tar.gz"
    sha256 "99f3134375d25470e34e340463f10bd71ab8b7429168fc06d8dbb43f0b1b937a"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/07/da/a99189fa5aa30c56d7164f26a2ce34a381719003ca0c86a882a1c9d1bb81/mypy_boto3_cloudformation-1.40.24.tar.gz"
    sha256 "e2b00afc6aab1311b258c93148eeea5b3eead94c7203e28ff9fd38e9fce28488"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/61/10/076d964b9aa733ddf2e1a60e0ebd1b46afe2d9ce56eea29ee7e60f0eaabf/mypy_boto3_ecr-1.40.0.tar.gz"
    sha256 "7733e42bc8a92ffd93bebf0343af133fd52698ffebd323d82ffde755ce28687f"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/69/7c/fdec1447883fb90470b7cb1917a32923583e7bcfa4b592e8f9f5871cd1a7/mypy_boto3_iam-1.40.0.tar.gz"
    sha256 "b900ac557375428f0bbc37aa24fdd2901e2db7018ae44e0aaf99ec0f84a28d44"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/75/ea/b1ccfd706bc5ccccf4a88e324c2426b7fd9dabd7cf4ed07206840572713b/mypy_boto3_kinesis-1.40.0.tar.gz"
    sha256 "4f74f715e23a8dce062b40f6a4f2ff1023cec6f41b4521f0bc15679883a7e68e"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/25/4f/63def7a5be630e8d39186594b01fee86f2e6dcbca3e0b0e80a3ea90bc4ae/mypy_boto3_lambda-1.40.7.tar.gz"
    sha256 "e8bedf03a67fade5db861fe902df063064292352eed5f785f74cd0e591948db9"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/00/b8/55d21ed9ca479df66d9892212ba7d7977850ef17aa80a83e3f11f31190fd/mypy_boto3_s3-1.40.26.tar.gz"
    sha256 "8d2bfd1052894d0e84c9fb9358d838ba0eed0265076c7dd7f45622c770275c99"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/3f/7d/e722babaac6cc303ab317c6872cb2761d17c7a9b0852722363428a9ebad3/mypy_boto3_schemas-1.40.19.tar.gz"
    sha256 "70d0066555d9283c5f535c7dd9c04761ad8c9551426854d510db77a5bb18a5c6"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/c5/d4/046dd85e0914a924ec95449d698e1ae15e698ed880e1a95ae8bf8c8d8a1b/mypy_boto3_secretsmanager-1.40.0.tar.gz"
    sha256 "f6509365d5d4fe3260703badcef5a1c45455ed454e5f03f3573a5023cc176644"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/15/ff/468c5922f721534996182c371d2de147a2a0bea1387482cb8ca23588d1d6/mypy_boto3_signer-1.40.18.tar.gz"
    sha256 "d524051ae0c353c32472266d1a390b858d3317220f930be061724ba1810ad682"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/58/37/3bc3a1fd8e9a83e0a2701653312b2dfae302212273d4dddf6db7c3ddc0b6/mypy_boto3_sqs-1.40.17.tar.gz"
    sha256 "04de818a43258795c84a093d41d3191c8d89446e8c43fea774f453b8124a7d56"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/f8/57/34d2d380862cf8c130981edb8d4c185ef4da256b5b0d7a28a29926009b51/mypy_boto3_stepfunctions-1.40.0.tar.gz"
    sha256 "b7ee316136d32e45d1a03cad78109596349bdefd8ffec04b2c4526a509ba53cd"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/39/32/8dce999ed05c797000ce70287f3e82025a98514781c303c7f8fe42f7b327/mypy_boto3_sts-1.40.0.tar.gz"
    sha256 "eb55e50960ae6194d09488464c302196392df712a6a5f4308b6a0e24244cfd5c"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/0f/91/e5148d00d65411f71c4bd1fa6410cf5f60fe0016e2d6a9b214c5cd9589e9/mypy_boto3_xray-1.40.21.tar.gz"
    sha256 "bd880ac900e3f36dd6f45019493ec7de1c4201da9e50cd934526834cb30e6eab"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b2/5a/4c63457fbcaf19d138d72b2e9b39405954f98c0349b31c601bfcb151582c/regex-2025.9.1.tar.gz"
    sha256 "88ac07b38d20b54d79e704e38aa3bd2c0f8027432164226bdee201a1c0c9c9ff"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/56/ce/5d84526a39f44c420ce61b16654193f8437d74b54f21597ea2ac65d89954/types_awscrt-0.27.6.tar.gz"
    sha256 "9d3f1865a93b8b2c32f137514ac88cb048b5bc438739945ba19d972698995bfb"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/0c/0a/775f8551665992204c756be326f3575abba58c4a3a52eef9909ef4536428/types_python_dateutil-2.9.0.20250822.tar.gz"
    sha256 "84c92c34bd8e68b117bff742bc00b692a1e8531262d4507b33afcc9f7716cd53"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/a5/c5/23946fac96c9dd5815ec97afd1c8ad6d22efa76c04a79a4823f2f67692a5/types_s3transfer-0.13.1.tar.gz"
    sha256 "ce488d79fdd7d3b9d39071939121eca814ec65de3aa36bdce1f9189c0a61cc80"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/4f/38/764baaa25eb5e35c9a043d4c4588f9836edfe52a708950f4b6d5f714fd42/watchdog-4.0.2.tar.gz"
    sha256 "b4dfbb6c49221be4535623ea4474a4d6ee0a9cef4a80b20c28db4d858b64e270"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sam", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
