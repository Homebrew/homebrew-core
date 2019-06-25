class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20190622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20190622.tar.bz2"
  sha256 "3f1dfd8c450db7e70e44220e2edd4e214ba1540eebaabeeb5636d0c47b5eaeec"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8de9bb3887eed13724eda87168ff06582e850c7244eaaec6d23ef843498f53f" => :mojave
    sha256 "d8de9bb3887eed13724eda87168ff06582e850c7244eaaec6d23ef843498f53f" => :high_sierra
    sha256 "83bc1868a5df67886d3b2201ab003fe96e27c8f78531ffcfbeeb000400fc4419" => :sierra
  end

  conflicts_with "moreutils",
    :because => "both install a `parallel` executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
