class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.11.0.tar.gz"
  sha256 "61acfce6a514369c76ee1f2ffad74519ae91d5830fde478a253f69dcddb7b0af"

  bottle do
    cellar :any
    sha256 "09af2428fecdde174257dc12590d41e3bb0363a10ef5e773a6d5da2b06f7a412" => :mojave
    sha256 "a9f50bb30bb9fef67695d76f539656a34cbe027c436b95a17c3837d9754036a5" => :high_sierra
    sha256 "63c68eeea0ee1d61b60c9e3df66a7d0881688be1075d9fbe955cd7a4191f0d91" => :sierra
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
