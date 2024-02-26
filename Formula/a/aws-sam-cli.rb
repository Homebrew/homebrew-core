class AwsSamCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM"
  homepage "https://aws.amazon.com/serverless/sam/"
  url "https://files.pythonhosted.org/packages/52/ca/3f7de194e0d419f8e29c6098fafe3d8e637adda85021dadf67ad8f87ef6d/aws-sam-cli-1.110.0.tar.gz"
  sha256 "35d585fe1b8598747a50f736b2a1ce2def069118a1cccb4f3d5391cb0ace427e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9fd8985ce4e023d774bce7df25048333bda17e159ffbcd6c1d286559f52267f"
    sha256 cellar: :any,                 arm64_ventura:  "c4d77d2d8274f99ceee2b9f0bf620098e769cbc49abf2e79f6ef3ca675877262"
    sha256 cellar: :any,                 arm64_monterey: "97fd2ff3d4e60374e276d3441b4df6624c76ddbeacda4806aadcc942a590f2a3"
    sha256 cellar: :any,                 sonoma:         "d571352caaa4e3a15e38daa17956f80e020f5a85237d9dac649caf4e368d30d7"
    sha256 cellar: :any,                 ventura:        "7fbcf3b96e651eba6a3ef3b4c302a0b38aff85649962aa5d242e76622fbde5dd"
    sha256 cellar: :any,                 monterey:       "82d8409d2fc5d69ff58234ad13d2b2ef464513ebf4326e275f24c3b5fe093bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "196357407dfdb3df31c5f4092bfd983d5d8962557792284589b81f264cd9d9a5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
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
    url "https://files.pythonhosted.org/packages/74/ed/701b3db0b5b1efca12a3c53da0dfd3212ddbddb4ef2a00eccc9902a2c311/aws_lambda_builders-1.46.0.tar.gz"
    sha256 "fe3ffc5b3d3176b3e3f92a57d83615ed63399ba897d1ce4110bcaba83a1878d3"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/43/e0/2943607c4947d409c55ff4893cb0aabb6759a933c065a201012f80bc63e7/aws-sam-translator-1.85.0.tar.gz"
    sha256 "e41938affa128fb5bde5e1989b260bf539a96369bba3faf316ce66651351df39"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/89/51/8b7c07768bef5756cdc38b3168b228139d2ff1ddd782e515f1c0f2c35a2a/boto3-1.34.47.tar.gz"
    sha256 "7574afd70c767fdbb19726565a67b47291e1e35ec792c9fbb8ee63cb3f630d45"
  end

  resource "boto3-stubs" do
    url "https://files.pythonhosted.org/packages/05/66/0869ed76554991657b2d83ebf11247aae565ac57ea5dd52ce31870a16993/boto3-stubs-1.34.43.tar.gz"
    sha256 "0a0bdf96eb42f3b12b9bf159d97c407cf272e0430e5f7b42581ce7124ce9bb78"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/cf/8c9516f6b1fb859e7fcb7413942b51573b54113307a92db46a44497a3b96/botocore-1.34.47.tar.gz"
    sha256 "29f1d6659602c5d79749eca7430857f7a48dd02e597d0ea4a95a83c47847993e"
  end

  resource "botocore-stubs" do
    url "https://files.pythonhosted.org/packages/2d/18/b4038b2b43efdeba39a611e7304ac1c9dd1a18e9a006e90b86e65d0f453f/botocore_stubs-1.34.47.tar.gz"
    sha256 "cc1fac318e3b28f4cae4f664daa1598fcd1daa87fe5b312b402137b761ed1c46"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/f1/d7/c239d3325f40b3323de1da4170a3b2e108fc1094c739cda992619cafe68b/cfn-lint-0.85.2.tar.gz"
    sha256 "f8a5cc55daeaaa747b8d776dcf62fe1b6bfb8cb46ae60950cbe627601facccd7"
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
    url "https://files.pythonhosted.org/packages/1a/5d/9f6a7b748436597060654c8b5815dabedd78893e566bc9838c6dcbf05e04/cookiecutter-2.5.0.tar.gz"
    sha256 "e61e9034748e3f41b8bd2c11f00d030784b48711c4d5c42363c50989a65331ec"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/3f/e0/a89e8120faea1edbfca1a9b171cff7f2bf62ec860bbafcb2c2387c0317be/flask-3.0.2.tar.gz"
    sha256 "822c03f4b799204250a7ee84b1eddc40665395333973dfb9deebfe425fefcb7d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
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
    url "https://files.pythonhosted.org/packages/05/68/38c6c809fd3203e507c0c95ebede5e682bdc84f2e81fc6f818d7926c6a41/jsonpickle-3.0.3.tar.gz"
    sha256 "5691f44495327858ab3a95b9c440a79b41e35421be1a6e09a47b6c9b9421fd06"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
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
    url "https://files.pythonhosted.org/packages/04/69/6b2bb7857de854b085301802891856ff47617ed22793ecf79675aff9589a/mypy-boto3-apigateway-1.34.0.tar.gz"
    sha256 "3c724120971c74fb65a94eb7e4b92a3a4b28df6c70ca04a007072e6c73f6eda7"
  end

  resource "mypy-boto3-cloudformation" do
    url "https://files.pythonhosted.org/packages/d4/33/535ec20237e9f1cc22bcd2adcf296c1b4d63ea92801d3706d1bc0f6120af/mypy-boto3-cloudformation-1.34.32.tar.gz"
    sha256 "49d04c090dae3fd8289738ae592cac9d6faa5169684de40c2730b425bba2a32d"
  end

  resource "mypy-boto3-ecr" do
    url "https://files.pythonhosted.org/packages/52/05/3cb67f373c30340e0043d5d8f5f07a163e263a691b3254ce361c2c9090cd/mypy-boto3-ecr-1.34.0.tar.gz"
    sha256 "b83fb0311e968a42d4ca821b006c18d4a3e3e364b8cebee758ea4fa97c5ac345"
  end

  resource "mypy-boto3-iam" do
    url "https://files.pythonhosted.org/packages/a6/ae/32dfd261793efc74a41898b6c6eb23078a1f648aae484a44d4225662ef84/mypy-boto3-iam-1.34.8.tar.gz"
    sha256 "6faf68cf800182924687b6711b3f9afa8d940ad993f259a3b91e55e82892d641"
  end

  resource "mypy-boto3-kinesis" do
    url "https://files.pythonhosted.org/packages/7d/14/fd707a18485ebf99ac10388b3f1bd2a40f49c8f04dbcd1e2aa86cc7991f9/mypy-boto3-kinesis-1.34.0.tar.gz"
    sha256 "f404e75badd5977e9f09741b769b8888854bdd411c631344686ab889efe98741"
  end

  resource "mypy-boto3-lambda" do
    url "https://files.pythonhosted.org/packages/7b/df/bedebdf4e5b719812db2ba3dfba2110341b55649dc15116d5eb250cfa5bf/mypy-boto3-lambda-1.34.46.tar.gz"
    sha256 "275297944c5e36a170b37ce70229f21db6dd3561606799f18d96e36ac5df6876"
  end

  resource "mypy-boto3-s3" do
    url "https://files.pythonhosted.org/packages/16/f8/a420878066d6bc684a6360c47117b1a068be29fd5a89a644b04eee1b7a0c/mypy-boto3-s3-1.34.14.tar.gz"
    sha256 "71c39ab0623cdb442d225b71c1783f6a513cff4c4a13505a2efbb2e3aff2e965"
  end

  resource "mypy-boto3-schemas" do
    url "https://files.pythonhosted.org/packages/0b/7e/1850db88a985b7b044ab3c49e2cb5f2cebd531f01f228b86504cdffedef7/mypy-boto3-schemas-1.34.0.tar.gz"
    sha256 "3b25a71944192b0980c3bb5132deb7c06ee9b88580ed63f257fad97cf3bf2927"
  end

  resource "mypy-boto3-secretsmanager" do
    url "https://files.pythonhosted.org/packages/11/3f/17c85e14d08965c36042d7d0c16f2998d6c7a86bb7887a6cc97a9806dff9/mypy-boto3-secretsmanager-1.34.43.tar.gz"
    sha256 "abbf560775c2fe0dc383b7f70c16a1bf753d9b3ffc0caa5e35447e685783a68b"
  end

  resource "mypy-boto3-signer" do
    url "https://files.pythonhosted.org/packages/ea/69/7c5455482360efb2705f0253c2f7e5069ac4a0bc3038280eb2336409e25e/mypy-boto3-signer-1.34.0.tar.gz"
    sha256 "c11ed943ccd38ee54fc0ca90ed347ef770d695df49535eab96dd97fb3dbdc592"
  end

  resource "mypy-boto3-sqs" do
    url "https://files.pythonhosted.org/packages/f7/79/d70757f58c90c1d530023e18bc45b33eb6fa4435121c965f8921c4bc1ca5/mypy-boto3-sqs-1.34.0.tar.gz"
    sha256 "0bf8995f58919ab295398100e72eaa7da898adcfd9d339a42f3c48ce473419d5"
  end

  resource "mypy-boto3-stepfunctions" do
    url "https://files.pythonhosted.org/packages/8d/95/857d5b47f42815c95d4bc118e5c1b5decad44a169b1766f07c6233724326/mypy-boto3-stepfunctions-1.34.0.tar.gz"
    sha256 "06d2296cee750d17cb62171420eea4614f20f29be45ee361854f8b599a6e8110"
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
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/73/27/a17cc261bb974e929aa3b3365577e43c1c71c3dcd8669250613a7135cb8f/pydantic-2.6.1.tar.gz"
    sha256 "4fd5c182a2488dc63e6d32737ff19937888001e2a6d86e94b3f233104a5d1fa9"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/0d/72/64550ef171432f97d046118a9869ad774925c2f442589d5f6164b8288e85/pydantic_core-2.16.2.tar.gz"
    sha256 "0ba503850d8b8dcc18391f10de896ae51d37fe5fe43dbfb6a35c5c5cad271a06"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    url "https://files.pythonhosted.org/packages/21/c5/b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9a/referencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/ba/ce7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5e/rpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
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
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "types-awscrt" do
    url "https://files.pythonhosted.org/packages/54/1f/a435977c79c316224010d0fa0bd85ae48440e11fd0f530df8be964bef791/types_awscrt-0.20.3.tar.gz"
    sha256 "06a859189a329ca8e66d56ceeef2391488e39b878fbd2141f115eab4d416fe22"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/9b/47/2a9e51ae8cf48cea0089ff6d9d13fff60701f8c9bf72adaee0c4e5dc88f9/types-python-dateutil-2.8.19.20240106.tar.gz"
    sha256 "1f8db221c3b98e6ca02ea83a58371b22c374f42ae5bbdf186db9c9a76581459f"
  end

  resource "types-s3transfer" do
    url "https://files.pythonhosted.org/packages/5b/90/f00658473474581f334c43993f3cfd518955d4eb125cffa1279c94cf1605/types_s3transfer-0.10.0.tar.gz"
    sha256 "35e4998c25df7f8985ad69dedc8e4860e8af3b43b7615e940d53c00d413bdc69"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[cfn-lint cookiecutter].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    output = shell_output("#{bin}/sam validate 2>&1", 1)
    assert_match "SAM Template Not Found", output

    assert_match version.to_s, shell_output("#{bin}/sam --version")
  end
end
