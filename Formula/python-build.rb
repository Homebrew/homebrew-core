class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/52/fa/931038182be739955cf83179d9b9a6ce9832bc5f9a917a006f765cb53a1f/build-0.8.0.tar.gz"
  sha256 "887a6d471c901b1a6e6574ebaeeebb45e5269a79d095fe9a8f88d6614ed2e5f0"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

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
