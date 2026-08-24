class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/98/79/6be8026bdc9340a278f0a7631c732f7bae1884e53f5dfaeb2798362d190b/git_cola-4.19.0.tar.gz"
  sha256 "8b85c50ecf1086c9664c79348a96cebd7dbb65054d53ea2b02e70d53cb7f0981"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59304aa1e231c16bf8f7a10409865cb70c1cbeacfa5ebaadbb4f90c5a6a1fe3b"
  end

  depends_on "git-gui"
  depends_on "pyqt"
  depends_on "python@3.14"

  on_linux do
    depends_on "qtwayland" => :no_linkage
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "polib" do
    url "https://files.pythonhosted.org/packages/10/9a/79b1067d27e38ddf84fe7da6ec516f1743f31f752c6122193e7bce38bdbf/polib-1.2.0.tar.gz"
    sha256 "f3ef94aefed6e183e342a8a269ae1fc4742ba193186ad76f175938621dbfc26b"
  end

  resource "qtpy" do
    url "https://files.pythonhosted.org/packages/70/01/392eba83c8e47b946b929d7c46e0f04b35e9671f8bb6fc36b6f7945b4de8/qtpy-2.4.3.tar.gz"
    sha256 "db744f7832e6d3da90568ba6ccbca3ee2b3b4a890c3d6fbbc63142f6e4cdf5bb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
