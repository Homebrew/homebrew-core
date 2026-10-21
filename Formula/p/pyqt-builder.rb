class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/42/90/0aed537919f08cc5bd96e0ad2dc280766f578785ce82a7fa0e6abd22ba17/pyqt_builder-1.20.0.tar.gz"
  sha256 "267ac1ee1593c67884f3c9cb6566f72a92ca28353050fc9d087433c28c74a889"
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
    url "https://files.pythonhosted.org/packages/ef/1e/2a8018d798af124d32fc9da01e8c97241d6a7c89ed1b64fbd5ff49f4df32/sip-6.17.0.tar.gz"
    sha256 "8c8839fb1fe87247cd315671c41897780b760aa76d01a6440f85c1fe76456bf4"
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
