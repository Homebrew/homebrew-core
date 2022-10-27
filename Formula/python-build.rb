class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/0f/61/aaf43fbb36cc4308be8ac8088f52db9622b0dbf1f0880c1016ae6aa03f46/build-0.9.0.tar.gz"
  sha256 "1a07724e891cbd898923145eb7752ee7653674c511378eb9c7691aab1612bc3c"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00925e1e78d04e1dea1ade5e4d282aa6a6d21a78e437f333fbc5424daba95956"
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
    url "https://files.pythonhosted.org/packages/4d/19/e11fcc88288f68ae48e3aa9cf5a6fd092a88e629cb723465666c44d487a0/pep517-0.13.0.tar.gz"
    sha256 "ae69927c5c172be1add9203726d4b84cf3ebad1edcd5f71fcdc746e66e829f59"
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
