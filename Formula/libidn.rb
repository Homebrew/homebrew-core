class Libidn < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.0.2.tar.gz"
  sha256 "8cd62828b2ab0171e0f35a302f3ad60c3a3fffb45733318b3a8205f9d187eeab"

  bottle do
    cellar :any
    sha256 "02995ada0a4e1c66d073dd66252e7fd58d8fe3f2a9be13ca29b081b611bc43ef" => :sierra
    sha256 "b46b71b9adb991af6a444400a1c3f53d20b8001792855bcf96044ce33eb81d26" => :el_capitan
    sha256 "f675600e756059cdcd02d92963ff76f43c3b572f4ea9f99657a40e9e80c316b1" => :yosemite
    sha256 "07e19d25263d77030cccc3899967c4505dcf0c771da90a658b4f27de136a326b" => :mavericks
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "gengetopt" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libunistring"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-packager=Homebrew"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn2", "räksmörgås.se", "blåbærgrød.no"

    # Compatibility test for libidn 1.x functions.
    (testpath/"test.c").write <<-EOS.undent
      #include <idn2.h>
      int main() {
        return idna_to_ascii_lz(NULL, NULL, 0);
      }
    EOS
    system ENV.cc, "test.c", "-lidn2", "-o", "test"
    system "./test"
  end
end
