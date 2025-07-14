class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/4f/62/2a866a1570e677b55080d41056bad3234b17919c467d058a6f37489e3501/git_cola-4.13.0.tar.gz"
  sha256 "b86d864ef8e12d51e4381e848ee3835002a7559d2b8435ab70feb9be8f3b2cff"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49f8f56b4d1035b4f68ca5f1513bd1b6b472439909656cb42ac4953c95bdda4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49f8f56b4d1035b4f68ca5f1513bd1b6b472439909656cb42ac4953c95bdda4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "94aa95d3358e77d93b041eacb290349adbe7e06ed9415da0d770cd7f41cf8391"
    sha256 cellar: :any_skip_relocation, ventura:       "94aa95d3358e77d93b041eacb290349adbe7e06ed9415da0d770cd7f41cf8391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49f8f56b4d1035b4f68ca5f1513bd1b6b472439909656cb42ac4953c95bdda4b"
  end

  depends_on "git-gui"
  depends_on "pyqt"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
