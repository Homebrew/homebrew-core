class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20210422.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20210422.tar.bz2"
  sha256 "be3e6a3b644467bef25905cb4fd917e67eef982ba4f6e258df25bb0235b59ee8"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released \[stable\]/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "660d5f0736181ea16850569a26ddfab88af83d112e95db0f8f790655bb3cbf51"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a604a471b0f1e51112a7bdb3a3b6656948082c8ab41c5b5cb651c22e5b5e7eb"
    sha256 cellar: :any_skip_relocation, catalina:      "7a604a471b0f1e51112a7bdb3a3b6656948082c8ab41c5b5cb651c22e5b5e7eb"
    sha256 cellar: :any_skip_relocation, mojave:        "7a604a471b0f1e51112a7bdb3a3b6656948082c8ab41c5b5cb651c22e5b5e7eb"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
