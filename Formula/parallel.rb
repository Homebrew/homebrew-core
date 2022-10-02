class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20220922.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20220922.tar.bz2"
  sha256 "15b3a149ddc1efce59e7cdff024057f141a7a0c9f2507bf62b2cb2bf21c9cac1"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a24d26a8e3eadbb5daccd12a2674eb0072e266a2b122093b3a09c38e131d191"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a24d26a8e3eadbb5daccd12a2674eb0072e266a2b122093b3a09c38e131d191"
    sha256 cellar: :any_skip_relocation, monterey:       "c53d83a5d59eb8b6501677741dfc56ad2fcb212d9676dfb3e6a0ef8b1b4051ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "c53d83a5d59eb8b6501677741dfc56ad2fcb212d9676dfb3e6a0ef8b1b4051ea"
    sha256 cellar: :any_skip_relocation, catalina:       "c53d83a5d59eb8b6501677741dfc56ad2fcb212d9676dfb3e6a0ef8b1b4051ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a24d26a8e3eadbb5daccd12a2674eb0072e266a2b122093b3a09c38e131d191"
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
