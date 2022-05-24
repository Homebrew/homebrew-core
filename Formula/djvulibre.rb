class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/djvu/djvulibre-3.5.28.tar.gz"
  sha256 "fcd009ea7654fde5a83600eb80757bd3a76998e47d13c66b54c8db849f8f2edc"

  livecheck do
    url :stable
    regex(%r{url=.*?/djvulibre[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "54e8737a09b1c0aebc0b5ef27c43b3a85fcb88172214c47c095bd142a0b70ec9"
    sha256 arm64_big_sur:  "bb1d4090bc63c01757258e885b2bf71f1a72ff73cb7d3773c01f407e05ac677f"
    sha256 monterey:       "da591c89172dd92664e340cf1ac0896c9782b6a360e949b38fc7380fb4a86557"
    sha256 big_sur:        "6d308b8e5bb791a708926ca46adba3b40c3e3cc68edcc80928eeaca21f08b460"
    sha256 catalina:       "c6d381a0927b5a9cf24b32a0bca2b5aa7481fbc2824fb85460aa846026013e07"
    sha256 mojave:         "2a264a38035e422d9af42adbc64486aa30eb0ed206a03a369f15e07905ca37be"
    sha256 x86_64_linux:   "aafad0808f56b3b0fd9bc6b05297cbc8b9fe06df2068fb2f0bd87c93aa45e79c"
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
