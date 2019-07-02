class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20190701/libuninameslist-dist-20190701.tar.gz"
  sha256 "168b0d0877f275c1622fd075e6a1d072c52113dcf5da530536a2f2803ebb89a1"

  bottle do
    cellar :any
    sha256 "ba55ae3ceca9253f6e4fa9030652dc918b1c2a527356b913a66c8bd3234596ec" => :mojave
    sha256 "510029411344ac2f58c485e14ad640eb92dff84b88c8b8d58b9578b81ab2b2d2" => :high_sierra
    sha256 "4c30d7f3afa2bfeaf0e315a701944e5b8185a2dbc2e655ce52c76ee1cb6b8151" => :sierra
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uninameslist.h>

      int main() {
        (void)uniNamesList_blockCount();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-luninameslist", "-o", "test"
    system "./test"
  end
end
