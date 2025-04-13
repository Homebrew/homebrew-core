class Keepassc < Formula
  include Language::Python::Virtualenv

  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://github.com/raymontag/keepassc"
  url "https://files.pythonhosted.org/packages/c8/87/a7d40d4a884039e9c967fb2289aa2aefe7165110a425c4fb74ea758e9074/keepassc-1.8.2.tar.gz"
  sha256 "2e1fc6ccd5325c6f745f2d0a3bb2be26851b90d2095402dd1481a5c197a7b24e"
  license "ISC"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2447d5f8a051b1d15efec850c60e58bd372e871270fe494c9a4882309783fc11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ceec5e889bfc089f375a75b99b516efdf0bfc88a09a2d0ddbee81c53812e5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86f49118750ea97315199c2d5b3822e27886649707d35705f51fca775654916c"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a9a7e5649c8cf0a95930e8ecc11db4f7348bf3de3c532e4c224d9347e67cf8"
    sha256 cellar: :any_skip_relocation, ventura:       "653a4503ecbbc3d060c0ec6154e5fd564f5ee7496959578796416c057c1228c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a753f9db30ef23098f6e140910789845ffbab1e93af025cc5e98a0ca354166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c34fbb29c6d70d3966fb5a4b0e8afa57fe9a58aa68f1a41f2c534dd94c7932"
  end

  depends_on "python@3.13"

  resource "kppy" do
    url "https://files.pythonhosted.org/packages/c8/d9/6ced04177b4790ccb1ba44e466c5b67f3a1cfe4152fb05ef5f990678f94f/kppy-1.5.2.tar.gz"
    sha256 "08fc48462541a891debe8254208fe162bcc1cd40aba3f4ca98286401faf65f28"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/11/dc/e66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828f/pycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
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
