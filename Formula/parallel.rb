class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20180922.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20180922.tar.bz2"
  sha256 "ea078ef0e0528c9b5d1c60bf6cf8454ce7586521982c677a450e0baff8a7071f"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd5dd85de0987c4cc5511385d56d8b582cb2f22c3742cadf93bbee9a6eac3f83" => :mojave
    sha256 "905731d02041d7f1e664564e6974781546573140ca1252014c2bbbc162e70d8d" => :high_sierra
    sha256 "905731d02041d7f1e664564e6974781546573140ca1252014c2bbbc162e70d8d" => :sierra
    sha256 "905731d02041d7f1e664564e6974781546573140ca1252014c2bbbc162e70d8d" => :el_capitan
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
