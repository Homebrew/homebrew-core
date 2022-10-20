class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/c2/71/13c7c02602489b6187aca3bf833f577afc1e10501a3b394f8de5cf4f6ccb/nvchecker-2.9.tar.gz"
  sha256 "bd627a6a50745b1855062ba8b1a6fdd119c98d2b861de9a5461523f6b46b7315"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaddc33f8b586c5a71ce5b5def95beec612fc957610881e9e6f8406817d8f5f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69400f6ffa23e2b53d6e701bf64f8355d547defae3dd5e5166594fb770a7a57f"
    sha256 cellar: :any_skip_relocation, monterey:       "87efd4e01a3bf96b986496f6bedb2a59aeb0463e67746c3a7bba112f8b1f64a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "baa4683847d97af85cab0afd9db80401b6f5ea4689d515b3c855741f79371c4d"
    sha256 cellar: :any_skip_relocation, catalina:       "b31b07f1b48179695b5a968c45dfa206a6107d94a348cc3e6a621d916ff9c275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c12b219b83dee3a013d0d9947860de27e6399f6fb12d2b6563fb3e294d9233d8"
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
