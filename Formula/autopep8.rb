class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/ac/71/48b7fde78ef09f4636a9b81f926b879d0230f90768483c441f22059d2474/autopep8-2.0.0.tar.gz"
  sha256 "8b1659c7f003e693199f52caffdc06585bb0716900bbc6a7442fd931d658c077"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbae921c00372cf55f7c72a1aeb4cd67b945f4c783bfc6d17fed2042019fbd2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c75c3811a89c6f770aec896c1f3ebfdbf0ad5a5744f6c306e45f74bbec46bda"
    sha256 cellar: :any_skip_relocation, monterey:       "bf24b27338cfba98c3f792fd5f7fdf62929af14eea4c98f3abfe94d328a05f79"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8a88093a9572b6e200f81abb6b6e3eaf36314b91043b62816f60f941a5e0881"
    sha256 cellar: :any_skip_relocation, catalina:       "f29dfc0c6f33f1f48a247dd034517f0b4abe95f050acd36e7882dcdc83e3b96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c64ed8b48e919ad03a614f1de66c20e74657ad9a7d423b7f550cebade874820"
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
