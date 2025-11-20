class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/45/ff/4af412351a21ee38835b7597555936c547830d9a8246a2b7d2aa41aabdd3/psutils-3.3.14.tar.gz"
  sha256 "6212167dd8c09f59c9535d5e416c4f8c01431b7a5beab0ee68f4ec416ca3980c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55b66a30b82f74cd6068fb5e8451b385b9b5a8cf51ce4631a464e6dad872587b"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/13/3d/b6ead84ee437444f96862beb68f9796da8c199793bed08e9397b77579f23/pypdf-6.1.3.tar.gz"
    sha256 "8d420d1e79dc1743f31a57707cabb6dcd5b17e8b9a302af64b30202c5700ab9d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end
