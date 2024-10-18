class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/60/e8/cd70eda57bf3a6932d0ec47f3a2640062ed7809e83e24dcba67ca6ac9dff/aws_sam_cli-1.126.0.tar.gz"
  sha256 "fc01ddca64356bef3eac5ef39d260144e24e10f68e0393edf5c18e4013c3817f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a8b3f9f2129c0bb51470e8ab6c3fd59bf66f84bedda4a973e4dd55dd241cc5e"
    sha256 cellar: :any,                 arm64_sonoma:  "c8e86f45d6003b852feff330d349df3bb731804e7f759ca42f73d82062b6c87e"
    sha256 cellar: :any,                 arm64_ventura: "b7a58a968f4a9a3c35755ffc4377ad695d6b35d3706bea89fb226add2fc33051"
    sha256 cellar: :any,                 sonoma:        "bce3c7d5bf5d91de297375e669abfa87f3a1aaa4a8c3bafa0a4fd820064f1b96"
    sha256 cellar: :any,                 ventura:       "7913be28adefdf68541def2d0a59c94c43622460c5ee52eb238262216cbeb093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "545ea1336a658c19cb7d5f199d3163e45728f202fded56f7dd5c934686e3345e"
  end

  depends_on "pkg-config" => :build
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
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/16/42/0f6696919255886126d02d0d4ae7c5be75b84679ae9fa9bc9fb59f3d3223/aws_lambda_builders-1.50.0.tar.gz"
    sha256 "ad95ed55359c399872f5825582896500dfc1c5564eccf2a6ab8d0e9f6c1ae385"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/1c/41/fbd5be5d25c6bdceb92ecb5232a794eb7a3a9cfdf111f28b27cb3c19fb77/aws_sam_translator-1.91.0.tar.gz"
    sha256 "0cdfbc598f384c430c3ec064f6008d80c5a0d58f1dc45ca4e331ae5c43cb4697"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1e/57/a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abcc/blinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d2/70/71e0ab52835e63b63a93775b2c8734e4188454b9165e5dee7e55b722bc69/boto3-1.35.43.tar.gz"
    sha256 "0197f460632804577aa78b2f6daf7b823bffa9d4d67a5cebb179efff0fe9631b"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/78/37/7d9758dd725ba26bd4fd3f93a3888ad6dc787830ca161d1bc984ce87f6f6/boto3_stubs-1.35.32.tar.gz"
    sha256 "1445abffb9238824cde8227e04b93b423b824173c62f2aa3d4d54c8feb7acff0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1f/e2/a65953af6effec4248f8e29b0b5567cfabae686691b8301650b8ac28bfc6/botocore-1.35.43.tar.gz"
    sha256 "04539b85ade060601a3023cacb538fc17aad8c059a5a2e18fe4bc5d0d91fbd72"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/e5/b5/d8e2906b837d0a9bb729474709010c825ad9f31232eac9d70cb62962121e/botocore_stubs-1.35.43.tar.gz"
    sha256 "f72326ddc0d79baea615d26cbe87d07a6496469bd9d704a9cab8e7a79e6b0b22"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/cf/e8/95fd33c9a28fc93da3ab6d42e4596e1bac4381aa86b7dc86db37d74920f3/cfn_lint-1.16.1.tar.gz"
    sha256 "e7b6a2fbb39368974044e7ecd109bed56224cf11b9bd92ebeb5e8ae5d5754725"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/52/17/9f2cd228eb949a91915acd38d3eecdc9d8893dde353b603f0db7e9f6be55/cookiecutter-2.6.0.tar.gz"
    sha256 "db21f8169ea4f4fdc2408d48ca44859349de2647fbe494a9d6c3edfc0542c21c"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
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
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
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
    url "https://files.pythonhosted.org/packages/e9/f1/cca9621b8401ef2475e8c54435da682fb47ccbde4db206b7dab8db6b4c64/mypy_boto3_apigateway-1.35.25.tar.gz"
    sha256 "ea3b419ae868d63f0613eeacc6a75861fd57b689d6a14bb7562eed303913a5ae"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/d2/61/7103e2a9b96d10b44784b310746a1e160e74007e185b3ae592a3e262d629/mypy_boto3_cloudformation-1.35.41.tar.gz"
    sha256 "125698530718b36fd9e42a13cdc964028304440d80927adf2e1dfcf5e376839e"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/69/1a/d2f342de76a55a3dd459293933a2e7cc7a0ef5a4701bb81ab969f4d9074c/mypy_boto3_ecr-1.35.21.tar.gz"
    sha256 "d7e8c24086ce3b259e4ac2a271fc34ed4effde99c7899ac7d64c2da3cff0acd7"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/a6/8c/f9ee94e176c5b5fa44e441fef1f6e53b97ed1fd8227c43e41931a05ecef8/mypy_boto3_iam-1.35.0.tar.gz"
    sha256 "b379a01c3ca17a367cb7a460905f9ce1ab7830a9abb8c8a56f28a5ff1087657f"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/78/10/ab59c97753f624748095bb8545000752eec98c0805559b2514230675e181/mypy_boto3_kinesis-1.35.26.tar.gz"
    sha256 "865f2697f62dfc7d04052436a925bdf0d39a9317cde8c6981a6ac46e659c1c7f"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/a7/05/222b412c3f2cefd3c70672d5cae28cd9ab3c6965d94f51acfccb7893ba3e/mypy_boto3_lambda-1.35.28.tar.gz"
    sha256 "8473d71ee83aca8009d317e57cd2094a355ec90c7c536cf26e52db71b2f7528b"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/92/8a/f91790871d9a0ef1443ff2dd5da0da77eefc36edec76a50814b9d4b00349/mypy_boto3_s3-1.35.42.tar.gz"
    sha256 "2d040c05d68a161d91c4b72926127034da28ade98d480def6a9569ab7655cddd"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/d0/1d/c5a067eb7847fa88c9d18f4a38ce5369cef6782ee0a1f7e97371ae960c5d/mypy_boto3_schemas-1.35.0.tar.gz"
    sha256 "a63cbf1c5189e29638b7f1522357db080bfd99e142110a06df6192b5d68f0dc8"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/60/c4/66fe1c912c6ebf23c17d3003b77ef47c49250d879deb3ef5a902f94a7dac/mypy_boto3_secretsmanager-1.35.0.tar.gz"
    sha256 "c37d181315ba10d8546872304d7f266e7461429b08e63507c23cc508c3ef4264"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/c2/88/cbdb23d4351eedd9cd7ad6848f779ab547489524347a6b7109d509a853bf/mypy_boto3_signer-1.35.0.tar.gz"
    sha256 "06653bbc2b92f0ec390d2622e2a6cbad8a191ac758c21e0803d1151cd18c8232"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/ee/e5/e8228deac8720ddd152c8ff8f55fa5ef27f1c256835dd98063cd754570c7/mypy_boto3_sqs-1.35.0.tar.gz"
    sha256 "61752f1c2bf2efa3815f64d43c25b4a39dbdbd9e472ae48aa18d7c6d2a7a6eb8"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/5a/64/0abe503296cb18a4426e4f10809092a8c9c3af71b772b38bab70d3662735/mypy_boto3_stepfunctions-1.35.9.tar.gz"
    sha256 "c088ab67751e837c5db40593d6cbb70505c8e56e0e04fb32a0241e79bb22812b"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/d1/99/230a0a4a2b289225ea6c3e3c1b12a71787fb14608642f7923485d40cf4ab/mypy_boto3_sts-1.35.0.tar.gz"
    sha256 "619580c0bcf4d7f79808c8328a7894a0eeac56f94541833c5a329cbc708f7678"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/10/4f/2544df521fdff2a36f6c8c76cedce1e279e5d2de48c5af0c8f4c97602d2d/mypy_boto3_xray-1.35.0.tar.gz"
    sha256 "a3c3a6d83f659f6dc4dbf392ac1481029af6b941e9485ea4878bbf60e338f82c"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/36/2b/20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869/networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/a9/b7/d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30/pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e2/aa/6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3/pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
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
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/aa/9e/1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95/rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/07/37/b31be7e4b9f13b59cde9dcaeff112d401d49e0dc5b37ed4a9fc8fb12f409/setuptools-75.2.0.tar.gz"
    sha256 "753bb6ebf1f465a1912e19ed1d41f403a79173a9acf66a42e7e6aec45c3c16ec"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/11/8a/5a7fd6284fa8caac23a26c9ddf9c30485a48169344b4bd3b0f02fef1890f/sympy-1.13.3.tar.gz"
    sha256 "b27fd2c6530e0ab39e275fc9b683895367e51d5da91baa8d3d64db2565fec4d9"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/82/52/6f0018663d3528501e1c29cda936d67921dac66325ffe473d4376bdcf4cb/types_awscrt-0.22.0.tar.gz"
    sha256 "67a660c90bad360c339f6a79310cc17094d12472042c7ca5a41450aaf5fc9a54"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/31/f8/f6ee4c803a7beccffee21bb29a71573b39f7037c224843eff53e5308c16e/types-python-dateutil-2.9.0.20241003.tar.gz"
    sha256 "58cb85449b2a56d6684e41aeefb4c4280631246a0da1a719bdbe6f3fb0317446"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/41/60/3e58d63d1aea14a1c86eb89d717b1e2a3fcf1cc6bd1ae9dd21ab0ba14e8d/types_s3transfer-0.10.3.tar.gz"
    sha256 "f761b2876ac4c208e6c6b75cdf5f6939009768be9950c545b11b0225e7703ee7"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/a2/48/a86139aaeab2db0a2482676f64798d8ac4d2dbb457523f50ab37bf02ce2c/watchdog-5.0.3.tar.gz"
    sha256 "108f42a7f0345042a854d4d0ad0834b741d421330d5f575b81cb27b883500176"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0f/e2/6dbcaab07560909ff8f654d3a2e5a60552d937c909455211b1b36d7101dc/werkzeug-3.0.4.tar.gz"
    sha256 "34f2371506b250df4d4f84bfe7b0921e4762525762bbd936614909fe25cd7306"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b7/a0/95e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813/wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
