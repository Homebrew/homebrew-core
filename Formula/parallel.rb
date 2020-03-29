class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200322.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200322.tar.bz2"
  sha256 "207484e124860e215cc3e4d7aff48b3b1c4376c95b3c7c7888453c67e92be94d"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d8516f4ae2cea304392d8804d8de8fa8657ab3556e67c78931cd61df485b44a" => :catalina
    sha256 "5d8516f4ae2cea304392d8804d8de8fa8657ab3556e67c78931cd61df485b44a" => :mojave
    sha256 "5d8516f4ae2cea304392d8804d8de8fa8657ab3556e67c78931cd61df485b44a" => :high_sierra
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
