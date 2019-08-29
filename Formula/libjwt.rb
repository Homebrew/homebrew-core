class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.10.2.tar.gz"
  sha256 "618cda68df773f45eb43dd200afd384935c3a7cf85d1a9a53a7fadc1c899a40d"
  revision 1

  bottle do
    cellar :any
    sha256 "e8cab6f4cfbd8208a3acf42e7d30962b3361bfec08d9d534750755106e8ef892" => :mojave
    sha256 "e9d9049b9927e7f35795270f6d0eb8fff04f81995c715428f99e00049601e680" => :high_sierra
    sha256 "0c77af65c6831d7ba809c63a8f4fbea92844f4fec0aadbaa753828383901088e" => :sierra
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
