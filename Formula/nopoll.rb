class Nopoll < Formula
  desc "Open-source C WebSocket toolkit"
  homepage "https://www.aspl.es/nopoll/"
  url "https://www.aspl.es/nopoll/downloads/nopoll-0.4.6.b400.tar.gz"
  version "0.4.6.b400"
  sha256 "7f1b20f1d0525f30cdd2a4fc386d328b4cf98c6d11cef51fe62cd9491ba19ad9"
  revision 1

  bottle do
    cellar :any
    sha256 "dcd358fc9a1f1e106aae15d59b1190956f0ac4e7f52673d24833edca3c1146cb" => :mojave
    sha256 "16bde638c91fd329d946b5854cd44291cbf516af2888e7880c5fa47dcb777936" => :high_sierra
    sha256 "dd12a792cc0cb95a56cce2037d22b4c1141b85da48d2c511f6495914351ce2f0" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nopoll.h>
      int main(void) {
        noPollCtx *ctx = nopoll_ctx_new();
        nopoll_ctx_unref(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/nopoll", "-L#{lib}", "-lnopoll",
           "-o", "test"
    system "./test"
  end
end
