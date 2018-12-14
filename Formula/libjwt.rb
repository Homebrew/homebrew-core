class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.10.0.tar.gz"
  sha256 "93b399f829cde5f5a232612fcb2909d63e7a9530bcaef40491a0493ba1606565"

  bottle do
    cellar :any
    sha256 "acbbd3be490be7968547c0f02116f115df20206cf1d3a63ef3e4e0e1fcbc5ca1" => :mojave
    sha256 "49b9d21e25b42899027d576cc4bfd2b3e99967550825001afa5b1f07cd452dbb" => :high_sierra
    sha256 "5f07077271843792d66eeeae3877fab391233017cc10ed77ea86a4fb75be3f5e" => :sierra
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
