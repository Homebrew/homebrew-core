class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20240522.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20240522.tar.bz2"
  sha256 "67ed9fad31bf3e25f09d500e7e8ca7df9e3ac380fe4ebd16c6f014448a346928"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "191329637b017a09911260be1032aeef8516eeea938453c029bce0a1d1742025"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "191329637b017a09911260be1032aeef8516eeea938453c029bce0a1d1742025"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "191329637b017a09911260be1032aeef8516eeea938453c029bce0a1d1742025"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb8ba088077adb6aaa17f7913b529c31321966d5a98261b64abaacea3996b315"
    sha256 cellar: :any_skip_relocation, ventura:        "eb8ba088077adb6aaa17f7913b529c31321966d5a98261b64abaacea3996b315"
    sha256 cellar: :any_skip_relocation, monterey:       "191329637b017a09911260be1032aeef8516eeea938453c029bce0a1d1742025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191329637b017a09911260be1032aeef8516eeea938453c029bce0a1d1742025"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    ENV.append_path "PATH", bin

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bash_completion.install share/"bash-completion/completions/parallel"

    inreplace_files = [
      bin/"parallel",
      doc/"parallel.texi",
      doc/"parallel_design.texi",
      doc/"parallel_examples.texi",
      man1/"parallel.1",
      man7/"parallel_design.7",
      man7/"parallel_examples.7",
    ]

    # Ignore `inreplace` failures when building from HEAD or not building a bottle.
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX, build.stable? && build.bottle?
  end

  def caveats
    <<~EOS
      To use the --csv option, the Perl Text::CSV module has to be installed.
      You can install it via:
        perl -MCPAN -e'install Text::CSV'
    EOS
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
