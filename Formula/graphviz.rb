class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.46.1",
      revision: "5156ae3ff298dd18dcebd6b7cf4c11f5d23d03fc"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 arm64_big_sur: "0a5b42c04e033935915b1655155bbf5920d5c85ba03c0ae0c8cffcf9fb290333"
    sha256 big_sur:       "e5c6de435b4890fe00d961e7d28b2c1ba8f7e2999937e56e24947350444dccbc"
    sha256 catalina:      "ba5fd51f1c318e395ecbd4749e4a6ac54b759e835e62c77918aaece37da90c04"
    sha256 mojave:        "fa46b3b5df53615e1c2f81f2060fa2cb2a556f90bd75d6b86f39f16932106985"
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
