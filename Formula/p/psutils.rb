class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/78/50/adfefdc3096c2c25a135ca8e4f2485c891bc6bb60b86d27f3955af65b5c4/psutils-3.3.15.tar.gz"
  sha256 "7001ff39c5a84e2616aecbe8c9d213f14412908990f84dfbd92168edfdbaaf3d"
  license "GPL-3.0-or-later"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74a3071e4fe96fd440efd813de5e346b28af11fbcaca7629f86e1be26476cc9c"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/17/18/9947cc201af9ccf76720fd3347bf4f70eb882ce3fcf4cb05f7443e4cf871/pypdf-6.13.3.tar.gz"
    sha256 "f3cb822769725f1bac658c406cfc9460399043f3750c2d3e4650e0a85eacabd7"
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
