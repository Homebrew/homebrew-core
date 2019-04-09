class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.10.1.tar.gz"
  sha256 "d1b6c0e6b2b67e4cc83b040c88bf9faa5b614d2d9a1677b4822536f926a280a3"

  bottle do
    cellar :any
    sha256 "e1559cdba8e53349581f735018d2014162b25caea92cd4f2c50617420ca56dc2" => :mojave
    sha256 "5edd2ef1f9134ea79c364eb2ce962c78b36609190e0998cb31df48c71c142fe4" => :high_sierra
    sha256 "eedb2aa07ab5e34c4d9f715f2fe6cb485ad957865a54383b94bfc9b171ad398c" => :sierra
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
