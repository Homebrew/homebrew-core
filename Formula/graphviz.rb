class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.49.0",
      revision: "438731242936b0b4c481f3b0893f4cdb0c689e93"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 arm64_big_sur: "0238d071616e18e95314d8f2c26e60a2420d4e951497c2546203f8d6654127db"
    sha256 big_sur:       "5471bd101d6390a95c80af2b869540e5b1aea58878b358cf34f504e1f86c6eba"
    sha256 catalina:      "aeba9f5db7842b4e2a484dc38a26fa98f8f32e9fda4d6b7d9a87aaf3fa6edf3a"
    sha256 mojave:        "73af8815c464da252348f4e7eb99eecc4ce0c5d8423175c1aa67ce43706c3651"
    sha256 x86_64_linux:  "c3a35cf691e6b37122b73a7340b9a2b522996f841aa19aa73a0c6d8b33f010b4"
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
