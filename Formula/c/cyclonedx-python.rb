class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https://cyclonedx.org/"
  url "https://files.pythonhosted.org/packages/6a/4f/e2e935ecb9e840685aea2abe68c7aa4ff76d30b828a961752c40959254c2/cyclonedx_bom-3.11.2.tar.gz"
  sha256 "b0c2beab3364ded549e3b386d5f8e973ba89b8306b755e905fd7a62439ba37e0"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-python.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "565ed90543463f1575379f0eb0ff6d8b60eaccdbfc07bd482aab8bb5c5130592"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4e257344cdb0c8e9889aa7e71d98c55aeb335ffc15cf0e4a762bf7301492c47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfef3d9ebf5a8713049bdeebe75e68fe3868b4be4ca6b36491a020612b7f4fcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a3dc2a4840de37498ca59e41edf6e73a3e685c4af417436c03865309858970d"
    sha256 cellar: :any_skip_relocation, ventura:        "2fc7d6eb13df6ac986cbdffc20d47825189158b7e4ade5af2fde0af1ec449c04"
    sha256 cellar: :any_skip_relocation, monterey:       "c93432437bf7b9756cd6a1531672e802bd3780ffcbfefc865c3a3f2724e24904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f309c509a45e7c4902fe6fa183c4d3a3bc30cd8a4ce97d0218f2947f2781ac"
  end

  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python-toml"
  depends_on "python@3.12"

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
