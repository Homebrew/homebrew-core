class PyqtBuilder < Formula
  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/c0/75/a3384eea8770c17e77821368618a5140c4ae0c37f9c05a84ef55f4807172/PyQt-builder-1.15.4.tar.gz"
  sha256 "39f8c75db17d9ce17cb6bbf3df1650b5cebc1ea4e5bd73843d21cc96612b2ae1"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
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
  depends_on "sip"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system python3, "-c", "import pyqtbuild"
  end
end
