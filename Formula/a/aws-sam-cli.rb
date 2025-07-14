class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/c4/64/2e52d16f77ea347454e9ea8bd0f4c941c8b78b1a517846fd9bff2ea29b95/aws_sam_cli-1.142.1.tar.gz"
  sha256 "ba6896e7427fa73ed51dbac96e4b80ca18a2f413e77f514bdc5c55d4749d3d74"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "9e6a1ee07cd9b412b987a794815d93f3ed093a5ff4de11e397046498153121d0"
    sha256 cellar: :any,                 arm64_sonoma:  "b0c7082adbab7feb697169d565cd3943166a06dece0fe335af05a0c5821c1d29"
    sha256 cellar: :any,                 arm64_ventura: "e5ab73ed9faa321729540550854fed350928196d56928473ce718e8eae871a30"
    sha256 cellar: :any,                 sonoma:        "edf40666ac2a96c45f4b68e2024ae4fc8f32c6649dcc37629766a80a44f43957"
    sha256 cellar: :any,                 ventura:       "24e8752158da654abbeabf36ef4d9836cd9f668747efe2e442ead8e15ca29769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44891b6cb8cd881358648f537429206cbb1d87b8b9b553f2ea7012134f0fb949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcbb710507d3298eb95b2e4f76b6491d0fc04cb062ef97a56d7aa7525b156792"
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
    url "https://files.pythonhosted.org/packages/a7/7c/67f11af10a96e71e2a131be879a5e2e1385793627d242be11a8fea4c81c5/aws_lambda_builders-1.55.0.tar.gz"
    sha256 "4749446c5e54a75f5af7e835236f6c7ec6a0e51abcbc1e5cdbf7282529b56be2"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/ef/78/ac6761ff3f37a1e989ddb62c9a58c4d289ad2ca2bdb3bed1319f4ae49e16/aws_sam_translator-1.99.0.tar.gz"
    sha256 "be326054a7ee2f535fcd914db85e5d50bdf4054313c14888af69b6de3187cdf8"
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
    url "https://files.pythonhosted.org/packages/3f/c5/fae785c42e5f81eb1e1a7c3e7ffb34b14df6a1ac7b08355da526ec733392/boto3-1.39.1.tar.gz"
    sha256 "3f89d6f05ab7d3a6f6807b45e9456a1a0db53bb47b1758cf5e0a3479cdd6d734"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/0e/c6/b042b91c40e6e70760d6b63fe391e198bd939b7630e1c5b809b635a601ae/boto3_stubs-1.38.46.tar.gz"
    sha256 "526789fc1f4a6f89f372424dc9a4109296f6bd18afab1abf5d281a94f5cfb770"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b3/b6/65cce081cca1c7271a05f6464b485c95b3e42701e2a9fc4a820aa468c8f2/botocore-1.39.1.tar.gz"
    sha256 "ac829b46b30bd837392c9792cdf63b44d290a4691c028b5e66ab471ced1b8305"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/05/45/27cabc7c3022dcb12de5098cc646b374065f5e72fae13600ff1756f365ee/botocore_stubs-1.38.46.tar.gz"
    sha256 "a04e69766ab8bae338911c1897492f88d05cd489cd75f06e6eb4f135f9da8c7b"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/3a/72/3c792b1814226ebfb8944d8df707979a43f3e5ee2f3f8093ee17d7692656/cfn_lint-1.36.1.tar.gz"
    sha256 "ccb85398fb1d8d8d87edafe207ab6a133c4ab9aefd3ff93591b6ad8c3ccab291"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
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
    url "https://files.pythonhosted.org/packages/c0/de/e47735752347f4128bcf354e0da07ef311a78244eba9e3dc1d4a5ab21a98/flask-3.1.1.tar.gz"
    sha256 "284c7b8f2f58cb737f0cf1c30fd7eaf0ccfcde196099d24ecede3fc2005aa59e"
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
    url "https://files.pythonhosted.org/packages/bf/d3/1cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177/jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
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
    url "https://files.pythonhosted.org/packages/2e/fa/d5d9d490d062f1b933d2b8c22f0bf61200796cb951d5bddf24515d848439/mypy_boto3_apigateway-1.38.36.tar.gz"
    sha256 "decaf1b47e8e4b27aeac3c2c09cde74219fe94f2ef6912f78e272882c095a23c"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/f8/ed/f533f07def9140c429a047f8b70c8a4ea9cf04597b09d264edeca3a4265a/mypy_boto3_cloudformation-1.38.31.tar.gz"
    sha256 "f4185231faab97bfb50b25dc1323333c630a092ffa8c15356f21116fc92a7f42"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/29/d5/0e46fd78c4d75018ee0720582227603746d0329daa130907c518990494f1/mypy_boto3_ecr-1.38.37.tar.gz"
    sha256 "fed095a297b35c954eb80df0d4ee631c8241f5b0dafd8d5ef799cf4e8487814a"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/7f/e6/b0cf2d54102939776976b40deed032acc7f57299ceac02edcc0411893419/mypy_boto3_iam-1.38.14.tar.gz"
    sha256 "4692200074bf917da7c9237b2c50bbb9718931c9f99b73e579ecdd100b6582a3"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/8a/33/ed686441c535fb43bccd3b63fee86b2538bbf0ec14d4aeb145ac24267db5/mypy_boto3_kinesis-1.38.8.tar.gz"
    sha256 "3932c77f3fc8c375454f3dfa71e1e2f18545d95c854dab57dc9c3ba6b561d928"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/7a/0d/a42b8282e8c64f3e45b0437e2e19200608aeb1a82f83d74d6ba50181fb79/mypy_boto3_lambda-1.38.40.tar.gz"
    sha256 "145c9f7de2da29fb651b21515c9052697f7579c821ee3ab7bcbf7ef4993dcd25"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/43/48/cbef3d4518010c9053a447e5cbbfdb364870ca18ce3c8596c232226260da/mypy_boto3_s3-1.38.44.tar.gz"
    sha256 "eacf15c9164e56ecb86a76152adb414cf8f7f22b46cd80a843f6b7ef41a1cd8f"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/59/6b/34c24abeecaeec8e69513486b60715266e3c67b99ea4ea94d5a1e7507e13/mypy_boto3_schemas-1.38.0.tar.gz"
    sha256 "e4f9f7ffb5d7e44c5642bcb8e68734d6dbc7dc01bde707f02aed0b2348bc0c22"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/9e/fe/0302a42d4fab765215f517f9c98e6ac2b226ee0387e85816d9dda8aa93a0/mypy_boto3_secretsmanager-1.38.0.tar.gz"
    sha256 "1666108e70f03e4dc1de449388d7facb77aba231a026bac0c3240fc27fd31a98"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/2c/4a/f38981d5dfeb0a998c4d6e363e567257bb805b2aed647e9123f111b9f2f2/mypy_boto3_signer-1.38.0.tar.gz"
    sha256 "68875fc90ded54ddc6f97aaa17c7c51d1241a459cad84d135322de597ff9f90b"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/f0/a0/ef5c7bdb33af5d0a48029fed11401388fa68949c6c0f9b11b2e845f5fe0e/mypy_boto3_sqs-1.38.0.tar.gz"
    sha256 "39aebc121a2fe20f962fd83b617fd916003605d6f6851fdf195337a0aa428fe1"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/d5/b6/1273339e46c41747fbf7f3097ca866c9d10e3db77d49630ac131abce1614/mypy_boto3_stepfunctions-1.38.0.tar.gz"
    sha256 "b0102265c49fa0537bdb5d214677da89737b784f57ec02340d72210528088a99"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/24/e5/a497cc0d322a04883d13e71cb2a0974fb87c4f0dac2ef474f6dd95705445/mypy_boto3_sts-1.38.38.tar.gz"
    sha256 "7081cb6b32ae5ad4edb65ff9cecb5b625166747dbc7f47ee4f6b744441a643a2"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/d6/f5/9121dae480352d0c0efd8094115527e8292e351005630407f5e2f2ccb719/mypy_boto3_xray-1.38.0.tar.gz"
    sha256 "13dadd42be39f0b3e139d3d3a0021c24e617d67eb8b0d09dac3d7d7795b30384"
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
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/a5/aa/4456d84bbb54adc6a916fb10c9b374f78ac840337644e4a5eda229c81275/rpds_py-0.26.0.tar.gz"
    sha256 "20dae58a859b0906f0685642e591056f1e787f3a8b39c8e8749a45dc7d26bdb0"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/87/6da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547/ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ed/5d/9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191a/s3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
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
    url "https://files.pythonhosted.org/packages/94/95/02564024f8668feab6733a2c491005b5281b048b3d0573510622cbcd9fd4/types_awscrt-0.27.4.tar.gz"
    sha256 "c019ba91a097e8a31d6948f6176ede1312963f41cdcacf82482ac877cbbcf390"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/ef/88/d65ed807393285204ab6e2801e5d11fbbea811adcaa979a2ed3b67a5ef41/types_python_dateutil-2.9.0.20250516.tar.gz"
    sha256 "13e80d6c9c47df23ad773d54b2826bd52dbbb41be87c3f339381c1700ad21ee5"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/42/c1/45038f259d6741c252801044e184fec4dbaeff939a58f6160d7c32bf4975/types_s3transfer-0.13.0.tar.gz"
    sha256 "203dadcb9865c2f68fb44bc0440e1dc05b79197ba4a641c0976c26c9af75ef52"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
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

    generate_completions_from_executable(bin/"sam", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
