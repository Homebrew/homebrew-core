class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6400952f0017d15288ed31bd64ca1c1fc1253f51eedbefbc35855ee3a9f7e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "057a52ed4c9147e36dd46d90b96f0d6f360643a61183f4915bce46d105784584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a82d688b9e5b53051d76d6bdad26d2874fd61dfa8c3eac7942126c02f55f8c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "dca053b4fdf6757022ee21e1b684ceaf058bb7b8a8fca0b4bb2ab5a28a56a7f7"
    sha256 cellar: :any_skip_relocation, ventura:        "6064a16f0502ac687d3dd2efec6148a170f2c6b43e3a72006200b7f57968d6ce"
    sha256 cellar: :any_skip_relocation, monterey:       "93db68c7d9dc966e67ac16d6ae28d3d1f8ff8887f274a173b2ef7001bf4f93e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1e85f95fa9aa7713f9d8876e0665ac659bc602cbb1c05e5467ffcd1667adf2e"
  end

  depends_on "python@3.12"

  conflicts_with "putty", because: "both install `pscp` binaries"

  # Fix for Python 3 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/957fd102811ab8a8c34bf09916a767e71dc6fd66/pssh/python3.patch"
    sha256 "aba524c201cdc1be79ecd1896d2b04b758f173cdebd53acf606c32321a7e8c33"
  end

  def install
    # fix man folder location issue
    inreplace "setup.py", "'man/man1'", "'share/man/man1'"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pssh", "--version"
  end
end
