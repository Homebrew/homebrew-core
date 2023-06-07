class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/65/57/65ec78caae76c9ac86f756478a534543bbb4a403e60934aa13f5b2c44cbf/pspdfutils-3.0.4.tar.gz"
  sha256 "2a271854be5d3af7d990492e35ea091972ce4bc06ff9d3814fef49d537d77893"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64515b1055b7d26815955832107f47ee1506ce213661ab13941ade76aebc655a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4fbc2712d3f9b8e1efd50adb7f546d505f7471181ba9c761693266ffad6c025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70c1f55be883bcba43d362d23fc1b6e22d0cc64b6af0a8f18a1edf4cb0a8f216"
    sha256 cellar: :any_skip_relocation, ventura:        "5e6d262306656a25dfb63ac6e09d50f647e82fc09a911b1a87263aab66ce6a2c"
    sha256 cellar: :any_skip_relocation, monterey:       "1fbdf1c2b1a5be3092d68fc79ee83fe47525a47b4ffb209f243185a78f35cf0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a64fc5e2adee4af646035d07b43831138484f6111338ff36c54ffd68f16be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24ef040b916f7e8c9a8a65ef2c8790945cd4098ae0143f2c4c4fe0109224035b"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/84/46/50c317477ccd23979b7e18847d2c58c8fca89b0db41670bc819710aab26a/pypdf-3.9.1.tar.gz"
    sha256 "c2b7fcfe25fbd04e8da600cb2700267ecee7e8781dc798cce3a4f567143a4df1"
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
