class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20160522.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20160522.tar.bz2"
  sha256 "de77430ae90db4ec3851cdfc95d842b9d1e7e28e46e8d40d49bd17def53c200f"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7ed220797183f2f8d4e55194aaebca714f03118592b2b8ab415eac1afa6c9e5" => :el_capitan
    sha256 "d5c1876af12c974bb6304276e940d181d2af854e16cfd701ecc4486157a950f7" => :yosemite
    sha256 "539d7698ca4b2859470d6b18c2900f346e3bfddf41fdc2025adb344fb07864a7" => :mavericks
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
