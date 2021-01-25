class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/djvu/DjVuLibre/3%2C5%2C28/djvulibre-3.5.28.tar.gz"
  sha256 "82e392a9cccfee94fa604126c67f06dbc43ed5f9f0905d15b6c8164f83ed5655"

  livecheck do
    url :stable
    regex(%r{url=.*?/djvulibre[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "6d308b8e5bb791a708926ca46adba3b40c3e3cc68edcc80928eeaca21f08b460" => :big_sur
    sha256 "bb1d4090bc63c01757258e885b2bf71f1a72ff73cb7d3773c01f407e05ac677f" => :arm64_big_sur
    sha256 "c6d381a0927b5a9cf24b32a0bca2b5aa7481fbc2824fb85460aa846026013e07" => :catalina
    sha256 "2a264a38035e422d9af42adbc64486aa30eb0ed206a03a369f15e07905ca37be" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./autogen.sh"
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
