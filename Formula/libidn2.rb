class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.4.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.4.tar.gz"
  sha256 "93caba72b4e051d1f8d4f5a076ab63c99b77faee019b72b9783b267986dbb45f"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "733adfd62ece847bb7f36e57434c58582020cd7c572a2b37b6113811108ac1c1"
    sha256 arm64_monterey: "38eed5a97aaddeebf0c510ed609466c2c0d1fdc996452e380a4ed9366000fe5e"
    sha256 arm64_big_sur:  "3b7b3d218a6b04a8264174da41af73e638fc75a7dcbb4f41150f2f37166d5cb9"
    sha256 ventura:        "3561d710120deb93c7b30c1c3a9639e9649e41fc7360b25ce6a8bc53424a43da"
    sha256 monterey:       "335207a9dc5fdab95f75b5639108c66e57d9b3fe0c632a829e05947d8e0b31ff"
    sha256 big_sur:        "d2db4a1e16ed4293bb44a0aca0166e9a4eda64f219d655c0aa56a1014398e0ff"
    sha256 catalina:       "9cf7ddcc4469e80d0a81bc95312e2481bdddb2b5fdd9f1a20ca8b0b37eb38af3"
    sha256 x86_64_linux:   "e95765dc4efb32e9b9d24f3b02624d40f9c6f2753a091296900f107ada06f106"
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
    depends_on "ronn" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libunistring"

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}",
                          "--with-packager=Homebrew"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    ENV["CHARSET"] = "UTF-8"
    output = shell_output("#{bin}/idn2 räksmörgås.se")
    assert_equal "xn--rksmrgs-5wao1o.se", output.chomp
    output = shell_output("#{bin}/idn2 blåbærgrød.no")
    assert_equal "xn--blbrgrd-fxak7p.no", output.chomp
  end
end
