class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/e6/f5/daead7fd8ef3675ce55f4ef66dbe3287b0bdd74315f6b5a57718a020570b/pyqt_builder-1.16.4.tar.gz"
  sha256 "4515e41ae379be2e54f88a89ecf47cd6e4cac43e862c4abfde18389c2666afdf"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5043f2f1d35d5a4cb0225184869464fa99c9b4f59a5e9b0c40b9ecc56e7f38cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5043f2f1d35d5a4cb0225184869464fa99c9b4f59a5e9b0c40b9ecc56e7f38cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5043f2f1d35d5a4cb0225184869464fa99c9b4f59a5e9b0c40b9ecc56e7f38cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0f23d71c7e6d76163f3fd067407c99abf4ecea11ffabcb13fb83cc0ee471a8"
    sha256 cellar: :any_skip_relocation, ventura:       "fd0f23d71c7e6d76163f3fd067407c99abf4ecea11ffabcb13fb83cc0ee471a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b7fc6031ad34bc6bdb55d1d20bea08cf89321779a7adb6e003cc0bb36dc2dd3"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/6e/52/36987b182711104d5e9f8831dd989085b1241fc627829c36ddf81640c372/sip-6.8.6.tar.gz"
    sha256 "7fc959e48e6ec5d5af8bd026f69f5e24d08b3cb8abb342176f5ab8030cc07d7a"
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
