class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https://cyclonedx.org/"
  url "https://files.pythonhosted.org/packages/6a/4f/e2e935ecb9e840685aea2abe68c7aa4ff76d30b828a961752c40959254c2/cyclonedx_bom-3.11.2.tar.gz"
  sha256 "b0c2beab3364ded549e3b386d5f8e973ba89b8306b755e905fd7a62439ba37e0"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-python.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e25ad965b04ccf89ac022c2b44cd8effeceed1bf9cb11ae3fe415c5bb049bc63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b58411690311377f4806a751dd3ec3497e18dabdf3046d779ec48c38f7a1ade3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a968214dd12da93ee4f348629185621cf66e94b2e9a60f861faf34490cee054"
    sha256 cellar: :any_skip_relocation, ventura:        "dd517526170f005c96578da35079de5037de26fa75f1d2036d836f426b991f91"
    sha256 cellar: :any_skip_relocation, monterey:       "016d7a360369693bbd6b523d4573eded5774f02348ad6594fb297e723bad6cf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "25fea92301ae722f2bdcb970c29e407811ae871790496dff182c55ea09ec4248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c705d570f9a8fcb6c8de2c05eaa5bc9ac234d50629f248317d76c21c3b2f86e1"
  end

  depends_on "python-packaging"
  depends_on "python-toml"
  depends_on "python@3.11"

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/dd/0d/2d77978ff3ebe445c00ffc209eb205d126ef7a8ece69e7f3d014e561bada/cyclonedx_python_lib-3.1.5.tar.gz"
    sha256 "1ccd482024a30b95c4fffb3fe567a9df97b705f34c1075f8abde8537867600c3"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/33/34/a7843f732e1e0b01e961f6ae835b3fd6bd4e361c1a3a72debd31244cb718/packageurl-python-0.11.2.tar.gz"
    sha256 "01fbf74a41ef85cf413f1ede529a1411f658bda66ed22d45d27280ad9ceba471"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/5e/2a/63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54/pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"requirements.txt").write <<~EOS
      requests==2.31.0
    EOS
    system bin/"cyclonedx-py", "-r", "-i", testpath/"requirements.txt"
    assert_match "pkg:pypi/requests@2.31.0", (testpath/"cyclonedx.xml").read
  end
end
