class Keepassc < Formula
  include Language::Python::Virtualenv

  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://github.com/raymontag/keepassc"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f37ac5eb83df4408e9d40463e0eaac92b168aecbe4d47d6afe2acacad696356a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c73f8a30eac963764cd3a5b0a477b0a040c32dee07c064960c9e452de902b2a7"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea66230d6ac142a1a95ee36782cd36c3f1c12093bb3ec1824f5ee358615bedc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3f2432782c823301965a76eef73a69558e117d7f76cc3946c363ca5740d49fa"
    sha256 cellar: :any_skip_relocation, catalina:       "fd69099efd5868cf9d9ed4d3b5c4d4ca0a616782898e92b2480dee437228e775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceef163cb3c2ce979ba57b62efce6f544c41440f18a1f376b2fe213e5e5c4f70"
  end

  depends_on "python@3.10"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/90/f4a934bffae029e16fb33f3bd87014a0a18b4bec591249c4fc01a18d3ab6/pycryptodomex-3.9.9.tar.gz"
    sha256 "7b5b7c5896f8172ea0beb283f7f9428e0ab88ec248ce0a5b8c98d73e26267d51"
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
