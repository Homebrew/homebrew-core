class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1.SVN"
  revision 7
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    sha256 arm64_ventura:  "d8993888e70b3d837703995f7750bade1ecaed8f9a4a5cbcb3e833e74a79ff38"
    sha256 arm64_monterey: "99dfe1300a1324a3b79b2b5b879cef2d0899d7b44890da9724c4ab07886b1730"
    sha256 arm64_big_sur:  "85a6f108caac2e8cb3c34af987818a3274fc54feda6d2c4203421e95b0c27425"
    sha256 ventura:        "8cc2fbf57835aeb29df415d47553df03fa9b5e4cd71fcf57329aa9b89a01a1f9"
    sha256 monterey:       "aadaa4e1cd3bd315a20f7d78b52c1ce2d948a7c3b92ff422e7782baf92b81121"
    sha256 big_sur:        "2c1cdb2dead6215d4a36d1ec50f146cffcd754d775de4cb89ed58be06fe2e3c2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match "Forced opening move", output
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
