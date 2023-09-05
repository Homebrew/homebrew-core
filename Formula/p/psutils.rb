class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/05/90/cd6c0ec88ba12e511d7d73db720c23f41f020f88f68d914667d43a68fd70/pspdfutils-3.2.0.tar.gz"
  sha256 "921caf6207670574f15d03855a715f0b597420135cefe3455aec5342350f06ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bda92ba721c532a137f406e9beb5356f55fe0cc9473d25b26db7b8aabd6674b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365be9982d23fa4b2e771523cde48733b489948b14a0fbdecfa03ab25621b641"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50c2c6a08d3c3235c3ade1cd98c5bb9728d31211bfe7792869c8c4fed46b5be8"
    sha256 cellar: :any_skip_relocation, ventura:        "e6e8371cdaa3d60c51845eed986c8178d1ba70f908ccd109c30e9381b52ad44e"
    sha256 cellar: :any_skip_relocation, monterey:       "173d4ab77e46051bd94d7c63383aa57355d79770d34e885b1e3269e599cc9c93"
    sha256 cellar: :any_skip_relocation, big_sur:        "e319fd9c14d60b26cc16764ead3cb5b4ce22595a26ecacdb395979208b5e6b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cee4873fbc431e920352a978d001c6e371f175a77ccea5f82d2d4739a7e77e4"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/8c/5f/07d3462b0ccf11e789e21ee4af2c3e817297ea3f8328e202a547cb0cf253/pypdf-3.15.4.tar.gz"
    sha256 "a2780ed01dc4da23ac1542209f58fd3d951d8dd37c3c0309d123cd2f2679fb03"
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
