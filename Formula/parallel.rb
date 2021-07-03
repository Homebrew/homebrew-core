class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20210622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20210622.tar.bz2"
  sha256 "7b33279bf71e76c52c393081d2db69057dd320be019759c4e704841a6761ec86"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released \[stable\]/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16d3f713faca86360baa01eb65eadd589bedf4328c31e7932e6f7a1c6ce1a470"
    sha256 cellar: :any_skip_relocation, big_sur:       "72299337713be36fcd8b6c628336d56e028dc273bea043bc63264bffebbb20a5"
    sha256 cellar: :any_skip_relocation, catalina:      "72299337713be36fcd8b6c628336d56e028dc273bea043bc63264bffebbb20a5"
    sha256 cellar: :any_skip_relocation, mojave:        "72299337713be36fcd8b6c628336d56e028dc273bea043bc63264bffebbb20a5"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    inreplace_files = [
      bin/"parallel",
      doc/"parallel.texi",
      doc/"parallel_design.texi",
      man1/"parallel.1",
      man7/"parallel_design.7",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
