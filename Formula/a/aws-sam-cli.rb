class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/ea/02/3e8fd391929682fc1ff8167708beb37d8e7b4f3b6eb4b28f8365997d03ff/aws_sam_cli-1.132.0.tar.gz"
  sha256 "06cfc590cae87844903b3c96e7cc125683334178a2129c361134d8e17cacd22e"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4463f5c69c73e7bf797a4dacafeb6beba1710e8e207093b22a25efea9a6c7c9c"
    sha256 cellar: :any,                 arm64_sonoma:  "47c839d978a17f290b9f38231ae96ee290993adeeb85f18f60253c4fd56b0ab7"
    sha256 cellar: :any,                 arm64_ventura: "b3f91d04ecb62b1ca1521c473974c2de67255fdea0f4240f7391155d60302b2b"
    sha256 cellar: :any,                 sonoma:        "ef7f1952cdd263636fb0230054393a640d0d70ee73a57f3c2e52699dc65be5cc"
    sha256 cellar: :any,                 ventura:       "6babcb31ae296145cab68fe48e28709019edcc251dae5d7566278242f1002782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "250790c43039b1bd8b877b0280d00c6f0e8b963d3302f44179da40681c5b8dc4"
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
    url "https://files.pythonhosted.org/packages/48/c8/6260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045/attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/0b/0a/09a966ac588a3eb3333348a5e13892889fe9531a491359b35bc5b7b13818/aws_lambda_builders-1.53.0.tar.gz"
    sha256 "d08bfa947fff590f1bedd16c2f4ec7722cbb8869aae80764d99215a41ff284a1"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/ef/2c/69276246bc22293aec595dac217e0ad8299053d05c8ff00a24d1f09395b3/aws_sam_translator-1.94.0.tar.gz"
    sha256 "8ec258d9f7ece72ef91c81f4edb45a2db064c16844b6afac90c575893beaa391"
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
    url "https://files.pythonhosted.org/packages/80/08/cf2a60bcb6d49764379d78e87f29310458257eb413bb7aa85ebe3d8cd0cc/boto3-1.35.87.tar.gz"
    sha256 "341c58602889078a4a25dc4331b832b5b600a33acd73471d2532c6f01b16fbb4"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/8e/cf/b4116eefdc95102271df2a47bef1db7ac88d1c1b938648c4302fe817150c/boto3_stubs-1.35.63.tar.gz"
    sha256 "cc471636d28f595bf750dc3c2079d16e988c9f518a66f50c9d62b0119c3f72cf"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/98/8d/2e49e7a99944cbeef4c1182f59af282fcb164feef35dfa420500c4e0ccb3/botocore-1.35.87.tar.gz"
    sha256 "3062d073ce4170a994099270f469864169dc1a1b8b3d4a21c14ce0ae995e0f89"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/f1/4b/bb9716607d4486f180e953bcf3da9613c9ebafa06ff7a6e8646fd963f1cf/botocore_stubs-1.35.87.tar.gz"
    sha256 "09e2a2c0757fb95a0ca595c724eb5a151f1c4c264b51c43cbdb55853a796c4c4"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/3b/b1/3e9baf9225846cbe94a5a39cc2493ce2fd99d14dd4c1d700fad1b628856e/cfn_lint-1.20.2.tar.gz"
    sha256 "2bc93025bfe1b653c06820db0a20e33d686c68bec5bd3b7cc9178179a5d510f6"
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
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https://files.pythonhosted.org/packages/89/50/dff6380f1c7f84135484e176e0cac8690af72fa90e932ad2a0a60e28c69b/flask-3.1.0.tar.gz"
    sha256 "5f873c5184c897c8d9d1b05df1e3d01b14910ce69607a117bd3277098a5836ac"
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
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
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
    url "https://files.pythonhosted.org/packages/01/11/9c82f90470f30024aec4a3a441e2da7bb8876268c3612182b149b7bbd524/mypy_boto3_apigateway-1.35.67.tar.gz"
    sha256 "7ee4e0957cd367f72e9aee5abdb2f7b5cefdc1da214e19272ef6741d0200299f"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/4f/97/04c21049fb94ea9b5dc52cb5350042b822a5e3f8495e06403e442abc510a/mypy_boto3_cloudformation-1.35.64.tar.gz"
    sha256 "d1a1500df811ac8ebd459640f5b31c14daac784d8a00fc4f67bc6eb391e7b5a8"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/a2/96/4d9d93015f7ed5c845813b98a0ae3956f30ccae55e98759dd8998fcde15d/mypy_boto3_ecr-1.35.87.tar.gz"
    sha256 "5caf50f5fcf4e6c23a5ea3b505f19a66285f4211ecb178027f418938d381ca6f"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/c8/10/dd881ea65e5c160ffda8d7e0f1ab008ff4706d0632cac4bccc9f4c2bdf67/mypy_boto3_iam-1.35.61.tar.gz"
    sha256 "cf307f7fb2404ceda7fda455f6d4cf3bdf57e12a3b16d27101db6223c59e6fe7"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/78/10/ab59c97753f624748095bb8545000752eec98c0805559b2514230675e181/mypy_boto3_kinesis-1.35.26.tar.gz"
    sha256 "865f2697f62dfc7d04052436a925bdf0d39a9317cde8c6981a6ac46e659c1c7f"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/b2/2e/b80f84512a1d62a6d8c6d076ad21449bff06c5c4ec69f21617f66ae1167e/mypy_boto3_lambda-1.35.68.tar.gz"
    sha256 "577a9465ac63ac564efc2755a7e72c28a9d2f496747c1faf242cb13d5017b262"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/41/77/7110b19addec6019f0fe61663c07366e38919c7cc8bb9a4099de0b61be07/mypy_boto3_s3-1.35.81.tar.gz"
    sha256 "fe1a6860c0ca7016e24089819433c0d5835d4a57635bb42628645b71271b946c"
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
    url "https://files.pythonhosted.org/packages/25/e9/319bf47c9940d32b20c50275d9361a1f16d6334d40260ab1f849686dc25f/mypy_boto3_stepfunctions-1.35.68.tar.gz"
    sha256 "4abef0d339463ebe612836f42154a092e95eed025baca9a15be1286cc9a90434"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/18/0a/01f18c7350df047f15dabb47f145f6f0d98e5fe48a088bf506ec4d250276/mypy_boto3_sts-1.35.61.tar.gz"
    sha256 "37465ba1d3202cd39b508c346955f9a5a2597071300791a569cbbc2ad7ab4dd1"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/fc/ac/1d17dae0bf54c390436a971a7cc58e1a7b4fb20dfb2145a2646a5fa2bad0/mypy_boto3_xray-1.35.67.tar.gz"
    sha256 "36a4a1b7782777001083551ccd844496f71b42122fe4c3f95fc0a9d512a7317f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/70/7e/fb60e6fee04d0ef8f15e4e01ff187a196fa976eb0f0ab524af4599e5754c/pydantic-2.10.4.tar.gz"
    sha256 "82f12e9723da6de4fe2ba888b5971157b3be7ad914267dea8f05f82b28254f06"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/fc/01/f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abc/pydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
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
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/01/80/cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfd/rpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/c0/0a/1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069/s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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
    url "https://files.pythonhosted.org/packages/dd/97/c62253e8ed65562c67b2138339444cc77507c8ee01c091e02ead1311e4b8/types_awscrt-0.23.6.tar.gz"
    sha256 "405bce8c281f9e7c6c92a229225cc0bf10d30729a6a601123213389bd524b8b1"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/a9/60/47d92293d9bc521cd2301e423a358abfac0ad409b3a1606d8fbae1321961/types_python_dateutil-2.9.0.20241206.tar.gz"
    sha256 "18f493414c26ffba692a72369fea7a154c502646301ebfe3d56a04b3767284cb"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/dd/8f/5cf8bea1470f9d0af8a8a8e232bc9d94eb2b8c040f1c19e673fcd3ba488c/types_s3transfer-0.10.4.tar.gz"
    sha256 "03123477e3064c81efe712bf9d372c7c72f2790711431f9baa59cf96ea607267"
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
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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

    generate_completions_from_executable(bin/"sam", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
