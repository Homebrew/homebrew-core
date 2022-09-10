class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "6.0.0",
      revision: "091148d2910ac5f9b4d3b14578da2623f47e347b"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "9c7fa7c146b903db3d61f23320b461e5ebb1c64590eca29caeda99c9766864b1"
    sha256 arm64_big_sur:  "398966c6f4c0ee00236532567482292c71b261ae820fbfac3304cb572a95e63e"
    sha256 monterey:       "c6f6d6a97bafca5939cf9075ad5ec883ed1b5227ca168bac9d3d5f558187120d"
    sha256 big_sur:        "7103b1c7b8457ac91672a1925ea875642345ad77e6c594e8547c0c156226d425"
    sha256 catalina:       "de2aa3caed0cd29ef43fd8863b28a28e96355b0b975bade684ec980f94f3c220"
    sha256 x86_64_linux:   "da5e1687a04031d5ed0d1f9ee19d52101c0ad14f0275b2600e3325782c353d38"
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
