class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.12.0.tar.gz"
  sha256 "eaf5d8b31d867c02dde767efa2cf494840885a415a3c9a62680bf870a4511bee"

  bottle do
    cellar :any
    sha256 "247bde97c3bc0b297d83a4f3234ed44c6e5c84f94bbbbb794654b7d9ec4a176a" => :catalina
    sha256 "b89dfc9c94b697150d3ec8d9b18208755c8253f4e2657f87111db10c288851d6" => :mojave
    sha256 "27966254d5e40f91dd93b012ce65677829727498d5aef1321cf26e884944c545" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@1.1"

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
