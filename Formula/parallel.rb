class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20180122.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20180122.tar.bz2"
  sha256 "e906c271dfa0e973a9ea151fe7caaba742e0f400e86a69687ea6b04ad6bd6bf2"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30ca3fe740f0c4d43984116ce53b7c1058f4e5bf4d029ad6d24ebf28771b4ee8" => :high_sierra
    sha256 "30ca3fe740f0c4d43984116ce53b7c1058f4e5bf4d029ad6d24ebf28771b4ee8" => :sierra
    sha256 "30ca3fe740f0c4d43984116ce53b7c1058f4e5bf4d029ad6d24ebf28771b4ee8" => :el_capitan
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
