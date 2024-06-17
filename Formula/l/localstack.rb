class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/2c/72/0cd94b0d9f896012a494f57b04f55685e0192a0f4beb6380fc07b7720334/localstack-3.5.0.tar.gz"
  sha256 "79f0a1b9bc2d90f68cbbbb26286ba493554db0be908d480d6d0986d023ad8834"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c2c1976950816c2e03faf834d761062741e0ab5a4d73c2de2e70de607006407"
    sha256 cellar: :any,                 arm64_ventura:  "ad375b74eb57b375539447e5660b618ad35e76b398de1a9f23ee580aa5c18b68"
    sha256 cellar: :any,                 arm64_monterey: "662ed824c807bb506cbb2d1687116c96617acd6395c61ebc8aafc32a159d51cc"
    sha256 cellar: :any,                 sonoma:         "f5d9935b07fc75a83c1667b803fc853f0996742e2f76ca068f9a4fb1b4a5f183"
    sha256 cellar: :any,                 ventura:        "e5732f8a3849d6933639c8b82a5621e4f088c817368a28ad5fcbf8f76c67fe72"
    sha256 cellar: :any,                 monterey:       "878e2f2752cab39b7535dda259525c0894c2e466289a4a9f6b5bf2423a84ddf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf579a33268061d2d486692de98bfaedf38b60754fb35fbda44317f8a5c93d4"
  end

  depends_on "docker" => :test
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "build" do
    url "https://files.pythonhosted.org/packages/ce/9e/2d725d2f7729c6e79ca62aeb926492abbc06e25910dd30139d60a68bcb19/build-1.2.1.tar.gz"
    sha256 "526263f4870c26f26c433545579475377b2b7588b6f1eac76a001e873ae3e19d"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/b3/4d/27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5b/cachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "dnslib" do
    url "https://files.pythonhosted.org/packages/84/09/fb783ca757344c240425c17ffcfca9a0fe54fec9fca2f52d74cd09e82b54/dnslib-0.9.24.tar.gz"
    sha256 "ef167868a30d4ce7c90b921279d7ecfb986be8ebc530f3e6050a2ecb68707c76"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/5e/d0/ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051b/ecdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "localstack-core" do
    url "https://files.pythonhosted.org/packages/62/f7/b0035dcd2701ebb03d5ad5b70283c200df325f5d693085e4010be3aaa921/localstack_core-3.5.0.tar.gz"
    sha256 "f27cf7134aa1bafbfbbb2472e8d2ecf352e9dfb96081e1240242137106b86f36"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/72/6b/70cb8d49e41bf78a0344cc819b97731993070157311d22d952361259044a/localstack_ext-3.5.0.tar.gz"
    sha256 "b4936036a0b395e6db0ce3a091270e29a7f4e1b2d35488cff816858832e8fc6b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "plux" do
    url "https://files.pythonhosted.org/packages/c8/72/90289533aa31e2ff7a731ffc0caf6f5b5874a97d00a275b87d6c706ae653/plux-1.10.0.tar.gz"
    sha256 "08dd08953ae5e4fc9e230eeaa810b1d72bf019be44c6e9d5d8142cae3f2d49c5"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/c7/07/6f63dda440d4abb191b91dc383b472dae3dd9f37e4c1e4a5c3db150531c6/pyproject_hooks-1.1.0.tar.gz"
    sha256 "4b37730834edbd6bd37f26ece6b44802fb1c1ee2ece0e54ddff8bfc06db86965"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "python-jose" do
    url "https://files.pythonhosted.org/packages/e4/19/b2c86504116dc5f0635d29f802da858404d77d930a25633d2e86a64a35b3/python-jose-3.3.0.tar.gz"
    sha256 "55779b5e6ad599c6336191246e95eb2293a9ddebd555f796a65f838f07e5d78a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tailer" do
    url "https://files.pythonhosted.org/packages/dd/05/01de24d6393d6da0c27857c76b0f9ae97b42cd6102bbdf76cce95e031295/tailer-0.4.1.tar.gz"
    sha256 "78d60f23a1b8a2d32f400b3c8c06b01142ac7841b75d8a1efcb33515877ba531"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/localstack"
  end

  test do
    ENV["DOCKER_HOST"] = "unix://" + (testpath/"invalid.sock")
    ENV["LOCALSTACK_API_KEY"] = "brewtest"

    assert_match version.to_s, shell_output("#{bin}/localstack --version")

    output = shell_output("#{bin}/localstack start --docker 2>&1", 1)

    assert_match "License activation failed!", output
  end
end
