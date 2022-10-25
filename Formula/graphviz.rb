class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "7.0.0",
      revision: "fbb04b2847e76a717f22277908eb4b3451fcc63c"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "492cb3a4feb730d2761bad2d0c705353abfe54f8fa9157d5386d799cd392f84c"
    sha256 arm64_big_sur:  "82dc1482b2ad62782a6dab449606088436dbeaee0308e4b5f3b517f9c66f38ae"
    sha256 monterey:       "e968109cfb27992b994cee95cbf43d35eb40993c814363e600b0cbecaa362915"
    sha256 big_sur:        "17796daf1c645e8407dbfe22f367d9663db55d8191d1920c0b85d031e8b94030"
    sha256 catalina:       "3aa822b4b56f311b64437ccd03bba896d8650fe2296a9eee01ec89edb7f397ef"
    sha256 x86_64_linux:   "48d9103e04bf9ac1cf40c74bbdc92d91a5996d945ff41af918f4611be835d974"
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
