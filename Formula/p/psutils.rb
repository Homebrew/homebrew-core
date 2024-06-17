class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/92/07/ebcf289c31f4da85ea94e103f0a58393c54133c64fcbef754c17b6405723/pspdfutils-3.3.2.tar.gz"
  sha256 "a20a2a1359811bd0ad72e15349351a26774ddf8e355c2cde4250a70cf77fdf0c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ae0aa9c3d86ce7b80cfbcee48c2a4849ddfe5b827d2a3f319bc72d0ae90bb20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce0efd79698f7e24eb69835c12e718f3f371a65ebd6848c756899cd15d40330"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "796456a0c27fdddc8c80134ce8a585965659f83243d00e3c8326e6aa8e1e3b8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b597434b7a83b617e206e2b8db798b928f4de94d849d14b4e45d11b99f9936c5"
    sha256 cellar: :any_skip_relocation, ventura:        "9356f545cab5c06e5f1b4bc019df52c0522120478884650b2e1be32905c86536"
    sha256 cellar: :any_skip_relocation, monterey:       "fe2c07cd5246ad231d8a520eda16e27d5d6908ff2cc3897f45bdd74d74053605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec83b119ca6ba048d42bcf0c65366a71969834290d1d66078c7f0b2040d6d72"
  end

  depends_on "libpaper"
  depends_on "python@3.12"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/e0/0b/2308ce51da41b4937375008670346f972316218b9577e4daa75d6077c19e/puremagic-1.21.tar.gz"
    sha256 "31ef09b37a6ad2f7f2b09b5bd6b8c4a07187a01af4025f5f1368889bdfc6d779"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/49/6c/4ffb864f1f41b7ef7bf8a397b16888cf191161a98d4c345fa32ec5aa1454/pypdf-4.1.0.tar.gz"
    sha256 "01c3257ec908676efd60a4537e525b89d48e0852bc92b4e0aa4cc646feda17cc"
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
