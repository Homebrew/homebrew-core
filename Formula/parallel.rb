class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20170922.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20170922.tar.bz2"
  sha256 "61820ba6addcb1f9581e159795e92d6a0e4471fb888259b0b1c4b51aab6d1565"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7acff57fc77b2144efaadcdb1abc7e2ba8e208fc110ba4df840ac0fb499c0ef2" => :high_sierra
    sha256 "e6baf61b18591c4b8fea6f15784759563ea9a20f5915fce1f59845d853bccbbb" => :sierra
    sha256 "e6baf61b18591c4b8fea6f15784759563ea9a20f5915fce1f59845d853bccbbb" => :el_capitan
    sha256 "e6baf61b18591c4b8fea6f15784759563ea9a20f5915fce1f59845d853bccbbb" => :yosemite
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
