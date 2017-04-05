class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "http://www.aqbanking.de/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=01&release=205&file=01&dummy=gwenhywfar-4.17.0.tar.gz"
  sha256 "11fdffaa2970c937251587fc62a41893c20f7ab3d74c2b66dfa81f40b2a82bfd"

  bottle do
    sha256 "b62a95d85fec26ddf586269a556c16be033562c4791d6e058cff05b886a32e46" => :sierra
    sha256 "deba73e094476999d92126d473b79ddc657444ce1c712e4e8370a34b2d46ea2b" => :el_capitan
    sha256 "4da7a21f6fb4f9ed1b408975f2f825f35b5e1d9d134e8e48019d08d15570d5a6" => :yosemite
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
