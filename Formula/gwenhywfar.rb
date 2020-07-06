class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/319/gwenhywfar-5.3.0.tar.gz"
  sha256 "3aec5982f5e136761863f4b6b12bbb4cd26b8ffb5f7553b58a48f72b6a4344a9"

  bottle do
    sha256 "d353d4792d28b57e1fad274293cd4d5952186554571b1efb91169e98c4722a13" => :catalina
    sha256 "a162c646051357271a51b779a885041dcef5b92824d566c290ec0234d450f837" => :mojave
    sha256 "a9a9db801484a06000f75c642cad6d3897e9cd5afbf8bce3e49e7528656b8ba3" => :high_sierra
  end

  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@1.1"
  depends_on "pkg-config" # gwenhywfar-config needs pkg-config for execution

  def install
    inreplace "gwenhywfar-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=cocoa"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
