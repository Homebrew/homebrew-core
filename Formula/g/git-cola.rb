class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/9b/28/490fa1db84c7d3a791005eab93f1f8ae94cb3c5d0e4410c51805b279aa58/git_cola-4.20.0.tar.gz"
  sha256 "cd0f40e7cdda4695f89b24e099ccaa5387850e8512db338cdea34b5f4d26e47b"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    manifest_sha256 "36f290d256e24be1e3709fc2738b3f14d382c3d942ff7cec137ab6b2bc0cec89"
    sha256 cellar: :any_skip_relocation, all: "df665613486bfd95e76bc52143da80e1a78a41f2c540fef475b39afb1bafb0c3"
  end

  depends_on "git-gui"
  depends_on "pyqt"
  depends_on "python@3.15"

  on_linux do
    depends_on "qtwayland" => :no_linkage
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
