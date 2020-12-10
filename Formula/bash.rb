class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  url "https://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/bash/bash-5.1.tar.gz"
  mirror "https://mirrors.kernel.org/gnu/bash/bash-5.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.1.tar.gz"
  sha256 "cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git"

  livecheck do
    url :stable
    regex(/href=.*?bash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "5bbdf900514e74d1f951c72df0ef6dc1765996f0c30ab1ef29f252e8761ec7b7" => :big_sur
    sha256 "dd353e632f37c9e8f101ec802d59fc99bdeb9464d6e9770edc7e61c1edcdc952" => :arm64_big_sur
    sha256 "5b2eb18068b921fc3539eeba06c6846634f4a8f811dce022670a0ac1fbbf136d" => :catalina
    sha256 "ce8a6ffd1e5df2014d7d7290a08f0682d5124c43cee4ae2ec2ac4d49155978ff" => :mojave
  end

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo -n hello\"")
  end
end
