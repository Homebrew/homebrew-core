class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "http://www.aqbanking.de/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=01&release=206&file=01&dummy=gwenhywfar-4.18.0.tar.gz"
  sha256 "6915bba42d8b7f0213cee186a944296e5e5e97cdbde5b539a924261af03086ca"

  bottle do
    sha256 "3a20a0d8d35bcc1fd39a1def1da4caa00a6ab57724b796cd7a45ddb5b6c9bc33" => :high_sierra
    sha256 "7eaedffb5b5dcee09131803d95d461f6cc87220ae3aa7294bc861da92d6870bd" => :sierra
    sha256 "e5510dc740fe9f2cf1f191c23d09ce413c7163d5ff9486b34b49d28d14f60bf0" => :el_capitan
    sha256 "534810125470167a96b204c418c170b4313fe653902a92908e5f1b619565e47e" => :yosemite
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
