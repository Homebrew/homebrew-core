class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/62/fd/e74d789fa6ca10be33f2d782a96482a4bcf0104c9287bac151f3062d3984/PyQt-builder-1.11.0.tar.gz"
  sha256 "40f6df88c00e6aa9ac9a8bc5688f9fe2a4bd56c06cdb0a0b00ce8955ec34ffe5"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4bf0bfe85d4757efb26a251811caff5ee7223da6174ee8e457c42d6d31219aff"
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
