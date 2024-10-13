class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/ff/46/8b697d7976ceccd4971886f04b57ec3ef46d8976b2beefa97892bfa35271/pspdfutils-3.3.5.tar.gz"
  sha256 "49d0ed8254df3fe60eb4fd74d4dc1ccaf08cc7802ea9d79d83670b45685d5e35"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "115ed1edf086f53e50e83e94c491fd872d2921adadf12abb6a526aa2dc2cd134"
  end

  depends_on "libpaper"
  depends_on "python@3.13"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/09/2d/40599f25667733e41bbc3d7e4c7c36d5e7860874aa5fe9c584e90b34954d/puremagic-1.28.tar.gz"
    sha256 "195893fc129657f611b86b959aab337207d6df7f25372209269ed9e303c1a8c0"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/9d/28/6bc2ca8a521512f2904e6aa3028af43a864fe2b66c77ea01bbbc97f52b98/pypdf-5.0.1.tar.gz"
    sha256 "a361c3c372b4a659f9c8dd438d5ce29a753c79c620dc6e1fd66977651f5547ea"
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
