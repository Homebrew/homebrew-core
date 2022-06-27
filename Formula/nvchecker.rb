class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/c2/71/13c7c02602489b6187aca3bf833f577afc1e10501a3b394f8de5cf4f6ccb/nvchecker-2.9.tar.gz"
  sha256 "bd627a6a50745b1855062ba8b1a6fdd119c98d2b861de9a5461523f6b46b7315"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91ea1dbd8ebd40b06990b3dc5fb12422aedc1ff503b22d9308672145b1f1bff2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a1366a7be20680f4bbd8cd9f51d3347d9785b393a92fc88879050c463e73ba0"
    sha256 cellar: :any_skip_relocation, monterey:       "6f1b25e837dcd6c34562b8f503ebd035662cac74c5fe1a769e2e6ca89b576d3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdae888f2840f60947dd5d0a964019405fc3a19cfe9e8fc2f2d7b5089ceeb02e"
    sha256 cellar: :any_skip_relocation, catalina:       "b0a4f98e1736e4185f35706418c266659ba7290c2b2636634e2bb0f1b8c20291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbad5191e70162cc80eeb1856f08f538a9df174c473351a7311df8ece484b313"
  end

  depends_on "jq" => [:test]
  depends_on "python@3.10"

  uses_from_macos "curl"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/09/ca/0b6da1d0f391acb8991ac6fdf8823ed9cf4c19680d4f378ab1727f90bd5c/pycurl-7.45.1.tar.gz"
    sha256 "a863ad18ff478f5545924057887cdae422e1b2746e41674615f687498ea5b88a"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/ea/77/e38019e698b0c0134f903ab40e87f0975813ca7f74dad287272788134f03/structlog-21.5.0.tar.gz"
    sha256 "68c4c29c003714fe86834f347cb107452847ba52414390a7ee583472bde00fc9"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
