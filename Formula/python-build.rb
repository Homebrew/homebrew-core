class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/0f/61/aaf43fbb36cc4308be8ac8088f52db9622b0dbf1f0880c1016ae6aa03f46/build-0.9.0.tar.gz"
  sha256 "1a07724e891cbd898923145eb7752ee7653674c511378eb9c7691aab1612bc3c"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a21e7149828d16a64c9b1540b9c0dc989bddf1769843d78a74131ffeb36e0b2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4b0381d61627f33b73b1e21c3f89e745f80c616267ebfddfeb210d4024a678d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57ff356c76d3ecbb2d41ce71f8421d9853e0cdf9fe97d61780f70b31b055d452"
    sha256 cellar: :any_skip_relocation, ventura:        "6e01b3d27f694e49a168bb56e40176bd042ea3e8cce728974e7226cf59bff0c3"
    sha256 cellar: :any_skip_relocation, monterey:       "6f7fe9888547b102b7c0204c4439c2bd388329bff76d5be2398203ead2e8ced7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a7a0233a8b16c3aff04fc517ac46b0474ab9c75c0eefb7e56f4db804f4e7d99"
    sha256 cellar: :any_skip_relocation, catalina:       "3047c4c1f518addaab850e858ee2b59f39565a0ca701b4adb659d2e8b436feb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70dfe688fe0ca3c7851981d7c0bd93b8c4c18a62c9b63852eaea481beeab4e1f"
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
