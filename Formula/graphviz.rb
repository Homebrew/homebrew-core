class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "8.0.3",
      revision: "fddf1625d04729758a81cc613126c7918e3f3dba"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "c58d3f5ff6dfc39660bec1922edf55c8c68608591745bd0e3858ec81a4f4c822"
    sha256 arm64_monterey: "14474eaccdbadea14e18b4933358153ca2e69a7a5f5fa2d36d4232dbad9c2622"
    sha256 arm64_big_sur:  "886ce957a8d8934a9aa50f3acdb73bced276522ddabbffc8f263df416439e3da"
    sha256 ventura:        "5c20711f2bd1d17946707eacd2a6f3ff07396dc18127b08a75480e57e87af010"
    sha256 monterey:       "44c19f7b05600b0a964766803fa07ec80207b9750c31954903958161051e263c"
    sha256 big_sur:        "f678d33776b5b60230b4121d17d58799fcfaafdeffd68f1fa45eaf54fb985abb"
    sha256 x86_64_linux:   "1b21413ff1f71e0efcdf5996e4ae3b299b49e60ad3d4384e7b11c3f7234b9e8d"
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
