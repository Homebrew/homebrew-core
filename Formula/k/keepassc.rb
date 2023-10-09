class Keepassc < Formula
  include Language::Python::Virtualenv

  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://github.com/raymontag/keepassc"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 4

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69222e3bab742d39d0023351ae2aea560125253e13c2be5e619afae46538ac8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7d89c3f7b0ced2d6839ac5716c5f880dfae30aec7f4488867d33453a211129c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "572b5e26bdd2ab7cf29267926e65a6055fae1ffd64afcf2a554edddb74e5643c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c4136b04da453cba3bbfb041b2909674e078f076ca8fb563125ef253d2edf48"
    sha256 cellar: :any_skip_relocation, ventura:        "6278e9826308306d6895bb631666c2da6004c3df69fdb89e53aa6084883b4c36"
    sha256 cellar: :any_skip_relocation, monterey:       "52519bc7729f34f92a21c5cbd628ee58875e377f7df615938a64e749f33badea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "289914d6f6dcca2cf51670c0b7334ba148670cb1ca4db3a9dfc647ee3ebd8660"
  end

  depends_on "python@3.12"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/c9/09d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53/pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
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
