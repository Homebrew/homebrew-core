class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/a0/6b/735ab226ab8e2ee6b99182312c7346a2e4bd3e825cfdf127f22ce75e853f/psutils-3.3.17.tar.gz"
  sha256 "3ff76cc9f9fb535ec553d1591de56d6dbaa0d9f4df86778f6a49731ebd764cdf"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "48f20385c4acf0c0b01eabab89edd2a2477d9e4fbe5b1867f5d6a1b7331964bb"
  end

  depends_on "libpaper"
  depends_on "python@3.15"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/e2/c1/da25a099164cf4b210d63b957c902ad687139f4b8c12c20aec7953a4a266/pypdf-6.20.1.tar.gz"
    sha256 "28f5a9d2fdc2749264612d94e6a58de54c11d730d9f0cabf8ad34117c4942b45"
  end

  resource "homebrew-test-ps", :test do
    url "https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
    sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end
