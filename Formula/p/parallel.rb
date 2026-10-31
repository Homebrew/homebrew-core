class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20261022.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20261022.tar.bz2"
  sha256 "4fb0d2d4d14a4ef6448c788cb2bcfde9fbe00b8d4bdc637a7e4c08f8c5453a55"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb9bd16c6cfab7d2f0b0119a0f344473c4455bf03cd420a2ef45358e5d831fa9"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  deny_network_access!

  def install
    ENV.append_path "PATH", bin

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bash_completion.install share/"bash-completion/completions/parallel"
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
