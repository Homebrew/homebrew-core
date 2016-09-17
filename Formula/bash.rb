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
    sha256 "e159b9d75a2ffd7f86e64f4ad81d438a119f3612b38722731ff41315bceee543" => :sierra
    sha256 "4b51fb9dbe589e53418090dac749a1d4d8bec79908f5df3e6dfeef7b321788b7" => :el_capitan
    sha256 "74b413cdd85866d8b7dbc2ff6bdb4f97c94168fdf8e4a121ba94c1ba581f0193" => :yosemite
    sha256 "3b74c03785baaaec7e4d4ca8312443eb710fa57fca94898ae9a854ded97c7836" => :mavericks
  end

  depends_on "readline"

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with Mac OS X defines this, and without it, some
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
