class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/b8/c1/d12324a3c35588aefe82fcf1e77a936ecab8c60c42a31b691be3e432563b/git_cola-4.20.1.tar.gz"
  sha256 "f221f5d4be5fae19cdf413de502d381ff5ad5cea843bdf20da24ed8bf66296f4"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    manifest_sha256 "5d7fc0d3c8e62073e272d9440d93c5f35e3c04384cea541785ae23c08ad1b440"
    sha256 cellar: :any_skip_relocation, all: "69e95e92d5343af1676f1aebaf02d0a18391ae9ded3b7264c827217320289e00"
  end

  depends_on "git-gui"
  depends_on "pyqt"
  depends_on "python@3.15"

  on_linux do
    depends_on "qtwayland" => :no_linkage
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
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
