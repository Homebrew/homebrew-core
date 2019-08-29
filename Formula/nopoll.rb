class Nopoll < Formula
  desc "Open-source C WebSocket toolkit"
  homepage "https://www.aspl.es/nopoll/"
  url "https://www.aspl.es/nopoll/downloads/nopoll-0.4.6.b400.tar.gz"
  version "0.4.6.b400"
  sha256 "7f1b20f1d0525f30cdd2a4fc386d328b4cf98c6d11cef51fe62cd9491ba19ad9"
  revision 1

  bottle do
    cellar :any
    sha256 "1bee7669f14e9edea6c8d91f1cf9935c72e2c70202dcd4de840e0c36f68541cf" => :mojave
    sha256 "4a3c7a4f2657685b3de1b6700625e8e61087219c3b51868ee45e3ac0924b5eae" => :high_sierra
    sha256 "7695ccb4788ae836ca8e476f0d0f70216cca693e3f014c288edee90c18cb1df5" => :sierra
    sha256 "266e0d329c27be6a5c9a202b0dd7c6745d7962be606321b9172c0a57b77b91b8" => :el_capitan
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
