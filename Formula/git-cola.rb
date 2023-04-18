class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/1d/08/828a1ae7bf54452b3cd849f4b062f4089c63f3ee48cdc7b4a070277cdfd3/git-cola-4.2.1.tar.gz"
  sha256 "187fa9003d74a8fb3d110207b37c6bbe44043dafda06ce111e1922d0f0f06213"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "132fc9104b54d56fcbb3e6c05e8971487641dca460b189094a131b4c0595d04e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fbf971068f677d8689b2ea250f9904757b67ec6f24859b789f45498d67a2040"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fe3b8bdd3d8d7ac87b82686943ee84599d75b65b4a8c5e9e608102fad1099d6"
    sha256 cellar: :any_skip_relocation, ventura:        "44f3a73733e5e6de836969b2d050ca7c6c54d0fcbfb9ee863ce6208086988181"
    sha256 cellar: :any_skip_relocation, monterey:       "af93e14f3ed6e42f871d8f9110b49f1dd1e0340e39fd195dcfd40be7ae52c0dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "52acf5960546c38af6414804f0bd6de60bccefa2a093cd307a974bd02349812c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88fda1fe2446c397c6953fb574f740d3d3dfec76589a83b3a1cac4033fbeb8d1"
  end

  depends_on "pyqt@5"
  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/ad/6b/0e753af1197f82d2359c9aa91cef8abaaef4c547396ffdc71ea6a889e52c/QtPy-2.3.1.tar.gz"
    sha256 "a8c74982d6d172ce124d80cafd39653df78989683f760f2281ba91a6e7b9de8b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
