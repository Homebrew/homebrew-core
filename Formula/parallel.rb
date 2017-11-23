class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20171122.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20171122.tar.bz2"
  sha256 "41b46add38eecad3026e0086c1fb01cfa13c7cc24ecf91cd595e22f83fca82a6"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7bb925832c91a144c49e96be762059b87a4c28dd7066ac5d38f2a676b8efa09" => :high_sierra
    sha256 "f7bb925832c91a144c49e96be762059b87a4c28dd7066ac5d38f2a676b8efa09" => :sierra
    sha256 "f7bb925832c91a144c49e96be762059b87a4c28dd7066ac5d38f2a676b8efa09" => :el_capitan
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
