class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/7b/a8/641278b0bec14b6cf1b93bcc711ad13d86243e2f22c4ff799c79c9dad2fd/aws_sam_cli-1.147.1.tar.gz"
  sha256 "1da7a3bd0386fd5813fa84cdefe8c4c1b8075d4a2b923524c27f6fdbf1099872"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80c66bc19ca2ab4e6cada3d1d400ec7b0691b1e441ad9d5d9f506f23c4ba69ef"
    sha256 cellar: :any,                 arm64_sequoia: "da5e3e367a364feda97e370ef34020aa8531b5265df71a246b636007dbbb324e"
    sha256 cellar: :any,                 arm64_sonoma:  "a681b6c743ce4188109c9d1adbf9d83db34a4ba47baf7c528dc4d24cf8e2b7d5"
    sha256 cellar: :any,                 sonoma:        "4122fa2cad9c7ff9ce6968ab8cdf042f2383db9b429a5d9357289dfb6cc5b38c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b47e4baaf538dfe7987adea53d1a28b128c13d32a7d799875cc2c6f111e86a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c90a5ac37653df95786a37bd301c1cfc023c5c66784f1eeaf6d461e1a7acf5"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
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
    url "https://files.pythonhosted.org/packages/14/9c/c9efaf3b77f856a3a6f6543e4bcd3c4b0bc62da3140dbd2c2a8568c8e6aa/aws_sam_translator-1.102.0.tar.gz"
    sha256 "ea3f6ebff9adf726e0802fab90b8a1bd89008f072ee2d35ec385f9d504820fff"
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
    url "https://files.pythonhosted.org/packages/dd/4f/92744c97f42e214948b9c8eff86e7e72c7ca8be788867a8aea80dc192052/boto3-1.41.0.tar.gz"
    sha256 "73bf7f63152406404c0359c013a692e884b98a3b297160058a38f00ef19e375b"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/e9/de/ed64826dfe146e1aa91126e89a876f8c321a2039f6e29eb41ccfacc61bbd/boto3_stubs-1.41.0.tar.gz"
    sha256 "74d138f2d2f5f48140be81d680722b0194e09bcdf8d2080a914c21d277c2cfe3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c4/8d/af94a3a0a5dc3ff255fdbd9a4bdf8e41beb33ea61ebab92e3d8e017f9ee4/botocore-1.41.0.tar.gz"
    sha256 "555afbf86a644bfa4ebd7bd98d717b53b792e6bbb2c49f2b308fb06964cf1655"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/c9/03/02f3ca1bd4baae56dfb148d8f7a18466f0b10b0006c57811dc73d24ccedc/botocore_stubs-1.40.76.tar.gz"
    sha256 "261d51e71a164a93abf9c6a5c779c5664d307ec4450de917ad9cbe7c29782223"
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
    url "https://files.pythonhosted.org/packages/18/78/8af639c53a9a17dcdf768ca4e8487c49d655466763fb39d35fa7992bde59/mypy_boto3_apigateway-1.41.0.tar.gz"
    sha256 "53846bc7fb3d3be5a1e92ecfbe452883aadc338c625bcaa0b7a0a076616b6568"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/b5/d0/7eabbda1b94e5c227e94a082ca45ab318bd2b5810681c8fef40962f56394/mypy_boto3_cloudformation-1.41.0.tar.gz"
    sha256 "8ae1e5dec9619df339479785890c335fc37f4e48bb081fc6b1e0bc76bcc18f43"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/1d/65/c8aeef02ad31469b02b9bfe4cfc9be04b319898ed1e758b8a4d2e64f6cd3/mypy_boto3_ecr-1.41.0.tar.gz"
    sha256 "71507c0437008fb7c61cd5cf255d31e38503e127a5ae8db15070b5b6683b2704"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/07/e2/59781e90e4310b9cf03edcb27f2c801cc93c133e132d5185e26cc9fd661e/mypy_boto3_iam-1.41.0.tar.gz"
    sha256 "fe6c997cf15dc3c2edeee6f1a8af975fa65c86430442198ef4125c69803b0cbf"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/d1/65/03dacc0403b46befc179dcda3e3492702e593949a419b5dbd6c8133dbd63/mypy_boto3_kinesis-1.41.0.tar.gz"
    sha256 "41730a3ee1b1afe6c2425c1e1c0fa51e8285de30461b87012725f78f42c75277"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/94/0c/453158309249ec2e1b5a5b538c451fd3c8d46c864a24004c5c31f052f766/mypy_boto3_lambda-1.41.0.tar.gz"
    sha256 "8af5e91b554f2b585feb8eb8075d5c692958374f4e9675cc8900d3d4771fb531"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/18/89/20706821019fb44f2239d2bd3b54031d9227b079644678c074ad2ef224d8/mypy_boto3_s3-1.41.0.tar.gz"
    sha256 "0e14246af9dc001145e450e10afaace98fc5249c213179688e05e6d9c0dce20a"
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
    url "https://files.pythonhosted.org/packages/f7/6f/d4f2adb086e8f5cd2ae83cf8dbb192057d8b5025120e5b372468292db67f/types_awscrt-0.28.4.tar.gz"
    sha256 "15929da84802f27019ee8e4484fb1c102e1f6d4cf22eb48688c34a5a86d02eb6"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/8e/9b/8913198b7fc700acc1dcb84827137bb2922052e43dde0f4fb0ed2dc6f118/types_s3transfer-0.14.0.tar.gz"
    sha256 "17f800a87c7eafab0434e9d87452c809c290ae906c2024c24261c564479e9c95"
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
