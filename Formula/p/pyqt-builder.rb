class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/61/f6/f3b504b4d55a7c4d3393cb90378501f1f5fc7f233bd85c0375674f84d2af/pyqt_builder-1.19.1.tar.gz"
  sha256 "6af6646ba29668751b039bfdced51642cb510e300796b58a4d68b7f956a024d8"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a9cedbc925b2eb0084510ec10953c83495eb8240477a8c70855bdf72dcbb2cd4"
  end

  depends_on "python@3.14"

  pypi_packages extra_packages: "platformdirs"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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

    # Replace vendored platformdirs with latest version for easier relocation
    # https://github.com/pypa/setuptools/pull/5076
    venv.site_packages.glob("setuptools/_vendor/platformdirs*").map(&:rmtree)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end
