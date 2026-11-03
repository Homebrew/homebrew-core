class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/b3/e7/f80f910dc39d8f87fd567ac22bc0921ed1c8950c4e898c2f6b3868f2c4c9/pyqt_builder-1.21.0.tar.gz"
  sha256 "673efa27237a81ffefc7d9a6419565600a129b4f4cf4d358c89a348b39b3a454"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a154e6a623e9b6dcc808c9e9e4440b9b79b9832be28145cd97d994dbbb3a1b4"
  end

  depends_on "python@3.15"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/c9/16/50c3758ae06375796dde6c94592f1bdd80a1ca709f776a09fd763682280d/sip-6.17.2.tar.gz"
    sha256 "f9e3e765b662b1a93a57440efd3f99a4001bf1bfe282fc0e24566d8d6122de3c"
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
