class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/4b/0d/759f076e047ce33be9ae5aa638a1293f8ae45855d37a78920d95be2bdc5a/aws_sam_cli-1.151.0.tar.gz"
  sha256 "e3ad69a3f576e050b6f4c15d6e8d98a1b27f5e3fda37f1b42c0fcd0ffe99441c"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a8bdca6d9835be3a29e60ce42f18c65e5a5c43a2dc0b60b6d41f258017ebc8b"
    sha256 cellar: :any,                 arm64_sequoia: "f1f865c1938bf5cc7a70ba72109e64149cb90f75b0a09c9ffc3d7fa96a77f55b"
    sha256 cellar: :any,                 arm64_sonoma:  "cc02ddccd53956c877054dd20cb75e9b2bfef310ddf578038193634776083ccf"
    sha256 cellar: :any,                 sonoma:        "85957c62133d5075771aa1e33c00519aed32f35a152a1dfcbc3e41b4f23a2889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afd443c2572dd2560030a8994049ecef87403ee18fe25d5bf6f9de419863c54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "938cb96db9366f9b0293afa62aa25fbbd5b0e987a624d68b91339fb803642fd4"
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
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/23/48/1d061cb986a9929ce705a87c9a2719c20e42401b375635dd81452c59e65d/aws_lambda_builders-1.61.0.tar.gz"
    sha256 "29bfe6eac3c55677ed383687ab63aa31372576f537e6310b8af953cef6c787f4"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/d3/52/feef23ec9392e2321ab889fa491a1a86d5818d35948bc331cd92dae0087c/aws_sam_translator-1.106.0.tar.gz"
    sha256 "87712ced7eb6835fea2d4e9674ba7268494aa98f5b186ec5ad684245e2707ef7"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/1c/90/f985002a50859ea39841e66bc816c224b623c03f943b34bfe08fee17165c/awscrt-0.29.2.tar.gz"
    sha256 "c78d81b1308d42fda1eb21d27fcf26579137b821043e528550f2cfc6c09ab9ff"
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
    url "https://files.pythonhosted.org/packages/28/b2/08e0d2e0ee0a189762e9c803a7980c835d94a8c395660cc115a4a6833f49/boto3-1.42.1.tar.gz"
    sha256 "137fbea593a30afa1b75656ea1f1ff8796be608a8c77f1b606c4473289679898"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/0c/e2/3095e2a8e02ec1f399f5ff306bc5345a0ed4fcb04ea60605223952733599/boto3_stubs-1.42.24.tar.gz"
    sha256 "7a1c44936b2cd64afb9e2626ad26406565e01f162f88b7a890e5a3ffae42d0e9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/12/d7/bb4a4e839b238ffb67b002d7326b328ebe5eb23ed5180f2ca10399a802de/botocore-1.42.24.tar.gz"
    sha256 "be8d1bea64fb91eea08254a1e5fea057e4428d08e61f4e11083a02cafc1f8cc6"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/86/61/5715ec25b3dcb2a08133811f6a18a9ca9be54567452ab3e92cadcaec746e/botocore_stubs-1.42.24.tar.gz"
    sha256 "f5fbe240267b27036b1217a304de34bf2bf993087e049a300d17d6f52d77988b"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/02/b4/b4ba37398d56451e171219f9ffa4dcb5954d93f86d138781b1012be86aba/cfn_lint-1.43.2.tar.gz"
    sha256 "c27a2e0b2665925af03e5140236dcd0c117233e224a6d2209bf0930c88fc0271"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/09/22/5985181f53064eca145db58a9f8282dd28f91c0bba967a8d380e7a5bd576/mypy_boto3_apigateway-1.42.3.tar.gz"
    sha256 "25518ac7e542a04e04bd4af1b2616c757c2eea06a9aef6beab5c6bb129791030"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/4c/6a/5a56081f693680fae9a0cf5d04358a9c69b7c06fc36605192acfcc70da75/mypy_boto3_cloudformation-1.42.3.tar.gz"
    sha256 "3bd3849bc89a371d4c368691535b320244ba00579cddd63bb58b73f28d70e510"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/91/9f/98b5694886e03debe9246da75cd3543387b9ea62a1b305a096034207fc24/mypy_boto3_ecr-1.42.13.tar.gz"
    sha256 "c551e0b4041702fdd3d519c1024e3b1661f5dfcc2f6a076f4b1520c143b4b3f0"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/3e/e9/60bf8a3179aaf415cb436bf9b4a909bc02bf129f8ba22acfdc131c52da82/mypy_boto3_iam-1.42.4.tar.gz"
    sha256 "41b17d55f44d31ca5ef0389579505e65f6e79fae0423b98ff2581e83f6284bc5"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/de/fb/f3be674cc0da9e523ef31c43a2da38fe547823483d35edfe8ef89fd4962b/mypy_boto3_kinesis-1.42.3.tar.gz"
    sha256 "31e01b74aa9c312e73f2c3238ca7e7c34d0363b51d68431fea9575b73650525a"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/85/b1/d80eed0b9ec23f6995610e215928e62db130bde9a3b4bba336714b1eae83/mypy_boto3_lambda-1.42.8.tar.gz"
    sha256 "55deadbfaf0e5f118237831a84d35f48dc7164ce2bf7efdcb54f54aef4025602"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/a0/32/aa7208348dc8db8bd4ea357e5e6e1e8bcba44419033d03456c3b767a6c98/mypy_boto3_s3-1.42.21.tar.gz"
    sha256 "cab71c918aac7d98c4d742544c722e37d8e7178acb8bc88a0aead7b1035026d2"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/34/68/1cf8b6e15590ed9d17b9b2156595a903e1da67527049d1c6fe2e9b917e80/mypy_boto3_schemas-1.42.3.tar.gz"
    sha256 "8aeeb96d4097e74c785512d258d5f0be913680e8ce8722719af856b4762fad22"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/f7/58/ccae71b7b7f550eab01d600e956d57e6e6bb9148dbf5d116696d0dc43369/mypy_boto3_secretsmanager-1.42.8.tar.gz"
    sha256 "5ab42f35ce932765ebb1684146f478a87cc4b83bef950fd1aa0e268b88d59c81"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/35/3a/a6f944e27e5b2d43e69b52fde038d78d1fe2f48b20fca06fc780c748574e/mypy_boto3_signer-1.42.7.tar.gz"
    sha256 "7c25f0193d4b2dfa0fdcda30175ffc3bfbd0ea31c0636ff08a467b6643209f5a"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/e8/e4/e326b1072218996c5cb4c3969eb4bbf1fb67a89937974febdebe7bf9d98a/mypy_boto3_sqs-1.42.3.tar.gz"
    sha256 "699995b9a6f69a97c6d3e9126a76f06751e3b405640174fe7c20fe71d9ddc82a"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/c5/71/ae530f15c4e4c4ef530e1ebaf6729aee2374e72ee8b425fb262884007157/mypy_boto3_stepfunctions-1.42.3.tar.gz"
    sha256 "bf38f9db42e144e86c7807dff127554defe1548a10ba25824f69cc74554fa5b5"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/a9/29/0f4ee5ba4a9ad16c08a3b977d40456d7f4f5615f993346723b2f47737ac4/mypy_boto3_sts-1.42.3.tar.gz"
    sha256 "3857c5ba3f3a5c0417edc47f5ad4e45891e3babc32d56c6b27c5d4167f9f5ba7"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/d1/de/b449143d253c69236bf794ee45b6997fbb655504b3dbf510973d9dca2564/mypy_boto3_xray-1.42.3.tar.gz"
    sha256 "8092c41967eed2d0fee096a22b082bb107cfe2bb467a8dd7fbdc392593f1969c"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
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
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3a/2b/7a1f1ebcd6b3f14febdc003e658778d81e76b40df2267904ee6b13f0c5c6/ruamel_yaml-0.18.17.tar.gz"
    sha256 "9091cd6e2d93a3a4b157ddb8fabf348c3de7f1fb1381346d985b6b247dcd8d3c"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/ea/97/60fda20e2fb54b83a61ae14648b0817c8f5d84a3821e40bfbdae1437026a/ruamel_yaml_clib-0.2.15.tar.gz"
    sha256 "46e4cc8c43ef6a94885f72512094e482114a8a706d3c555a34ed4b0d20200600"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
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
    url "https://files.pythonhosted.org/packages/30/1f/febd2df22e24f77b759db0dd9ecdd7f07f055e6a4dbbb699c5eb34b617ef/types_awscrt-0.30.0.tar.gz"
    sha256 "362fd8f5eaebcfcd922cb9fd8274fb375df550319f78031ee3779eac0b9ecc79"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/fe/64/42689150509eb3e6e82b33ee3d89045de1592488842ddf23c56957786d05/types_s3transfer-0.16.0.tar.gz"
    sha256 "b4636472024c5e2b62278c5b759661efeb52a81851cde5f092f24100b1ecb443"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/4f/38/764baaa25eb5e35c9a043d4c4588f9836edfe52a708950f4b6d5f714fd42/watchdog-4.0.2.tar.gz"
    sha256 "b4dfbb6c49221be4535623ea4474a4d6ee0a9cef4a80b20c28db4d858b64e270"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/5a/70/1469ef1d3542ae7c2c7b72bd5e3a4e6ee69d7978fa8a3af05a38eca5becf/werkzeug-3.1.5.tar.gz"
    sha256 "6a548b0e88955dd07ccb25539d7d0cc97417ee9e179677d22c7041c8f078ce67"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  # Manually update following resource
  resource "aws-lambda-rie" do
    url "https://github.com/aws/aws-lambda-runtime-interface-emulator/archive/refs/tags/v1.30.tar.gz"
    sha256 "c5869902fc6d443504feec0cced1098afe87b96052684da49fdb09ae15ab0edc"
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

    # Remove pre-built binaries where source is not available
    rapid_dir = venv.root/Language::Python.site_packages(python3)/"samcli/local/rapid"
    rm([rapid_dir/"aws-durable-execution-emulator-arm64", rapid_dir/"aws-durable-execution-emulator-x86_64"])

    # Rebuild pre-built binaries where source is available
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
