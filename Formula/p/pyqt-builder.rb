class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c0/75/a3384eea8770c17e77821368618a5140c4ae0c37f9c05a84ef55f4807172/PyQt-builder-1.15.4.tar.gz"
  sha256 "39f8c75db17d9ce17cb6bbf3df1650b5cebc1ea4e5bd73843d21cc96612b2ae1"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb9cb2df20660795abfd6ea2e89f23bf798d3f18431f50dfc7c1572def2f3511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "744a018fc9c00e74ffbb29ddcd3d037f15523c0c4c49414605570045cf5e18f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf53c0b52cfff8b06c2f678f3434fccc0f2e84014cf3778b22b4222c94d5849a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca71b526c655474b71220c684372d27ef64db07bf0d8728379b4ed4566996cf0"
    sha256 cellar: :any_skip_relocation, ventura:        "339f953ca98cb45b6857d62e3c5a019841851c6a7fa1532c5e5035a99284916f"
    sha256 cellar: :any_skip_relocation, monterey:       "5331dc9bbb738ff55b5c1d3e339170e6f82d458bfe3d5abf48f323a24a26c99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aeb1c3c1861d60289011c9b1dc52cce5fd8cc6c68bd7b977fcbc2c80787be87"
  end

  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/99/85/261c41cc709f65d5b87669f42e502d05cc544c24884121bc594ab0329d8e/sip-6.8.3.tar.gz"
    sha256 "888547b018bb24c36aded519e93d3e513d4c6aa0ba55b7cc1affbd45cf10762c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    system bin/"pyqt-bundle", "-V"
    system python3, "-c", "import pyqtbuild"
  end
end
