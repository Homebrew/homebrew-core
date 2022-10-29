class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/ac/71/48b7fde78ef09f4636a9b81f926b879d0230f90768483c441f22059d2474/autopep8-2.0.0.tar.gz"
  sha256 "8b1659c7f003e693199f52caffdc06585bb0716900bbc6a7442fd931d658c077"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41596d1c45b91be69063db961063e58c2c9db64c6ccd2e8c7ba5e0398b23dffe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01d5c7bd9988a870649fd6bd253aaa3b4fd693e591175e7db875c219a8496dcb"
    sha256 cellar: :any_skip_relocation, monterey:       "315f4be5941993ac14d0e071f965d495303c32501d902b4bbe7c413b6ef10c81"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d7baaa1bf940e81eece13d34d5384897a68130083c7595dc1a7be69603a3141"
    sha256 cellar: :any_skip_relocation, catalina:       "e9fa98f97abe4e576aa3e03630420c842a564bee099dd9da14cf42b543537a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34d61c8ea764eb9a98f3571cf74f2c21e2736a2735c5a115122a677244b956b0"
  end

  depends_on "python@3.10"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/b6/83/5bcaedba1f47200f0665ceb07bcb00e2be123192742ee0edfb66b600e5fd/pycodestyle-2.9.1.tar.gz"
    sha256 "2c9607871d58c76354b697b42f5d57e1ada7d261c261efac224b664affdc5785"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
