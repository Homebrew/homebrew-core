class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/f7/25/e8ad047efd873e07139f703b681017fa0c3326540cc4f42b02e1a237a3b0/pyqt_builder-1.19.0.tar.gz"
  sha256 "79540e001c476bc050180db00fffcb1e9fa74544d95c148e48ad6117e49d6ea2"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecfcd5b57f733f4ed32dea12d7826bea613bb2da1109ebcded9c15e27a16599b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecfcd5b57f733f4ed32dea12d7826bea613bb2da1109ebcded9c15e27a16599b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecfcd5b57f733f4ed32dea12d7826bea613bb2da1109ebcded9c15e27a16599b"
    sha256 cellar: :any_skip_relocation, sonoma:        "30112f1fa107c03b9b474b41fee3ae63a1932905e7c9c355281e4068455b6f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30112f1fa107c03b9b474b41fee3ae63a1932905e7c9c355281e4068455b6f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30112f1fa107c03b9b474b41fee3ae63a1932905e7c9c355281e4068455b6f8a"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/a7/8a/869417bc2ea45a29bc6ed4ee82757e472f0c7490cf5b7ddb82b70806bce4/sip-6.14.0.tar.gz"
    sha256 "20c086aba387707b34cf47fd96d1a978d01e2b95807e86f8aaa960081f163b28"
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
