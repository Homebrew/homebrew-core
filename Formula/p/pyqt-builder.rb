class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/01/3d/eae24a561b731624ed44dc5d0f047e1b14d22497ac602e9739a8cb416561/pyqt_builder-1.20.1.tar.gz"
  sha256 "b303cd9ec7a04100ecb66fcbcae432c409e22a98153249bf504db5900a361de3"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "040fc892c10a078eefc1ae6b07fb80182aea4ae51df63396bbc96d3d3e745a97"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/0d/d6/4108ef066e4a8452b393d5acd03fed176d7178c0512b2ecf564dc8dcf796/sip-6.17.1.tar.gz"
    sha256 "34e2c1389e25394f5ba3c6b9d999d04373baf8d7161410536d444f48226d2f50"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{python3}\""
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end
