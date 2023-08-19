class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "8.1.0",
      revision: "edfd3eca48d2ba9fcfcd039dfab01adfd99f484e"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "caaacc05e74a2d0c85f99cbc2680b363a63d78d530c7ba0f7434c6279dd4a2a8"
    sha256 arm64_monterey: "1a27002cb561f9b15d35e323dc71711472ce4458c6f0bda5189d1d759aaf13da"
    sha256 arm64_big_sur:  "7dfbd680058f0e1555e90ffa2b7374ec8d6aec1bb32809d5912fe0a687096988"
    sha256 ventura:        "6dbce48400871f8369ac20cc031e9591bf27ca48886a4781c129695d53670c08"
    sha256 monterey:       "23a91851134daf18d235a79430e38829b57e8caa923ac1578f86386bb2bca3a8"
    sha256 big_sur:        "8799bc8a912bcb17803d43d76baf97dc07da1b0365143647007aaf5a15ebf447"
    sha256 x86_64_linux:   "122b9038c040162a041871f88df45668fc3a7e5eb61c590b60b4a54c3a2ec003"
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
      --without-gdk
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-freetype2
      --with-gdk-pixbuf
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
