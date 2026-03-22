class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/45/ff/4af412351a21ee38835b7597555936c547830d9a8246a2b7d2aa41aabdd3/psutils-3.3.14.tar.gz"
  sha256 "6212167dd8c09f59c9535d5e416c4f8c01431b7a5beab0ee68f4ec416ca3980c"
  license "GPL-3.0-or-later"
  revision 10
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e8963b170e4dda92c936a3ad7011af5e07c66a8a1bf4b039f8dd5b11bd8275d"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/98/61/3c849a5bd7e07fc746f26ae56cf8a1b7b4c9bed12d68d9648cc903d14fbd/puremagic-2.1.0.tar.gz"
    sha256 "06beb598183c625bf9bfed70016930c2d1299e138cd07ed5d6085a7c5deaab19"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/f9/fb/dc2e8cb006e80b0020ed20d8649106fe4274e82d8e756ad3e24ade19c0df/pypdf-6.9.1.tar.gz"
    sha256 "ae052407d33d34de0c86c5c729be6d51010bf36e03035a8f23ab449bca52377d"
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
