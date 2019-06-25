class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20190622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20190622.tar.bz2"
  sha256 "3f1dfd8c450db7e70e44220e2edd4e214ba1540eebaabeeb5636d0c47b5eaeec"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db9c56f3e2d8603975441b7b45acea082919309b2a8d92e9eafbd96b03b8d13f" => :mojave
    sha256 "db9c56f3e2d8603975441b7b45acea082919309b2a8d92e9eafbd96b03b8d13f" => :high_sierra
    sha256 "f82c897d474f83defa00f9d47c3f02ee26bb8e662b8b29595313c2504134068d" => :sierra
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
