class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/0b/0a/e7684c054c3b85999354bb3be7ccbd6e6d9b751940cec8ecff5e7a8ea9f7/pyqt_builder-1.18.1.tar.gz"
  sha256 "3f7a3a2715947a293a97530a76fd59f1309fcb8e57a5830f45c79fe7249b3998"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5591035e0e903e2c6c628105abd0f2a4e35fbf23d9da415a0c7f9f0522602517"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5591035e0e903e2c6c628105abd0f2a4e35fbf23d9da415a0c7f9f0522602517"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5591035e0e903e2c6c628105abd0f2a4e35fbf23d9da415a0c7f9f0522602517"
    sha256 cellar: :any_skip_relocation, sonoma:        "7592ce5a7b68fadabf2660c09f2f895ed264d83ff822cfaaa14bc2479222d227"
    sha256 cellar: :any_skip_relocation, ventura:       "7592ce5a7b68fadabf2660c09f2f895ed264d83ff822cfaaa14bc2479222d227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "697a182e104921d51f042edcb6b9fa3ced6510ee6e7fd874ecc6bf294c3b301d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6626acbdf3949d211cec6b10036c95ca58f17289dd941b628306a289b0daaa"
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
