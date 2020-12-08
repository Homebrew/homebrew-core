class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  url "https://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/bash/bash-5.1.tar.gz"
  mirror "https://mirrors.kernel.org/gnu/bash/bash-5.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.1.tar.gz"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git"

  livecheck do
    url "http://www.ravenports.com/catalog/bucket_C8/bash/standard/"
    regex(%r{<td id="pkgversion">v?(\d+(?:\.\d+)+)(?:_\d+)?</td>}i)
  end

  bottle do
    rebuild 2
    sha256 "75e4b534d6399eb38d6d21bd4733168ef5ea66fb366155bb3dcd38e90497f782" => :big_sur
    sha256 "23663beee05764a2fa9fd673d966489cc2d0d5550846970e207ac0d9567d93d8" => :arm64_big_sur
    sha256 "6a701a90139e32ff22532978c5280548a2d32b96944c2b3cb1beedd912eda827" => :catalina
    sha256 "1c163d25e8d1fe1e7d5083813e5e534ca708afcbf054017b66781a056e84ad79" => :mojave
    sha256 "9a6e6c9d160358efc23ef4d471cc423d22b3a3fd14f6324aed3810656acf67a7" => :high_sierra
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
