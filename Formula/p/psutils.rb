class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/e1/00/718c0fba71ed7d035013bab4083195c43ec0dfcd894492a8cfb1efd693a7/psutils-3.3.10.tar.gz"
  sha256 "698a18f291183d48d63cd43b6a2e43d133e89ab438d5aef5baa24374660729f7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ac8850f6f31270d73959032ee1f44c86890e03ef54ddb685b7048523c28f0da"
  end

  depends_on "libpaper"
  depends_on "python@3.13"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/d6/de/c9dbb741a2e0e657147c6125699e4a2a3b9003840fed62528e17c87c0989/puremagic-1.29.tar.gz"
    sha256 "67c115db3f63d43b13433860917b11e2b767e5eaec696a491be2fb544f224f7a"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/e0/c8/543f8ae1cd9e182e9f979d9ab1df18e3445350471abadbdabc0166ae5741/pypdf-5.5.0.tar.gz"
    sha256 "8ce6a18389f7394fd09a1d4b7a34b097b11c19088a23cfd09e5008f85893e254"
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
