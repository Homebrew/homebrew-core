class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/e6/d9/f7e3d52af9337bdd4e2933a9be0910af62d533ae7be7503038b4eae8448a/pspdfutils-3.3.4.tar.gz"
  sha256 "94b331826967d04b9d055c8a8e2a374c5824fd120d49c24b73d16644127d51fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39549ba08e62f24a9b516f83dda6feeff43e01ffb3bb8f564085076b243ba772"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39549ba08e62f24a9b516f83dda6feeff43e01ffb3bb8f564085076b243ba772"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39549ba08e62f24a9b516f83dda6feeff43e01ffb3bb8f564085076b243ba772"
    sha256 cellar: :any_skip_relocation, sonoma:         "db49f6cf9a4fb2d01e23b573564bd10a6fbe2a5e143ceca647a3e12104782396"
    sha256 cellar: :any_skip_relocation, ventura:        "db49f6cf9a4fb2d01e23b573564bd10a6fbe2a5e143ceca647a3e12104782396"
    sha256 cellar: :any_skip_relocation, monterey:       "39549ba08e62f24a9b516f83dda6feeff43e01ffb3bb8f564085076b243ba772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f21c0ed0186404d841f2fca4f390a155f7939bf1f006940bb948de7aeb918888"
  end

  depends_on "libpaper"
  depends_on "python@3.12"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/b8/6e/c8fde967ef33df3740a0af9340bdd5d77af422bb10e7abb4c56977e61907/puremagic-1.26.tar.gz"
    sha256 "ea875d3fdd6a29134bdd035cdfeca177fed575b6bdd68acd86f83ca284edc027"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/f0/65/2ed7c9e1d31d860f096061b3dd2d665f501e09faaa0409a3f0d719d2a16d/pypdf-4.3.1.tar.gz"
    sha256 "b2f37fe9a3030aa97ca86067a56ba3f9d3565f9a791b305c7355d8392c30d91b"
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
