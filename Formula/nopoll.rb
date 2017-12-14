class Nopoll < Formula
  desc "Open-source C WebSocket toolkit"
  homepage "https://www.aspl.es/nopoll/"
  url "https://www.aspl.es/nopoll/downloads/nopoll-0.4.5.b375.tar.gz"
  version "0.4.5.b375"
  sha256 "4ecbd277714c9acd154277a46388689f9d651836ca5c69990e35d1eee8c7ceae"

  bottle do
    cellar :any
    sha256 "528f0a9b956301f12f0b11b2782739c81fc4dbd107f0229b80ee6cc0c1c51dea" => :high_sierra
    sha256 "4563d74b87406e001bf84e40e4494eef7c2becf47b20ef8bf470d28286239a64" => :sierra
    sha256 "de062589bdb137cffbf9df05b7128eec12d443c5bea22153efd00f54e5ab2c43" => :el_capitan
  end

  depends_on "openssl"

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
