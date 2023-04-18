class PyqtBuilder < Formula
  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/ee/37/06bc9491c7f84ca776658106a59d3064b1c4c7533a35d547e85fc1e8087f/PyQt-builder-1.15.0.tar.gz"
  sha256 "a90553703897eb41e27c2f1abd31fb9ed304c32ec3271b380015b54ea9762ddd"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7772094cf28276e7455e6a92b532f638b1e808b240892b5af2bd74bf6278c145"
  end

  depends_on "python@3.11"
  depends_on "sip"

  def python3
    "python3.11"
  end

  def install
    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system python3, "-c", "import pyqtbuild"
  end
end
