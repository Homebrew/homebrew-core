class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/37/3f/a55dda1be5ff8bf426f5d6c649eff87fbca151cff611b165a10b7ae00924/pyqt_builder-1.18.0.tar.gz"
  sha256 "ce9930aafc1ce0af928a6944bcc80ecf78c23ffdcad6ac111306c4c71057848e"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca96498596f7feeb7eb6bd887b4283681d1594c82d03945ceb86ab3bce4eb502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca96498596f7feeb7eb6bd887b4283681d1594c82d03945ceb86ab3bce4eb502"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca96498596f7feeb7eb6bd887b4283681d1594c82d03945ceb86ab3bce4eb502"
    sha256 cellar: :any_skip_relocation, sonoma:        "393586c6865045e2f430d9e84a091eef39d517e18b88bb57c5b2613a29d50148"
    sha256 cellar: :any_skip_relocation, ventura:       "393586c6865045e2f430d9e84a091eef39d517e18b88bb57c5b2613a29d50148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "973ff057325b6ab58dcfa3b7f32c779edb7797781947d1d7813da5421f699d49"
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
    url "https://files.pythonhosted.org/packages/62/9a/78122735697dbfc6c1db363627309eb0da7e44d8c05ba017b08666530586/sip-6.10.0.tar.gz"
    sha256 "fa0515697d4c98dbe04d9e898d816de1427e5b9ae5d0e152169109fd21f5d29c"
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
