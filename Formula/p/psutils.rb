class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/45/ff/4af412351a21ee38835b7597555936c547830d9a8246a2b7d2aa41aabdd3/psutils-3.3.14.tar.gz"
  sha256 "6212167dd8c09f59c9535d5e416c4f8c01431b7a5beab0ee68f4ec416ca3980c"
  license "GPL-3.0-or-later"
  revision 11
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ffca83d3267692a197acb79c94a130bf4b197c7025644db15b56180caa945c8e"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/eb/df/3725f4b848095ef634c0b2226c97901e64ee2d5a82981d89d4b784ae8ce1/puremagic-2.1.1.tar.gz"
    sha256 "b156c4ae63d84842f92a85cd49c9b9029a4f107f98ad14e7584ed652954feff4"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/31/83/691bdb309306232362503083cb15777491045dd54f45393a317dc7d8082f/pypdf-6.9.2.tar.gz"
    sha256 "7f850faf2b0d4ab936582c05da32c52214c2b089d61a316627b5bfb5b0dab46c"
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
