class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/331/gwenhywfar-5.4.0.tar.gz"
  sha256 "e59fed9873c0e4880f5cf43748498df9ff4ff67cb5061157d21a55d16bb97489"

  bottle do
    sha256 "5bef8974fffb05b11aa019bc1a541753e60f6d9ffb385ccaf73a655ee105e325" => :catalina
    sha256 "1cdd978aa9a8be025d4cea29b7e8ed1a619718c1707419c0e847c575811c68eb" => :mojave
    sha256 "c683f99d5a7082b155717c0f77ee4f9d384a140f589d1dc0e8cac6af64a99f58" => :high_sierra
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
