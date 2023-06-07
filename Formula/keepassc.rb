class Keepassc < Formula
  include Language::Python::Virtualenv

  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://github.com/raymontag/keepassc"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 4

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c02be2745a47b1fb4802248f9579dd8214ed297781cdfca0cea7b65e24a3334d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d112080490c1ab470cd58204b5291c990d3b16e7ff03ad4c262e0be4dac1bfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7fe53a11452ba978f94dad6108491e7c4dfa10e5db50360fc001df82a28e6b8"
    sha256 cellar: :any_skip_relocation, ventura:        "acfb7f5f66a43d79f22a9b1b39c9ab81cf65bcb0fbebd0aea4ea13a5b5d6630c"
    sha256 cellar: :any_skip_relocation, monterey:       "9add6a5aad14f32e943ad62426db39625dff78f16e0b6523a7664e359594b566"
    sha256 cellar: :any_skip_relocation, big_sur:        "920fc5fa7f2ff135b74e010cd2b8137921546a7f1443a25ce7b17ad75c23a194"
    sha256 cellar: :any_skip_relocation, catalina:       "4b35da05d90e26cde3fd506fd7cabb0d7d1297cbc07113c4664bd8a019c3e27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be222d829ded563759764d798a2aff74c32873f9ac704ea12001714e2679bd9b"
  end

  depends_on "python@3.11"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/52/0d/6cc95a83f6961a1ca041798d222240890af79b381e97eda3b9b538dba16f/pycryptodomex-3.15.0.tar.gz"
    sha256 "7341f1bb2dadb0d1a0047f34c3a58208a92423cdbd3244d998e4b28df5eac0ed"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec.glob("share/man/man1/*.1")
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system bin/"keepassc", "--help"
  end
end
