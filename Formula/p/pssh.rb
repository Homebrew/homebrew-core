class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcc233d04e87e24eee8c465ae40c58a8d8419b866edf1c15f16572c724cfeba1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6274719af586dace88f196051bfff386f34588f3acb2c9fb82544c35e57bd0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f36681d38878026b147f5f9fe29a41b42d3405a38e1badd02352d342c45e33"
    sha256 cellar: :any_skip_relocation, sonoma:         "dab0ac8a7eb258204455639a4c3bbe864fd6d7e53a9462205685e58d33e33a64"
    sha256 cellar: :any_skip_relocation, ventura:        "5261fd518381182846b4d6aabf594594a7fd5c55622efd9a216e4c766ef18dd1"
    sha256 cellar: :any_skip_relocation, monterey:       "bf27ef315b921cb4f333f2f5d8a74292ac2508be06929f1c1fe0404331d3474d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a77628efd39dc21de382b5ffb27b3d0e600d95d54dd99debdddc77524567be89"
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
