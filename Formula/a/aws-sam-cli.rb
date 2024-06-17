class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/fe/a7/ff062636ccf69613baadb6c3ddb183229ad90951bf8991cdafc4236a9d07/aws_sam_cli-1.119.0.tar.gz"
  sha256 "fc1879f90cef5bc7264aac62fa5d85a0ce83b88bb9e24a4c4434542bc59e1d68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7cff6aaaed7281e23384236a603e9e061afcb175c970652b1cd6c630b8473ffd"
    sha256 cellar: :any,                 arm64_ventura:  "2965398e7e61b0e5b3fd82f434ec8b80c1725cbcf4381820b3c0ceb32cbf279c"
    sha256 cellar: :any,                 arm64_monterey: "205ca9a4b131929f30fe84cdce2b9d920d3c326d09e22077a00c8df08c8cea0a"
    sha256 cellar: :any,                 sonoma:         "0cb3f6bddc565e7aa8b13b1698f761a8f00b4f81ebdc98f979f40f245ecbad5e"
    sha256 cellar: :any,                 ventura:        "c07e2f44649a4f6416db5776f8636661994aeeea7dc3fabdf506817f5ff9c8e2"
    sha256 cellar: :any,                 monterey:       "44cd0b658e48ba0af179d7ec95a0ea1cc700e0eef45c8c4b112ef24f9918950c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5dfa586614be4574cb2e5bb0c8fa63d304c7a087ca61d99deceeb825c89433d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/16/42/0f6696919255886126d02d0d4ae7c5be75b84679ae9fa9bc9fb59f3d3223/aws_lambda_builders-1.50.0.tar.gz"
    sha256 "ad95ed55359c399872f5825582896500dfc1c5564eccf2a6ab8d0e9f6c1ae385"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/03/81/448cc26a70366e681eeb4ae868e1e5519f5d2d3d8602dd69731f236cbd43/aws_sam_translator-1.89.0.tar.gz"
    sha256 "fff1005d0b1f3cb511d0ac7e85f54af06afc9d9e433df013a2338d7a0168d174"
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
    url "https://files.pythonhosted.org/packages/46/3f/21b5e6885f4040ccca54f8576631c514e5359187450cbc160c47684edc02/boto3-1.34.126.tar.gz"
    sha256 "7e8418b47dd43954a9088d504541bed8a42b6d06e712d02befba134c1c4d7c6d"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/da/e4/defced34fc5cb9aa09b3a33eb3d4354c92d5da33d5880286b963652a6deb/boto3_stubs-1.34.123.tar.gz"
    sha256 "2fdbbce40108c2d838e3e8efaf6f839c23d897167e8d6168daf3655d41aa66af"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4c/83/a907cb591f08bfe42c9ab79ac7d5f824f354a9e91e7ebaca580eb2ddabfd/botocore-1.34.126.tar.gz"
    sha256 "7a8ccb6a7c02456757a984a3a44331b6f51c94cb8b9b287cd045122fd177a4b0"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/0c/1f/14282f3fbe2b28a36a3b46e0b708cc2fa847d47c7eec0fa1e77cc8a08107/botocore_stubs-1.34.126.tar.gz"
    sha256 "9305857fdafda1d8770307986489fc3a7b792cd505b6e56ba4306522b420b777"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/4b/82/057662f0c600919bf1f5b5ac05aaf1b495d212c98a94f132cd133a445ff1/cfn_lint-0.87.7.tar.gz"
    sha256 "85f6b7f32cf155a74d670d53f86b39f99cfc282b02158d98fdab9fc1dba0809e"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/fa/2d/806d7ce5743131a6a137c49016ad80db3c3a757288b863795bb50eb99603/jsonpickle-3.2.1.tar.gz"
    sha256 "4b6d7640974199f7acf9035295365b5a1a71a91109effa15ba170fbb48cf871c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/19/f1/1c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263/jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
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
    url "https://files.pythonhosted.org/packages/f4/ee/581cbb27d33af3564868810fa9eb66a38fbcc2bc8831dc2e961fb9931075/mypy-boto3-apigateway-1.34.56.tar.gz"
    sha256 "5ab15db30d730198384d6445d50cc1fec98361b85366dd092b10e9b9f4a1a2cb"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/59/c3/f48efbcc17fb03fb167993028889be0bfbb582720e3eaa719786c5c53085/mypy_boto3_cloudformation-1.34.111.tar.gz"
    sha256 "a02e201d1a9d9a8fb4db5b942d5c537a4e8861c611f0d986126674ac557cb9e8"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/c4/f4/35895e54ef9fe43ac8e27364a35b069ff86b52ff4b58bbaf604d59479e84/mypy_boto3_ecr-1.34.101.tar.gz"
    sha256 "e9acb57088daa41b3fb378f8bb966ca4a4f1b62edb9a2483de582bcf9486a4fc"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/e5/db/a790cb091d77007268bdf0ced0e9a6c79f25b820bd309d33f0ef86ab47b0/mypy-boto3-iam-1.34.83.tar.gz"
    sha256 "7261315616757ebf7509df0e9b091d5942e470eb51c4b23c662a06873a9a8eca"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/7d/14/fd707a18485ebf99ac10388b3f1bd2a40f49c8f04dbcd1e2aa86cc7991f9/mypy-boto3-kinesis-1.34.0.tar.gz"
    sha256 "f404e75badd5977e9f09741b769b8888854bdd411c631344686ab889efe98741"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/21/b3/49903a707edbe4f67ba5c4876288041e3841553c3c99b0172bc6682c18f5/mypy-boto3-lambda-1.34.77.tar.gz"
    sha256 "7b81d2a5604fb592e92fe0b284ecd259de071703360a33b71c9b54df46d81c9c"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/ae/e8/e114c93252495db36891f731b5bb8ed1c9c10a1fff03291d97a850ab034a/mypy_boto3_s3-1.34.120.tar.gz"
    sha256 "d508a7bca6cc1100b2d4c8fc7dc9a0a71f3b2a275338191a0eac161c904ca7bc"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/0b/7e/1850db88a985b7b044ab3c49e2cb5f2cebd531f01f228b86504cdffedef7/mypy-boto3-schemas-1.34.0.tar.gz"
    sha256 "3b25a71944192b0980c3bb5132deb7c06ee9b88580ed63f257fad97cf3bf2927"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/6a/92/d8a1decfb32baceb2ad397b2ee1fda69e7982c873c167a98ce14ead570b4/mypy_boto3_secretsmanager-1.34.125.tar.gz"
    sha256 "358020a40ec16f4ca753e5e41472a466e748eb0964a209d3ca7cb598537b2707"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/be/f7/fd8198bb30d1ac8d85e082f1096652c238db905f4d03436d9ce40800f614/mypy_boto3_signer-1.34.95.tar.gz"
    sha256 "0118854f1664f7e27e03f5ce2fea3344cc4985fa6ed15a0d5c7a7146b4a4326f"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/81/75/83be93078eb1e78f7f7d04e33c2c7e313c81420660d3fb7a28522487e07a/mypy_boto3_sqs-1.34.121.tar.gz"
    sha256 "bdbc623235ffc8127cb8753f49323f74a919df552247b0b2caaf85cf9bb495b8"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/1b/51/fd49495218efc1edd2bfe0ceb3fd535728dc64ba66ab7e084ab3541b28dd/mypy_boto3_stepfunctions-1.34.92.tar.gz"
    sha256 "499a5de2f854e5ecf45fee00a5ec20478b4130af1d9d61721e176a787970394c"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/cc/73/e93911b3451f252f375967b77f816719bef549488293918c3a4a7b0afd54/mypy-boto3-sts-1.34.0.tar.gz"
    sha256 "b347e0a336d60162dd94074d9d10f614f2b09a455c9b42415850d54d676e2067"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/eb/46/c35eddcbfb026f46e7ad0d934c888f45401bd51844c5edaecdb3d5a5b1b3/mypy-boto3-xray-1.34.0.tar.gz"
    sha256 "f30785798022b7f0c114e851790af9b92cb4026ed28757e962d30fb4391af8e2"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/0d/fc/ccd0e8910bc780f1a4e1ab15e97accbb1f214932e796cff3131f9a943967/pydantic-2.7.4.tar.gz"
    sha256 "0c84efd9548d545f63ac0060c1e4d39bb9b14db8b3c0652338aecc07b5adec52"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/02/d0/622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6/pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/91/a8/cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1/pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
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
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/2d/aa/e7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beea/rpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/41/8a/0d1bbd33cd3091c913d298746e56f40586fa954788f51b816c6336424675/sympy-1.12.1.tar.gz"
    sha256 "2877b03f998cd8c08f07cd0de5b767119cd3ef40d09f41c30d722f6686b0fb88"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/2b/ab/18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8/tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/93/39/502831bdfbf9317aaeed1a5519a133826b7249e2c8fada2ce4d6a39c2b82/types_awscrt-0.20.12.tar.gz"
    sha256 "0beabdde0205dc1da679ea464fd3f98b570ef4f0fc825b155a974fb51b21e8d9"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/61/c5/c3a4d72ffa8efc2e78f7897b1c69ec760553246b67d3ce8c4431fac5d4e3/types-python-dateutil-2.9.0.20240316.tar.gz"
    sha256 "5d2f2e240b86905e40944dd787db6da9263f0deabef1076ddaed797351ec0202"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/6b/27/f0c0bc936cf9213e3acb485aff7cdf93b78d946036c5e0d6c878cdd65525/types_s3transfer-0.10.1.tar.gz"
    sha256 "02154cce46528287ad76ad1a0153840e0492239a0887e8833466eccf84b98da0"
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
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/1b/f9/b01e4632aed9a6ecc2b3e501feffd3af5aa0eb4e3b0283fc9525bf503c38/watchdog-4.0.1.tar.gz"
    sha256 "eebaacf674fa25511e8867028d281e602ee6500045b57f43b08778082f7f8b44"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/02/51/2e0fc149e7a810d300422ab543f87f2bcf64d985eb6f1228c4efd6e4f8d4/werkzeug-3.0.3.tar.gz"
    sha256 "097e5bfda9f0aba8da6b8545146def481d06aa7d3266e7448e2cccf67dd8bd18"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b8/d6/ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69/wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
