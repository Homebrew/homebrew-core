class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "5.0.1",
      revision: "c53b650011e0ea6bbba867ebb0d040c6fd0f7ab7"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "e5a362d37c50a2904460a4560a326991e30cbc1e2fc68493e1b0b4f99af8d711"
    sha256 arm64_big_sur:  "d08876fe474b9540ca7c59a6ed217063256b22d68a22b55cde067c55a8f45f52"
    sha256 monterey:       "0a83d20330c1ba54aeaab1bd278fd5e49e778d14c1deaa79f77cb8d950f6fdba"
    sha256 big_sur:        "22391a135d71df95afc22e342c6a7103e5d38a31d9d9da87aaa47a698aa2dedc"
    sha256 catalina:       "5ef1fb46fb80f1d53e3c75351b44e336cbce1fca6cbc6ad07fe391f822fffd5a"
    sha256 x86_64_linux:   "917bc161fc48d02d312ac8e97f07041df376920d97f1e5ef2544552ebc21b25c"
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
  uses_from_macos "python" => :build

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
      --disable-tcl
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
