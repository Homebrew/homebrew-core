class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/92/07/ebcf289c31f4da85ea94e103f0a58393c54133c64fcbef754c17b6405723/pspdfutils-3.3.2.tar.gz"
  sha256 "a20a2a1359811bd0ad72e15349351a26774ddf8e355c2cde4250a70cf77fdf0c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "601c65de5fcc9366a9e1dabb4176a614efe48991244c0532df58f427f8aca3de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6482e49ddb120757197a3e64a31e67ff40f4c7456266cf9ae37abd72d1210c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e3a59a4e24124ece21b2b13571319bad92de2d8fa3df5efd20bcf0d5be1387a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a17b81eba7a9c7a1f94b3ae97f578a8cc40d7caa673483d5c52c09f502891b73"
    sha256 cellar: :any_skip_relocation, sonoma:         "0eabe68e455b3c1cfbda9e6f9e8649bfe6355a1b0b2f1bd8fdef57433afb54d9"
    sha256 cellar: :any_skip_relocation, ventura:        "56aaec88e0610d3bfa1832638f7365356ab11124a9d8e37aa0a6d65e4add22ae"
    sha256 cellar: :any_skip_relocation, monterey:       "35fe9eaed5eda798bb09456026bc9002ff144a36aae6522c44cf8e7d86e23f94"
    sha256 cellar: :any_skip_relocation, big_sur:        "450c4a7d78da0c5ce20ae0f232acb590264c2b9a7557b885d59b7e8399c88b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033d77779aa2fd7c1c89d885dda7feea6746e60249ab6bebbc987e97c1c69750"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/4d/9e/23bb47ae1c3e8f11b5d5625eef5d6ab94ba1806ea2826babcb867090cce5/pypdf-3.16.1.tar.gz"
    sha256 "aff9540e6c5ec135d6e80943db74257523639325162d00c903ee1e2be84351fc"
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
