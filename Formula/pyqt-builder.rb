class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/12/29/af52add4755b7dbce928fe3df1b86a48d5c8bcd06e3333bf8f69ad19c1a5/PyQt-builder-1.10.0.tar.gz"
  sha256 "86bd19fde83d92beaefacdeac1e26c6e1918c300ff78d7ec2a19973bf2cf21b5"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0930178ad00344b2049292aeb8c4b01bca38e548fbc51be84b27b1deec5c3bb1"
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
