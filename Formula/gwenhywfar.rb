class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=01&release=208&file=02&dummy=gwenhywfar-4.20.0.tar.gz"
  sha256 "5a88daabba1388f9528590aab5de527a12dd44a7da4572ce48469a29911b0fb0"

  bottle do
    sha256 "6e6850e6a2e0edcd03665b11f66d51a2a0cb351037fdbd8b8677f4ae53595640" => :mojave
    sha256 "229eac2112343d4616576f947213706ebe5f28e0030dd5bef89ee4efa3043ac9" => :high_sierra
    sha256 "97aaff3937e4551227a66a55963d3dda7e24e53b9e9aa1ffca78ae455be00ab1" => :sierra
    sha256 "1760007de92dd5e7282a82f2534feb65380338fd8cb11632eef8914c2ddb56a4" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl"

  def install
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
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar4", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
