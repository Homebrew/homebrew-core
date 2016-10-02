class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  url "https://ftpmirror.gnu.org/bash/bash-4.4.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4.tar.gz"
  mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
  mirror "https://gnu.cu.be/bash/bash-4.4.tar.gz"
  mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4.tar.gz"
  sha256 "d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb"
  revision 1

  head "http://git.savannah.gnu.org/r/bash.git"

  bottle do
    sha256 "a2f73335f36d0a35970b1ee2b41e4a6b939ffd9df2a3ee9e9ebb942765d10002" => :sierra
    sha256 "9f11130718619dd0523760d714c8ac349fd62cc0b11dc70671ff132e7fc94ef5" => :el_capitan
    sha256 "af85e62012466dbb9ec9e08fe59acb03aff35f2d41844d2871c80bbd5a9e6ac3" => :yosemite
  end

  depends_on "readline"

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

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo hello\"").strip
  end
end
