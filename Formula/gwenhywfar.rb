class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "http://www.aqbanking.de/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=01&release=207&file=01&dummy=gwenhywfar-4.19.0.tar.gz"
  sha256 "c54a9a162dc63ab69e4d3fc946aae92b929383ca60a2690b539adcdc58de9495"

  bottle do
    sha256 "81c996539bd23f29dc887f30a2f264baa54adf0be256317c4135cec2b57b1959" => :high_sierra
    sha256 "c8fc46ae0ce6ff352b770a098121dd8b9f21e65f53737ed76baa14a519f31a72" => :sierra
    sha256 "054415540bcac666970e001732560e697d84f6c8ec7b7a3ca0ca4ac19e6a2a13" => :el_capitan
  end

  option "without-cocoa", "Build without cocoa support"
  option "with-test", "Run build-time check"

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on "libgcrypt"
  depends_on "gtk+" => :optional

  def install
    guis = []
    guis << "gtk2" if build.with? "gtk+"
    guis << "cocoa" if build.with? "cocoa"

    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=#{guis.join(" ")}"
    system "make", "check" if build.with? "test"
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
