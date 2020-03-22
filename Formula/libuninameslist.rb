class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20200313/libuninameslist-dist-20200313.tar.gz"
  sha256 "a8029cd38a32c85da30015ac2fc0a923c25dfc41590f1717cc64756218403183"

  bottle do
    cellar :any
    sha256 "0af1373f00d68c71578fc2a9a66f4e4e9d02f066d04e2901dd6cbf3a4cbec055" => :catalina
    sha256 "15c41c63ebe69cd6484cc1d63540f1b2a65dc31cf54b6827afd2f1ee7bd3cdfa" => :mojave
    sha256 "84f5e8f8c1d2b3e5fe6619a392e4fd599445dd2e2404115572ff77e79d2388a3" => :high_sierra
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
