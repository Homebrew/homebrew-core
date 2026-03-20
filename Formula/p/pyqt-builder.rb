class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/61/f6/f3b504b4d55a7c4d3393cb90378501f1f5fc7f233bd85c0375674f84d2af/pyqt_builder-1.19.1.tar.gz"
  sha256 "6af6646ba29668751b039bfdced51642cb510e300796b58a4d68b7f956a024d8"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "8f4c0bd1e4b26ea418de6e45ccdf8c71e80d95f357c73bcce0b48a3d6519976b"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/82/f3/748f4d6f65d1756b9ae577f329c951cda23fb900e4de9f70900ced962085/setuptools-82.0.0.tar.gz"
    sha256 "22e0a2d69474c6ae4feb01951cb69d515ed23728cf96d05513d36e42b62b37cb"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/8e/3d/4245885c0480230d4bc389c6165c841546bf43c1e780fd77995caf5ad7b8/sip-6.15.1.tar.gz"
    sha256 "dc2e58c1798a74e1b31c28e837339822fe8fa55288ae30e8986eb28100ebca5a"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end
