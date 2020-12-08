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
    url "http://www.ravenports.com/catalog/bucket_C8/bash/standard/"
    regex(%r{<td id="pkgversion">v?(\d+(?:\.\d+)+)(?:_\d+)?</td>}i)
  end

  bottle do
    sha256 "0bac9da33c729ceb28f40e820d9649d2e3f3f569086077bd796f785a942660ab" => :big_sur
    sha256 "ecbed8f0ac49aadda72956da6cb0f1793c00cc1ee8249c3a43b25d9cbc55f07e" => :catalina
    sha256 "61a49bd39ce60240b3ca2fb7b4a312faf81b6346b9fa4724058e80a47ff6747e" => :mojave
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
