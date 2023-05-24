class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://github.com/rrthomas/psutils/releases/download/v3.0/psutils-3.0.tar.gz"
  sha256 "0d223fa15661d4ea76ec3e22e28d2126ed71e5e4a53e8ef246aaa21cf8f76aa5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9b89051d48565b81d2ae01efa3828ce26407bc69f5f29a8a6a4060fa7621731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "556b035c68743567c8187540e71921c2f465f28c123ccb65e2c28887f51e35e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb8fd5d28221639fc520c12e6461aae0d6bc483af2a5271c56759f6317972aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "0aa8f7945faa119806042db4a106bd7f13371ce1449480e3937c4c67d2bb9c88"
    sha256 cellar: :any_skip_relocation, monterey:       "4869d257409949b9da3f7c5fa3b965cb568d25d15459d9c45f08c651359d0d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "82ec97f61109e089e1f5fec652a5f968a94fa8ce8f71760a6d2cba9e80d44b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f1a95f218ba372f80656b83ba4b1ff3103eedf6abc6050a3f692ce5473e2a3"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/58/b7/63717fa462e8f54e66e460d95092e242d66d628e885773f4348e50faf0dd/pypdf-3.9.0.tar.gz"
    sha256 "06136b9ed99525159482a1397a49f3fc0fd55ffd700d1ad4393e3f42d192a035"
  end

  resource "homebrew-test-ps" do
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
