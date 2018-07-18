class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20180622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20180622.tar.bz2"
  sha256 "f2cc6ac37d0b68d90b81570c0e4be589dd8c131d204320acaa173544ad6d21d9"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1218d39b959d7cf05ff48c1a46f6f910c032687216b9a89da54106ec8d876aed" => :high_sierra
    sha256 "1218d39b959d7cf05ff48c1a46f6f910c032687216b9a89da54106ec8d876aed" => :sierra
    sha256 "1218d39b959d7cf05ff48c1a46f6f910c032687216b9a89da54106ec8d876aed" => :el_capitan
  end

  if Tab.for_name("moreutils").with?("parallel")
    conflicts_with "moreutils",
      :because => "both install a `parallel` executable."
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
