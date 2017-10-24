class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20171022.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20171022.tar.bz2"
  sha256 "f7e2bb7467cd3e87c5488e324950f2710e5d6cc9c9b3c33931e71d7a2d08f8a2"
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
