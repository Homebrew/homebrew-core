class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/2b/36/e0b701f84ab469d0baab0f8973f51deca78224ff08c8dcf454ae926936a6/pyqt_builder-1.17.2.tar.gz"
  sha256 "cef9e06ab78c147235a5e4691e6257c963e93c2235fe3db1fe38c92f11977596"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4842d3137184bc928a3b4631004c741bf1fdc1a52ac66448b874ae3822ba6312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4842d3137184bc928a3b4631004c741bf1fdc1a52ac66448b874ae3822ba6312"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4842d3137184bc928a3b4631004c741bf1fdc1a52ac66448b874ae3822ba6312"
    sha256 cellar: :any_skip_relocation, sonoma:        "83407190b81b2792df81d51cbc4d1fd073835170071b95c5a245413f69944983"
    sha256 cellar: :any_skip_relocation, ventura:       "83407190b81b2792df81d51cbc4d1fd073835170071b95c5a245413f69944983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be5e341bd73f0d092e4120eb255ddb5a77de27546407321c5ce219cab0166aa7"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/e2/83/b23f610ef99fa23aa3c8dcd2ff8536c37b943654405ff4f45f3230327a40/sip-6.9.1.tar.gz"
    sha256 "7904be5190d7879952563b78a3af0e58fa27d9525af7f53f93eac7a83b433e7b"
  end

  def python3
    "python3.13"
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
