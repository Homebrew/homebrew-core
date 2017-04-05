class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "http://www.aqbanking.de/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=01&release=205&file=01&dummy=gwenhywfar-4.17.0.tar.gz"
  sha256 "11fdffaa2970c937251587fc62a41893c20f7ab3d74c2b66dfa81f40b2a82bfd"

  bottle do
    sha256 "4134a1899f551ec91f6495d69a3939c9aa30d38f292291f00869709d0f299020" => :sierra
    sha256 "9b78e775989003bfe9e79bc745ef477b2c485c58d4aaff947cf4a44e86f1fc9b" => :el_capitan
    sha256 "f0beb1b72cafab6696ab63c5a0ae5aa22040095bd6ae8997121f1725e7a11d5f" => :yosemite
    sha256 "ef8ea6c7fa80e6e89faf9dbbc3f2aa7ef89fd31e16b940abd64ed036a7b1069a" => :mavericks
  end

  head do
    url "https://git.aqbanking.de/git/gwenhywfar.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
    (testpath/"test.c").write <<-EOS.undent
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
