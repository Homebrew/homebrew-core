class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.49.2",
      revision: "cf96d517357e42b00279cacc042ec0c0bd2a5e89"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 arm64_big_sur: "13fba99cacc9590db0e10c25375543659df568a03dd8568d772648643f54d0ea"
    sha256 big_sur:       "934969a7ff72a3be37fc43b7b20edc63265394df892a33091b7741cf12404e89"
    sha256 catalina:      "4133a4b8b245823ac0fdc220840686360833aa38c4657debc4d2ca972a5ba649"
    sha256 mojave:        "9d7c594f9e4419620a8e0f3849ae6a4b6d9a559b5cf8c117071eb03a2a301c2c"
    sha256 x86_64_linux:  "12ed296dbebe405bcdaca1be295303068d233154fe9d4e9a831ce4faf2bd3390"
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
