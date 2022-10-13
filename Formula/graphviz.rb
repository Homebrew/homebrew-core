class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "6.0.2",
      revision: "fc13ea9684066d28b3bcb61670202d28c6110d60"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "9bcaf51b5d3d57d92d87afa5d6f9e3c2dd474a54b9a5bd03e0d2922235d3d43a"
    sha256 arm64_big_sur:  "36fd66355f052905c47ef5ecd2d077fd8b482617bdb8c68c5542218e767c7911"
    sha256 monterey:       "c1f698543db61e4f12da60eacc97c3d67fbdaa0e5f223194abc1c84a1832bae8"
    sha256 big_sur:        "70babfa7d3c992018cb9f678bbf99e4f74d0b2627b58b41c52d8dcb98a1e40d7"
    sha256 catalina:       "085db7ae9a2698e62e88165f42fa32512c63c082f032e80a312009d21ee58937"
    sha256 x86_64_linux:   "29b6364bbc3bb7b340ce842e4ff54cd1b5525a0bd764c58d1815a05d4938b18a"
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
