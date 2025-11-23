class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/d8/bb/888542cd077dc763c06d8c3ab07adb5e380437d029a6404e856030747a94/aws_sam_cli-1.148.0.tar.gz"
  sha256 "1d7eceb62f491623d3460db73ad549b966645f8cf84e072ce83d8b849cdf1748"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0abc4737690227d332ef8c4e8b7d104ef55f7b18872e1a028d80fe60ca31a777"
    sha256 cellar: :any,                 arm64_sequoia: "af6b3fb6d4ecff5dc1f47b51aca8613456b7f5d099cb3f7bbee6d4ed75354786"
    sha256 cellar: :any,                 arm64_sonoma:  "b884f7702bfec703f9a3f261a64eb4d967714cb1081bd464aa7acd1938f05223"
    sha256 cellar: :any,                 sonoma:        "a28082f76a56e6b368c2cc70d0ac021b75dca013f935a23754a1872f40052025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c302f5de38add493070466a270a60f56254c78b3df66140409fc6c0732910e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e798e3df198116c17bb6b3a7217331a793a72c276e7ef8100a49992a32a965ad"
  end

  depends_on "cmake" => :build # for `awscrt`
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
    url "https://files.pythonhosted.org/packages/91/fd/94bdef6d6ff4c220593fc4c86c26fca0b45fc3c860cf69c62640c29acc31/aws_lambda_builders-1.60.0.tar.gz"
    sha256 "518b668130e550a4c88968432fba344a36aa965cca89bf8a30456f991053ae0e"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/d0/e3/82cc7240504b1c0d2d7ed7028b05ccceedb02932b8638c61a8372a5d875f/aws_sam_translator-1.103.0.tar.gz"
    sha256 "8317b72ef412db581dc7846932a44dfc1729adea578d9307a3e6ece46a7882ca"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/4d/40/99afe81abec294594302e60ee51c5ade36c5535ad5275fa50160b8a42877/awscrt-0.28.4.tar.gz"
    sha256 "d2835094e92d0a3d1722d03afd54983115b2172d57581a664ad6a2af3d33c12c"
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
    url "https://files.pythonhosted.org/packages/fa/81/2600e83ddd7cb1dac43d28fd39774434afcda0d85d730402192b1a9266a3/boto3-1.41.2.tar.gz"
    sha256 "7054fbc61cadab383f40ea6d725013ba6c8f569641dddb14c0055e790280ad6c"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/e9/de/ed64826dfe146e1aa91126e89a876f8c321a2039f6e29eb41ccfacc61bbd/boto3_stubs-1.41.0.tar.gz"
    sha256 "74d138f2d2f5f48140be81d680722b0194e09bcdf8d2080a914c21d277c2cfe3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c5/0b/6eb5dc752b240dd0b76d7e3257ae25b70683896d1789e7bfb78fba7c7c99/botocore-1.41.2.tar.gz"
    sha256 "49a3e8f4c1a1759a687941fef8b36efd7bafcf63c1ef74aa75d6497eb4887c9c"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/7c/83/6059eb33fd4632afc0f38669a87aa3cbff7dee238faae4208ec027568ff7/botocore_stubs-1.41.2.post1.tar.gz"
    sha256 "acf2145b85c5165378b298cb90bbc3a0da59e79204e4af3499d95d0d6d11987c"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/ee/b5/436c192cdf8dbddd8e09a591384f126c5a47937c14953d87b1dacacd0543/cfn_lint-1.41.0.tar.gz"
    sha256 "6feca1cf57f9ed2833bab68d9b1d38c8033611e571fa792e45ab4a39e2b8ab57"
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
    url "https://files.pythonhosted.org/packages/b7/42/ea8a8d4c8ba9645167030262b63e89eef9be7efe41899d98137fd995511c/mypy_boto3_apigateway-1.41.2.tar.gz"
    sha256 "fa93e033aec8ad05e443207aad7c57ad5a3910e665c4d151468131aea74b7f2c"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/a8/5d/3a9a1851837b68f5f8e2d144db364842a6fbe2b068d56e9043e07e349c63/mypy_boto3_cloudformation-1.41.2.tar.gz"
    sha256 "d6028c6193793038893622366bd7fb3f55e14789dc291fa36a424b32a2ed9a29"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/9a/dc/ae5d593d927e797d4b54264c86fa362fb0a0f5a2a2d7983b24533f160856/mypy_boto3_ecr-1.41.2.tar.gz"
    sha256 "c870b2637f9ba6f1f6967b448f14f29fcefa358f4521ba449acc7921b6821920"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/07/e2/59781e90e4310b9cf03edcb27f2c801cc93c133e132d5185e26cc9fd661e/mypy_boto3_iam-1.41.0.tar.gz"
    sha256 "fe6c997cf15dc3c2edeee6f1a8af975fa65c86430442198ef4125c69803b0cbf"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/99/bd/9ae588acd764ecc7b1b7ac7eab1419a1ff5cf6cccd5356732e7935fbe1f9/mypy_boto3_kinesis-1.41.1.tar.gz"
    sha256 "de5006abe73027d2f6efae616f1f488fd6a5286115df755b627ce6a0174c8ce9"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/1b/f8/fc970c2cefd1024f478153d28a6f14b9eabe844aed62f9ec0de64d16bbb3/mypy_boto3_lambda-1.41.2.tar.gz"
    sha256 "2b321c57382785c83151e668b7faef5cdfb8cdc381b0cb4213bcec750a5bb36e"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/8e/a1/1710c989c58965f2c21e32ffa955f7c91185704f527b9ecd69e1f6991bbd/mypy_boto3_s3-1.41.1.tar.gz"
    sha256 "1431bb6af31baffcd17860be19f7bf25586e3312372f433ccfaf0632b1e32097"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/bd/91/9e607d1bd941be45b4b5986e7d71229156d46f2e8731b057afa2ee7e3430/mypy_boto3_schemas-1.41.0.tar.gz"
    sha256 "1b576d120138357d70a18e66137af11dc8cde22227177e4d9c78dd097048230b"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/87/68/bf23a3cdfbfc3ccd4ba559be01c3be399bb4c1d7cbee7f235e70fa101c71/mypy_boto3_secretsmanager-1.41.0.tar.gz"
    sha256 "d8ca3c3e4c7dfd88b85cf0f956562734e8f3608aaf9f98e9669dc298c0624d5f"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/9f/d3/4952e84cbe519d2f4a811c2c14d73c2f3acc5e70c11556183752be75b3dc/mypy_boto3_signer-1.41.0.tar.gz"
    sha256 "efd4b641bda58fcaa972f65711cd60320469caf511665e41293dd0e1b3439bac"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/ae/16/6cf5f9fedce8b084c31a755544d59fe86ceb2a64bf05729e1b8b32205e7b/mypy_boto3_sqs-1.41.0.tar.gz"
    sha256 "806a8f6eb9348eaf8765ee2dda18883b1e882832cc99d12ae770f83b642885da"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/15/a7/7c41ca8ad7e6e81fd877fcf13437c7881d7a43cd32fa82197239e250948f/mypy_boto3_stepfunctions-1.41.0.tar.gz"
    sha256 "8fc7f87f2c5766dd5cecf4790789b9a202f82a463f132507784a6b2df260688a"
  end

  resource "mypy-boto3-sts" do
    url "https://files.pythonhosted.org/packages/d8/0f/870781c5d011742acb6cdec81de3913e6571320a0100cfad20b2d1e39ce1/mypy_boto3_sts-1.41.0.tar.gz"
    sha256 "b6043349bddc7cb82956c4851d728bafc21a6f2b0043b6ccae1e0e049b34fa9a"
  end

  resource "mypy-boto3-xray" do
    url "https://files.pythonhosted.org/packages/fd/12/6e3b63bf450736448d13d9c947d96882d1fad645b6339e8b11aaa5e5e11f/mypy_boto3_xray-1.41.0.tar.gz"
    sha256 "bf795faf292ea64213bc1f6912316b78e20dbf73f30e1cc596834f1b3e848023"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6c/4f/ccdb8ad3a38e583f214547fd2f7ff1fc160c43a75af88e6aec213404b96a/networkx-3.5.tar.gz"
    sha256 "d4c6f9cf81f52d69230866796b82afbccdec3db7ae4fbd1b65ea750feed50037"
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
    url "https://files.pythonhosted.org/packages/9f/c7/ee630b29e04a672ecfc9b63227c87fd7a37eb67c1bf30fe95376437f897c/ruamel.yaml-0.18.16.tar.gz"
    sha256 "a6e587512f3c998b2225d68aa1f35111c29fad14aed561a26e73fab729ec5e5a"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/ea/97/60fda20e2fb54b83a61ae14648b0817c8f5d84a3821e40bfbdae1437026a/ruamel_yaml_clib-0.2.15.tar.gz"
    sha256 "46e4cc8c43ef6a94885f72512094e482114a8a706d3c555a34ed4b0d20200600"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ca/bb/940d6af975948c1cc18f44545ffb219d3c35d78ec972b42ae229e8e37e08/s3transfer-0.15.0.tar.gz"
    sha256 "d36fac8d0e3603eff9b5bfa4282c7ce6feb0301a633566153cbd0b93d11d8379"
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
    url "https://files.pythonhosted.org/packages/6e/77/c25c0fbdd3b269b13139c08180bcd1521957c79bd133309533384125810c/types_awscrt-0.29.0.tar.gz"
    sha256 "7f81040846095cbaf64e6b79040434750d4f2f487544d7748b778c349d393510"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/79/bf/b00dcbecb037c4999b83c8109b8096fe78f87f1266cadc4f95d4af196292/types_s3transfer-0.15.0.tar.gz"
    sha256 "43a523e0c43a88e447dfda5f4f6b63bf3da85316fdd2625f650817f2b170b5f7"
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

  def python3
    "python3.13"
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"

    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install resources.reject { |r| r.name == "awscrt" }
    # CPU detection is available in AWS C libraries
    ENV.runtime_cpu_detection
    venv.pip_install resource("awscrt")
    venv.pip_install_and_link buildpath, build_isolation: false

    generate_completions_from_executable(bin/"sam", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
