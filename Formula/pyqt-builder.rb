class PyqtBuilder < Formula
  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/31/d7/dbcb710a205014ca8f1c651ed77e6f1b1d0c67ab43c664afb079d6efb658/PyQt-builder-1.15.1.tar.gz"
  sha256 "a2bd3cfbf952e959141dfe55b44b451aa945ca8916d1b773850bb2f9c0fa2985"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7eaab02f463e5c18d8cd01f1fb9192b6077ca823d35cef3158138c25af2b512a"
  end

  depends_on "python@3.11"
  depends_on "sip"

  def python3
    "python3.11"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  def install
    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system python3, "-c", "import pyqtbuild"
  end
end
