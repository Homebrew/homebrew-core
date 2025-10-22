class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/ad/72/1e2ecd4b2b453b9d3eef2ca38d854658b09436a14eff2cdf82412c81ff85/aws_sam_cli-1.145.2.tar.gz"
  sha256 "5f5e6256ea625f64ca4e2d451c59f4a033c78a80c16c203875e282c0b7774ec7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63982db80d9221d3adbe5518f8671f4d5e763dc7b266d97163ff7722a0d67ff7"
    sha256 cellar: :any,                 arm64_sequoia: "6572481978730149e11829f7cf8e5b0b8922c5b3448bb4b54ca5a08c39fa7427"
    sha256 cellar: :any,                 arm64_sonoma:  "f885f370a2b6a27f6b25f3e85367875e048f80a24e0179764cebf11431695b82"
    sha256 cellar: :any,                 sonoma:        "a8d5d5a6ac2eb51b7b4d5b9b9091e23a634adaeea43837b36dee6d7c4e90aca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7982382fe1e1680d57f5fc4367930a7c4aaa510b6439cad28c16e7d76d53679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0da9712afb4bc445ac6d14204f064ae16980cd3fca5cb38b01e8ca63f299e8"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic-core" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libffi"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "aws-lambda-builders" do
    url "https://files.pythonhosted.org/packages/b7/77/32ad8ba660029b8e78a38e1e034ad4c32e408517b7329bafdb9d6f9c7a05/aws_lambda_builders-1.58.0.tar.gz"
    sha256 "95bf2a502bd9cf5abc14b1a27e9d0c7378cf261abb52373ea16be7ca22b7e812"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/e8/7f/db344c656949fa286ff8a14ff2c64355b6ca0cb6ebaf260678041acb8d9c/aws_sam_translator-1.101.0.tar.gz"
    sha256 "234c1ca29d47f2cd276858371d4a646bc5cdb0de1e07724721d9358d6de005aa"
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
    url "https://files.pythonhosted.org/packages/9c/8d/70929dde76e24f252d6cf1fb3224ff5694ca96451d9e7023a43555fab760/boto3-1.40.56.tar.gz"
    sha256 "c1afdb04dd27418fc58400434ab8e05998bb452b69c428168d9ada344fe6b93e"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/35/c8/06584145c4ccc80e3297a97874bfaa43e6b2fb9f8a69bcc38e29a1457bf5/boto3_stubs-1.40.50.tar.gz"
    sha256 "29828adfcb8629b5e285468eb89610f1fc71f964ad0913de3049a0a9d5de0be1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f7/03/e48e32cd73a7f82bae267320f435526bb6c7ec8d3d72d69febd4ec5b8ee9/botocore-1.40.56.tar.gz"
    sha256 "b29df3418a299609632cab240ee79275463b176ebeb3adc841ba367a3fa0c4db"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/48/ea/f174fc13a6e150021d6a0c51e58dc14d9730d319bdefc721bd7562ae513f/botocore_stubs-1.40.56.tar.gz"
    sha256 "aa9535b8a0f7135b062504e39e7cbc83fb3f00b2d4dc2baba6170436b494b696"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/cd/3e/0e653b305bf8f77d377943e7294176bdc4b1db9d29c989c1cc6255f7ac40/cfn_lint-1.40.2.tar.gz"
    sha256 "5822b2c90f7f2646823a47db9df7a60c23df46bbac34b2081d8a0b3b806c91eb"
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
    url "https://files.pythonhosted.org/packages/2b/4c/c8de2ecbafde4de3ec8fc935726fe672c11f563d37bf70d8e68df8502be6/mypy_boto3_apigateway-1.40.0.tar.gz"
    sha256 "99f3134375d25470e34e340463f10bd71ab8b7429168fc06d8dbb43f0b1b937a"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/8c/2c/140b6b0d74afa4854edb3b3e640ff96c711270f27711ad1325cecc5661c1/mypy_boto3_cloudformation-1.40.44.tar.gz"
    sha256 "3d82f5504382c86ad195a1b80a2a82f73587c37e1b636864ebb85dd43bd79a5b"
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
    url "https://files.pythonhosted.org/packages/27/af/0bce015eb183a5bd43a90774ef995e183c44a150c105361cd8ed629d2d18/mypy_boto3_lambda-1.40.50.tar.gz"
    sha256 "a709e0ac6940783aad08ff5cf98c789a215840bab17e468ca5e22305ad0aea05"
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
    url "https://files.pythonhosted.org/packages/38/8a/dbd8aa981b72b4481441d2f7c0e4d21522b6b0aec3d296cf05d6b2966147/mypy_boto3_signer-1.40.55.tar.gz"
    sha256 "07ad05fd0d8594bb8d08666ec5267703d41200c14c80538ed0014bce64ddca85"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/70/be/27ead4078dc1faa9c6c1916e0f7cfdb102925591eaab153a496640250541/mypy_boto3_sqs-1.40.35.tar.gz"
    sha256 "c11f95ee72bddb84f7fecf3000372e01547f36737064b785f1cf34191b87e03f"
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
    url "https://files.pythonhosted.org/packages/f3/1e/4f0a3233767010308f2fd6bd0814597e3f63f1dc98304a9112b8759df4ff/pydantic-2.12.3.tar.gz"
    sha256 "1da1c82b0fc140bb0103bc1441ffe062154c8d38491189751ee00fd8ca65ce74"
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
    url "https://files.pythonhosted.org/packages/f8/c8/1d2160d36b11fbe0a61acb7c3c81ab032d9ec8ad888ac9e0a61b85ab99dd/regex-2025.10.23.tar.gz"
    sha256 "8cbaf8ceb88f96ae2356d01b9adf5e6306fa42fa6f7eab6b97794e37c959ac26"
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
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
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
    url "https://files.pythonhosted.org/packages/86/65/f92debc7c9ff9e6e51cf1495248f0edd2fa7123461acf5d07ec1688d8ac1/types_awscrt-0.28.2.tar.gz"
    sha256 "4349b6fc7b1cd9c9eb782701fb213875db89ab1781219c0e947dd7c4d9dcd65e"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/8e/9b/8913198b7fc700acc1dcb84827137bb2922052e43dde0f4fb0ed2dc6f118/types_s3transfer-0.14.0.tar.gz"
    sha256 "17f800a87c7eafab0434e9d87452c809c290ae906c2024c24261c564479e9c95"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
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
