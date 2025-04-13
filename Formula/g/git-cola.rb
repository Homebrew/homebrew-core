class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/8e/fc/e8f90350ac7a07fac83877963793dd372611e0c6b459ce71227847aa6594/git_cola-4.12.0.tar.gz"
  sha256 "e87ae8fedbd7b58d0929f48edb80e09bd14d554624b2d6c27caf001e08c5c0f4"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4190d6a926a2b45de30f7c45e185de3923289c1e9df4122aa132e20eddd58a1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4190d6a926a2b45de30f7c45e185de3923289c1e9df4122aa132e20eddd58a1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "625a74350e8052f7ba9c65ebde06318bbbe3fb906ae23e356cf8ac60b4301e9d"
    sha256 cellar: :any_skip_relocation, ventura:       "625a74350e8052f7ba9c65ebde06318bbbe3fb906ae23e356cf8ac60b4301e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4190d6a926a2b45de30f7c45e185de3923289c1e9df4122aa132e20eddd58a1e"
  end

  depends_on "pyqt"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
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
