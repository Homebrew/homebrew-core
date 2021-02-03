class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https://github.com/aws-cloudformation/cloudformation-cli/"
  url "https://files.pythonhosted.org/packages/5f/95/a251aeae2aa738ea1d37e8595883e221159e06c1f5d437f77ee9a91e7c2e/cloudformation-cli-0.2.2.tar.gz"
  sha256 "82b32d1b025c9d6bc7c1e620f2cd50c4f73a0c058e1b20810c6cca618d230267"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3f86030a3ceb6a880f07786b7d90c7cd58485d9ba8cfcfe608df9601c53e89fa"
    sha256 cellar: :any_skip_relocation, catalina: "460250e36ebadd2328be0e18d4af8b486cef2b748fa13e346dfeb65b5414e41f"
    sha256 cellar: :any_skip_relocation, mojave:   "15f391b0d0b2932e7d736fe6c89ddfa410a11207f3ec04aaa51cf6901039f040"
  end

  depends_on "go" => :test
  depends_on "python@3.9"

  uses_from_macos "expect" => :test

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/e1/78/c1b9a8c89aa1a21b07823c6363cc1eefd2c08fc193ba9ffddcc6e8fd0294/aws-sam-translator-1.33.0.tar.gz"
    sha256 "9f3767614746a38300ee988ef70d6f862e71e59ea536252bbf9a319daaac1fff"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/34/19/1be08abab2ceda573cbad247cf4474a6ae53c518829181d0fe9c9e64ba40/boto3-1.16.61.tar.gz"
    sha256 "38f503f0502aba4251dff4d19057c31a7b9dd0f54333df5521f8931ee4c65e26"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1c/cd/772b9dd430d172a58c4f64c7a6823ad7aa37b3489f3120139a87e11622d9/botocore-1.19.61.tar.gz"
    sha256 "3245c9e996143bcfdea73d105145ca733fcd7d5afe744a8760612fc449c3f810"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/df/54/ff7f33dff0a7ed9829a0a59b1bfb06b31ef0b10c8e74f6210fa56a23e343/cfn-lint-0.44.5.tar.gz"
    sha256 "6889c171eb2bbbe9e175149d8bada8ae627137748c42b04581e79469dc6b35e7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "cloudformation-cli-go-plugin" do
    url "https://files.pythonhosted.org/packages/8f/00/909410b531a330f3f8a784862dd0daf12541a99a969555e2b3c7af892ec7/cloudformation-cli-go-plugin-2.0.4.tar.gz"
    sha256 "2b6bc4eaa89b7c055a91b86ec957ef765b0c8a43f5af3c4fa916e2d4d3fd03d6"
  end

  resource "cloudformation-cli-java-plugin" do
    url "https://files.pythonhosted.org/packages/37/42/9649aa7b20b7d927590f2d2226fa06f3c11a2faf974e575810ecc5afd453/cloudformation-cli-java-plugin-2.0.3.tar.gz"
    sha256 "cc9bf7d55bca90bbed405971f016db4f5e6325856d2902f5aa5f768fe26ded5a"
  end

  resource "cloudformation-cli-python-plugin" do
    url "https://files.pythonhosted.org/packages/be/f8/5ac37c521a05e7aed5b5a24c9f12197d689a1497cc06073596a7a7f80765/cloudformation-cli-python-plugin-2.1.2.tar.gz"
    sha256 "a027f0afce3b014ebd5049d195c6da4867c08db9184b64e2c9a3f51f59cef575"
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
    url "https://files.pythonhosted.org/packages/0e/38/2fcfff66ca99b20eaed9a29f2be6400cb7407f80d35decc6331c3abf6351/docker-4.4.1.tar.gz"
    sha256 "0604a74719d5d2de438753934b755bfcda6f62f49b8e4b30969a4b0a2a8a1220"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/37/07/eb38c67ba359b306dfbc5d680ee267f343c6b705980444754465c9cb4b3a/hypothesis-6.0.4.tar.gz"
    sha256 "f13662cfe7131cba67abbdb38e935ad4a3f4ad3b4aa4c7ed49df1cb15be94a67"
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
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/4f/42/c171c0090a5cd8e4b59515b35ac0bcc1a097481a738cadccdaf7aff87094/jsonpatch-1.28.tar.gz"
    sha256 "e930adc932e4d36087dbbf0f22e1ded32185dfb20662f2e3dd848677a5295a14"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f/jsonpointer-2.0.tar.gz"
    sha256 "c192ba86648e05fdae4f08a17ec25180a9aef5008d973407b581798a83975362"
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
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/ef/d0/f706a9e5814a42c544fa1b2876fc33e5d17e1f2c92a5361776632c4f41ab/networkx-2.5.tar.gz"
    sha256 "7978955423fbc9639c10498878be59caf99b44dc304c2286162fd24b458c1602"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/f5/ab/8252360bfe965bba31ec05112b3067bd129ce4800d89e0b85613bc6044f6/ordered-set-4.0.2.tar.gz"
    sha256 "ba93b2df055bca202116ec44b9bead3df33ea63a7d5827ff8e16738b97f33a95"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/c5/e81b9fb8033fe78a2355ea7b1774338e1dca2c9cbd2ee140211a9e6291ab/packaging-20.8.tar.gz"
    sha256 "78598185a7008a470d64526a8059de9aaa449238f280fc9eb6b13ba6c4109093"
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
    url "https://files.pythonhosted.org/packages/d1/80/b4f47a1f933699cd531a7b336a6f3d82912e3e5e66e4a3bb1d8f0d1d98b0/pytest-6.2.2.tar.gz"
    sha256 "9d1edf9e7d0b84d72ea3dbcdfd22b35fb543a5e8f2a60092dd578936bf63d7f9"
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
    url "https://files.pythonhosted.org/packages/08/e1/3ee2096ebaeeb8c186d20ed16c8faf4a503913e5c9a0e14cd6b8ffc405a3/s3transfer-0.3.4.tar.gz"
    sha256 "7fdddb4f22275cf1d32129e21f056337fd2a80b6ccef1664528145b72c49e6d2"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/14/10/6a9481890bae97da9edd6e737c9c3dec6aea3fc2fa53b0934037b35c89ea/sortedcontainers-2.3.0.tar.gz"
    sha256 "59cc937650cf60d677c16775597c89a960658a09cf7c1a668f86e1e4464b10a1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/8b/0f/52de51b9b450ed52694208ab952d5af6ebbcbce7f166a48784095d930d8c/websocket_client-0.57.0.tar.gz"
    sha256 "d735b91d6d1692a6a181f2a8c9e0238e5f6373356f561bb9dc4c7af36f452010"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
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
      send -- "\r"

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
