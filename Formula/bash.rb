class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  url "https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.0.tar.gz"
  mirror "https://mirrors.kernel.org/gnu/bash/bash-5.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/bash/bash-5.0.tar.gz"
  mirror "https://gnu.cu.be/bash/bash-5.0.tar.gz"
  mirror "https://mirror.unicorncloud.org/gnu/bash/bash-5.0.tar.gz"
  version "5.0.0"
  sha256 "b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d"
  head "https://git.savannah.gnu.org/git/bash.git"

  bottle do
    sha256 "d868e75449043299465b836dd340447d9db3d0a13f318c3ba1d3a57f02cad45b" => :mojave
    sha256 "2b0c73d331f27d89dcfd32e29b748104e196a1b28e8f3cbb94214d3a8adc7282" => :high_sierra
    sha256 "4471cac1a768f7daf38d035c2fedda4a0b0780598da8049fc75228e3a26c4fb0" => :sierra
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

  def caveats; <<~EOS
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
  EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo -n hello\"")
  end
end
