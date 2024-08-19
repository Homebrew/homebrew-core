class Keepassc < Formula
  include Language::Python::Virtualenv

  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://github.com/raymontag/keepassc"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59ab2d959aa8bbaad5ac6c7f208a7ed22374f694bae1f96725342b9dfd2d8b70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2a9652625bc12ad0456f3f3c2d5a0cc619629e162b14bc2b58963f44aca1a2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a1e3179e658e703e11f18f6927cbfd0d1d23f3a0932abe737b04512eb31a303"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e6f5ef6929d5cf02571b46280c3f1fe215adc30d3250078840dd0bdb1e0164d"
    sha256 cellar: :any_skip_relocation, ventura:        "06b888038774bbdad203f571c00ea8e5b6511276d2bc7336d5846160138f55db"
    sha256 cellar: :any_skip_relocation, monterey:       "f84c91130f612fcdfb3fc58543f551cb9ff945c93155ce6dd48470c8cbb1861a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "882f680f1d047d0b327bb499a284bcfac9e5661f5a427e41f74aa3f3a513ec02"
  end

  depends_on "python@3.12"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/3f/13/84f2aea851d75e12e7f32ccc11a00f1defc3d285b4ed710e5d049f31c5a6/pycryptodomex-3.19.1.tar.gz"
    sha256 "0b7154aff2272962355f8941fd514104a88cb29db2d8f43a29af900d6398eb1c"
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
