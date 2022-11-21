class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "7.0.2",
      revision: "d0d7dfca5824e1ba0f62cfe9a3c07447cabad921"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "a6871205565791d938bb23760e3ce4209410777c9a570a69fe16bd8c06706212"
    sha256 arm64_monterey: "18aed58093937c2743088324512c6a0a6e51c78a4e0e890838ff429e8c5fb7c4"
    sha256 arm64_big_sur:  "d5cb5acc7b3c7b9a286b84c7b6c9e3cc7dd21b7fbd2247f8cd86f6179f3c4480"
    sha256 ventura:        "7dc97172c54dc8b0ab6f50dde8382fc13b26edec7371e8cda706baca957a16cd"
    sha256 monterey:       "4301b0d774f14d732d2b0b05367871519bdea99684c9e3c27d36e764bbc432c6"
    sha256 big_sur:        "3e08791158a1e429d4b3ed37b95601bf3eeec659bfcb6d8387b5d2864237196b"
    sha256 catalina:       "58be5ffb377ad6e36b6af356f7e88821861ab98746d3c9d56cf59d591f079c5a"
    sha256 x86_64_linux:   "ce311ec23404674c602597e385d1a0c2b85efac93dcd50312772650a20d3527f"
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
