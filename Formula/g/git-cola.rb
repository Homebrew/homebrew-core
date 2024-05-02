class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/28/af/8738ca984d5d5ec18a72fc7d950936d01ca3c186482bf05f11800e178bc0/git-cola-4.7.0.tar.gz"
  sha256 "d201ca0917b9bae5404bac5e6b4c74a87a500b4d2864ca3b82f82b97530b1f28"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95be1f82aa96bde73acd01938cd1ea4bc773863ef63efef35497f373db00abdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95be1f82aa96bde73acd01938cd1ea4bc773863ef63efef35497f373db00abdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95be1f82aa96bde73acd01938cd1ea4bc773863ef63efef35497f373db00abdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7ecaa1f537f602de00e7634273479e4d3c367004a0d11536038693800e4136d"
    sha256 cellar: :any_skip_relocation, ventura:        "f7ecaa1f537f602de00e7634273479e4d3c367004a0d11536038693800e4136d"
    sha256 cellar: :any_skip_relocation, monterey:       "f7ecaa1f537f602de00e7634273479e4d3c367004a0d11536038693800e4136d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4f4960c1565915be6d166c144089899a1e7899d4c1734fac18921969e69fea8"
  end

  depends_on "pyqt"
  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "polib" do
    url "https://files.pythonhosted.org/packages/10/9a/79b1067d27e38ddf84fe7da6ec516f1743f31f752c6122193e7bce38bdbf/polib-1.2.0.tar.gz"
    sha256 "f3ef94aefed6e183e342a8a269ae1fc4742ba193186ad76f175938621dbfc26b"
  end

  resource "qtpy" do
    url "https://files.pythonhosted.org/packages/eb/9a/7ce646daefb2f85bf5b9c8ac461508b58fa5dcad6d40db476187fafd0148/QtPy-2.4.1.tar.gz"
    sha256 "a5a15ffd519550a1361bdc56ffc07fda56a6af7292f17c7b395d4083af632987"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
