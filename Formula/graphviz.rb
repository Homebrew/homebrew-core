class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.46.0",
      revision: "4f263aeb7fccdfac1e71a305f437a997385bdf59"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 arm64_big_sur: "f693eaeecda197a4a11a82a81ec92e324114fba25d3ed78d55f769c9f4143088"
    sha256 big_sur:       "978702b76bf7036a2a597c98b17af093a8cf19aa05110245d8bdec4cf9801ec0"
    sha256 catalina:      "039c37ccdd3f2b8bb7fb63414019a22aed411941daa272e407a1cf721933431d"
    sha256 mojave:        "da5539eceb294ec3a577db104502ae77a7f1a137196bd6531db77011ea9c7754"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "byacc" => :build
    depends_on "ghostscript" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --with-quartz
      --without-freetype2
      --without-gdk
      --without-gdk-pixbuf
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-gts
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"

    (bin/"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
