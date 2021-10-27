class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/63/9b/e7cd8c57cd38df3bf8e95750257f10703dcab15ef9050c0dc03259746e87/PyQt-builder-1.12.1.tar.gz"
  sha256 "9a71e9cac134702467bd93ed9c7a5a47dc4386d93501bdcafb14cd08b3041d40"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69be0f6a07ae789013bf4c9656583b98716028971e9c27b38306d8f701e4c504"
  end

  depends_on "python@3.9"
  depends_on "sip"

  def install
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import pyqtbuild"
  end
end
