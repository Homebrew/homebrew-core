class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "https://djvu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/djvu/DjVuLibre/3.5.27/djvulibre-3.5.27.tar.gz"
  sha256 "e69668252565603875fb88500cde02bf93d12d48a3884e472696c896e81f505f"
  revision 1

  bottle do
    sha256 "e4b26399caea6a5496e8c6710ed6853d6a4961e010fc499a93abf38846ae9c8b" => :mojave
    sha256 "70f48c15f481fd3939f60eb94f3fa47ea67340a3343df73110252ef7b5ce69de" => :high_sierra
    sha256 "7f3f10f71e06342886c20b449551fc36d9edebf5bf5e90cb3fc355cf4624f4d9" => :sierra
    sha256 "9f0fa17a46c514ab33d1d5fc88429f4d9f27926aef59807bdd74f94f8f4343ca" => :el_capitan
    sha256 "a175ac622b0f8914e401ba93938b4316c08f35bc186c35196a5a3de6b56b95ab" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/djvu/djvulibre-git.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./autogen.sh" if build.head?
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
