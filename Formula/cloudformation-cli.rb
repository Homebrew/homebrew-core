class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https://github.com/aws-cloudformation/cloudformation-cli/"
  url "https://files.pythonhosted.org/packages/51/56/4c7b7d424e1dd045e7f49489eceacc8032b687c7526dfd3a04e1cd217c59/cloudformation-cli-0.2.13.tar.gz"
  sha256 "c60cacb403d1387e2306e67c75e7fe4fb03c63b1110c4a26dd745183861911df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7eaa68ce607b53279993f0dc5e040547645115ac4688f3f24726d7050095987d"
    sha256 cellar: :any_skip_relocation, big_sur:       "ccc40327beb9fbc5a79be28ef30de117afb963bb37e61e1b80060653be1f7908"
    sha256 cellar: :any_skip_relocation, catalina:      "8298336f0aebd0985c46d54f6f01814159b165358188ba8513eaec0eb5ec8612"
    sha256 cellar: :any_skip_relocation, mojave:        "30f966c0f837f5190187cb3d10bc3d46c2b6a18e60fe0ac9f317fa86a7276af1"
  end

  depends_on "go" => :test
  depends_on "python@3.9"

  uses_from_macos "expect" => :test

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/19/42/74463bfc1f4948a3353e5fbf3e07c5aadd8682c8a777dae269debf7bec0a/aws-sam-translator-1.36.0.tar.gz"
    sha256 "fa1b990d9329d19052e7b91cf0b19371ed9d31a529054b616005884cd662b584"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/09/2d/be54cc46a2b866f2664ee6578ca9afd6a6ba0d5d0410d75650bdf89f71b2/boto3-1.17.100.tar.gz"
    sha256 "0cdb443db72787eff296138952f952529d49dba00d67d5652017d2584daab33a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e0/3c/d3de583de93286e378d5a7c1b8993b0dacf24caa0220ecbae3db91b7f2ac/botocore-1.20.100.tar.gz"
    sha256 "1331c6a9aafa1a893b20d9ee71abdb52c9bb4e5f7197e82153c371e1856e645d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/76/5a/314a934b75f2f52d1845e4344b9bbdacdd76d82784b678ec27c2ed57fd2c/cfn_flip-1.2.3.tar.gz"
    sha256 "2bed32a1f4dca26dc64178d52511fd4ef778b5ccbcf32559cac884ace75bde6a"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/a7/59/6d7cd4c6c3f31de040757e56b9f769b6a27ece4c744a5400c57ffc900ae3/cfn-lint-0.51.0.tar.gz"
    sha256 "453c759de8372062174e40d3bce8f7e3472767074873429b2f2f6037b7f74b7d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "cloudformation-cli-go-plugin" do
    url "https://files.pythonhosted.org/packages/8f/00/909410b531a330f3f8a784862dd0daf12541a99a969555e2b3c7af892ec7/cloudformation-cli-go-plugin-2.0.4.tar.gz"
    sha256 "2b6bc4eaa89b7c055a91b86ec957ef765b0c8a43f5af3c4fa916e2d4d3fd03d6"
  end

  resource "cloudformation-cli-java-plugin" do
    url "https://files.pythonhosted.org/packages/7b/53/adc0692790da5fcbeb021e88d78c5daa5f19067af2a560e423f1f856d0f1/cloudformation-cli-java-plugin-2.0.5.tar.gz"
    sha256 "c10a354f8a50d6d734c58c1b49b7d3d9235eb08663fd613a4da5a7d2e33b90a2"
  end

  resource "cloudformation-cli-python-plugin" do
    url "https://files.pythonhosted.org/packages/57/cd/f438e70a4fdf01082f248880bda7b517e28fe9031f0013ebb964e5bdaab9/cloudformation-cli-python-plugin-2.1.4.tar.gz"
    sha256 "315740a371b8122a185cca99964be06a8b2d52200bd45b481245cb8a996a96a6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/fa/a2/e46d7c1b51394a09271a3b07c3a68deb3a669429beafd444d9553ed52868/docker-5.0.0.tar.gz"
    sha256 "3e8bc47534e0ca9331d72c32f2881bb13b93ded0bcdeab3c833fb7cf61c0a9a5"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/53/ea/49b4c96bc7c0d1df1ba7b5ae308232c1ec8667036147624d37c9ac95b26b/hypothesis-6.14.0.tar.gz"
    sha256 "9bdee01ae260329b16117e9b0229a839b4a77747a985922653f595bd2a6a541a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2/iniconfig-1.1.1.tar.gz"
    sha256 "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6b/35/400557d3df63269a4c010cbd4865910b3c1718fbfe8d83210b216cd3efcf/jsonpointer-2.1.tar.gz"
    sha256 "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "nested-lookup" do
    url "https://files.pythonhosted.org/packages/1e/91/a387bb18e8cb56461e317f1a0a73c310d2e70e748c288bc10dd51fa0b996/nested-lookup-0.2.22.tar.gz"
    sha256 "e39adacd11e879dd6383b0a832cde97edce25d2a29cbc03a9c80fefa3a131e8b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/b0/21/adfbf6168631e28577e4af9eb9f26d75fe72b2bb1d33762a5f2c425e6c2a/networkx-2.5.1.tar.gz"
    sha256 "109cd585cac41297f71103c3c42ac6ef7379f29788eb54cb751be5a663bb235a"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/f5/ab/8252360bfe965bba31ec05112b3067bd129ce4800d89e0b85613bc6044f6/ordered-set-4.0.2.tar.gz"
    sha256 "ba93b2df055bca202116ec44b9bead3df33ea63a7d5827ff8e16738b97f33a95"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/0d/8c/50e9f3999419bb7d9639c37e83fa9cdcf0f601a9d407162d6c37ad60be71/py-1.10.0.tar.gz"
    sha256 "21b81bda15b66ef5e1a777a21c4dcd9c20ad3efd0b3f817e7a809035269e1bd3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/4d/70/fd441df751ba8b620e03fd2d2d9ca902103119616f0f6cc42e6405035062/pyrsistent-0.17.3.tar.gz"
    sha256 "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/5b/98/92bbda5f83ed995ef8953349ef30c77c934abcc251c42ab3d7787a40c49c/pytest-6.2.4.tar.gz"
    sha256 "50bcad0a0b9c5a72c8e4e7c9855a3ad496ca6a881a3641b4260605450772c54b"
  end

  resource "pytest-localserver" do
    url "https://files.pythonhosted.org/packages/6c/b3/db8f8700718fbefaa2e8b2ef690fec147e560ce92e2300cdb3ff462d313c/pytest-localserver-0.5.0.tar.gz"
    sha256 "3a5427909d1dfda10772c1bae4b9803679c0a8f04adb66c338ac607773bfefc2"
  end

  resource "pytest-random-order" do
    url "https://files.pythonhosted.org/packages/f4/70/e9f80dcbddfc131704d381fd3dc7822a1652765a1b88326a8d84bdc44738/pytest-random-order-1.0.4.tar.gz"
    sha256 "6b2159342a4c8c10855bc4fc6d65ee890fc614cb2b4ff688979b008a82a0ff52"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "types-dataclasses" do
    url "https://files.pythonhosted.org/packages/0d/9c/f9447132aa0b9056d41e781b2f9f32b8a4092bf358634a4ea9bf225b4b34/types-dataclasses-0.1.5.tar.gz"
    sha256 "7b5f4099fb21c209f2df3a83c2b64308c29955769d610a457244dc0eebe1cafc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/58/0d/af54f4732115a20c370f43f179523d189a5cb75711c60ba00b41e163a065/websocket-client-1.1.0.tar.gz"
    sha256 "b68e4959d704768fa20e35c9d508c8dc2bbc041fd8d267c0d7345cffe2824568"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/e3/bd/a49e5f756b2f29010b5be321fe02478660dbf8fefea3f078493c86011b5f/Werkzeug-2.0.1.tar.gz"
    sha256 "1de1db30d010ff1af14a009224ec49ab2329ad2cde454c8a708130642d579c42"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/cfn"
  end

  def caveats
    <<~EOS
      cloudformation java, go, python plugins are installed, but the Go and Java are not bundled with the installation.
    EOS
  end

  test do
    script = (testpath/"test.sh")
    script.write <<~EOS
      #!/usr/bin/env expect -f
      set timeout -1

      spawn #{bin}/cfn init

      expect -exact "Do you want to develop a new resource(r) or a module(m)?."
      send -- "r\r"

      expect -exact "What's the name of your resource type?"
      send -- "brew::formula::test\r"

      expect -exact "Select a language for code generation:"
      send -- "1\r"

      expect -exact "Enter the GO Import path"
      send -- "example\r"

      expect -exact "Initialized a new project in"
      expect eof
    EOS

    script.chmod 0700
    system "./test.sh"

    rpdk_config = JSON.parse(File.read(testpath/".rpdk-config"))
    assert_equal "brew::formula::test", rpdk_config["typeName"]
    assert_equal "go", rpdk_config["language"]
    assert_predicate testpath/"rpdk.log", :exist?
  end
end
