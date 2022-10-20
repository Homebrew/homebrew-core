class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/52/fa/931038182be739955cf83179d9b9a6ce9832bc5f9a917a006f765cb53a1f/build-0.8.0.tar.gz"
  sha256 "887a6d471c901b1a6e6574ebaeeebb45e5269a79d095fe9a8f88d6614ed2e5f0"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "610649cc03c756ee41fcb9f4cf554b81e650faabb2e6faa3bc71d75598b82d10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79ece43d227ab21d3fdb1b16a8c69f1c1b479fca33733cfa995b2a6120271199"
    sha256 cellar: :any_skip_relocation, monterey:       "ad1c8d2b82c17d4efaa10819a55386ceb263db6e6c8fdcb96e709e379d2294f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1878b5d3f65a160896710c5fc3b50e9f756086fa1a422e93bcdf3d94f074b6ca"
    sha256 cellar: :any_skip_relocation, catalina:       "04eb2448e4b6f7ccd8f581b1cd425c2eaca92e21627e230091c630b3400db3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51b5cfcf3acbbefc13ce3803c63b2fa1bd0fddb946e72659fb412fcad814713"
  end

  depends_on "python@3.10"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0a/65/6e656d49c679136edfba25f25791f45ffe1ea4ae2ec1c59fe9c35e061cd1/pep517-0.12.0.tar.gz"
    sha256 "931378d93d11b298cf511dd634cf5ea4cb249a28ef84160b3247ee9afb4e8ab0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    stable.stage do
      system "pyproject-build"
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end
