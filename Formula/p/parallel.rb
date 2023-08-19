class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20230722.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20230722.tar.bz2"
  sha256 "55f991ad195a72f0abfaf1ede8fc1d03dd255cac91bc5eb900f9aa2873d1ff87"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0413bb8c11fd8ded232ee64b66ff193529931c8f13d32d8da3eccb4e276a2f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0413bb8c11fd8ded232ee64b66ff193529931c8f13d32d8da3eccb4e276a2f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0413bb8c11fd8ded232ee64b66ff193529931c8f13d32d8da3eccb4e276a2f6"
    sha256 cellar: :any_skip_relocation, ventura:        "e0413bb8c11fd8ded232ee64b66ff193529931c8f13d32d8da3eccb4e276a2f6"
    sha256 cellar: :any_skip_relocation, monterey:       "e0413bb8c11fd8ded232ee64b66ff193529931c8f13d32d8da3eccb4e276a2f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0413bb8c11fd8ded232ee64b66ff193529931c8f13d32d8da3eccb4e276a2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "242a11ef1541e44e67258bc6b068a0259b68f03228b7bbb2a0604894cdac8526"
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
