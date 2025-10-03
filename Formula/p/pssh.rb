class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://files.pythonhosted.org/packages/60/9a/8035af3a7d3d1617ae2c7c174efa4f154e5bf9c24b36b623413b38be8e4a/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "518c2915f02b92510bef30b6a5826e8165fb9cdd3405e2355292e872fae6cc40"
  end

  depends_on "python@3.13"

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
