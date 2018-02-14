class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.9.0.tar.gz"
  sha256 "cc694dfc3abe17d1f5cde4bf6714e39dc17f7cbad352a85ffb0fe6418c584076"

  bottle do
    cellar :any
    sha256 "5d399fa64d2fc9efc33da09ed09bc085ea57202fb32e7240d838f6c826ea926d" => :high_sierra
    sha256 "38121827b73b037ba806a02f36f8b55f62eee9f317e2a56132f88c685e4f49f1" => :sierra
    sha256 "3402448d7ec4deb8471c5e5517ba306f766916497f6d1923d4d80030c88e45fd" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
