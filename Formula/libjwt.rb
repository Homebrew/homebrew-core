class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.11.0.tar.gz"
  sha256 "61acfce6a514369c76ee1f2ffad74519ae91d5830fde478a253f69dcddb7b0af"

  bottle do
    cellar :any
    sha256 "d893dfc6284b07fd29ee3b7ec71ddd326129d1a88f4f29782abd9d58f8d422e4" => :catalina
    sha256 "dc5f705b1c774de55294f2171739be110381408cf48c8d0f1ff5c8357c97dcfd" => :mojave
    sha256 "8f525024b46ad0de83d3b2a4d2f614c9427513c9e9559833beb0c319af6fdd1c" => :high_sierra
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
