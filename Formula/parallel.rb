class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20170922.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20170922.tar.bz2"
  sha256 "61820ba6addcb1f9581e159795e92d6a0e4471fb888259b0b1c4b51aab6d1565"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22007cfe6d52eb8fa527a19383b15bb7da5eb83746df44317855b175bbb8f62a" => :high_sierra
    sha256 "6be71f201119df1fefb58faa7cc3c6c67e39fdd069dead2464861844abdd77aa" => :sierra
    sha256 "6be71f201119df1fefb58faa7cc3c6c67e39fdd069dead2464861844abdd77aa" => :el_capitan
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
