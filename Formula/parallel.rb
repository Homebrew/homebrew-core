class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20230222.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20230222.tar.bz2"
  sha256 "6d36a5ea097668ddb780e74e2ff00252da163995a4b1e96ef633a99b209c980e"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "417abfe68208313ad050ec50e63c7123e0b2c323a7a269adae225cb69577079b"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    ENV.append_path "PATH", bin

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

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
