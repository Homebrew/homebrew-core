class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/ac/71/48b7fde78ef09f4636a9b81f926b879d0230f90768483c441f22059d2474/autopep8-2.0.0.tar.gz"
  sha256 "8b1659c7f003e693199f52caffdc06585bb0716900bbc6a7442fd931d658c077"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cc4ff496812ae293c8d18e1b7967d3fc12bacabc3082b29d483e00671c5cdbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb1048b7bfa074a81ab0bdf9132509e665d08f70b72907818af9d90c58156c17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42351a6b5de6406c45724741fd28b136be2796803f00753519a80aaa9a1b4e30"
    sha256 cellar: :any_skip_relocation, ventura:        "b48928d4f1c8b842c1c2bfa6b5920d1bea99aac713de5298fbc29ee985e2b93a"
    sha256 cellar: :any_skip_relocation, monterey:       "69dee754220183cf4a7dbd3a61d6b39de2365f24bf5243947891662989433635"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f519448f3ecb2180fa46a0fa54cc3f1452f463eeb730705333fa1767772ba3"
    sha256 cellar: :any_skip_relocation, catalina:       "ce802ecd6af14a892fab7425add9770f42eb69990c6dff60e272e5dd9727bfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "465eec33e79530380981c883cc224d68b46636142d15c3b398bc17e2cbfd207d"
  end

  depends_on "python@3.11"

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
