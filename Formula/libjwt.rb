class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.8.0.tar.gz"
  sha256 "e97c15c14dbd49d5ba435cb26e06e6cdd6e32cf9f0be6b6e9a2d2d330923ea17"

  bottle do
    cellar :any
    sha256 "bda2b99bcf372026917957ee5d7724a13f2748504739d8a78e63efeb51a7b548" => :high_sierra
    sha256 "223f3957505fb4c66e07ffa322d885ea78b38e26a8e0d62adfc9105216b9eb70" => :sierra
    sha256 "ad5dbcc8369392c61e573e5e62b015dc67afdec61e311bf697a4b71c3d69fa51" => :el_capitan
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
