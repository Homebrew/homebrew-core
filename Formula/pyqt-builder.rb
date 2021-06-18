class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/00/a4/67939cced6487b1856dfda5cafa4e7eb179df917f4964918a202c8ba46d3/PyQt-builder-1.10.1.tar.gz"
  sha256 "967b0c7bac0331597e9f8c5b336660f173a9896830b721d6d025e14bde647e17"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e222c1e8f6070c918eef3af8c3ea4f1a48cc35047dccffd0c773bc194881700"
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
