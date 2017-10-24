class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20171022.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20171022.tar.bz2"
  sha256 "f7e2bb7467cd3e87c5488e324950f2710e5d6cc9c9b3c33931e71d7a2d08f8a2"
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
