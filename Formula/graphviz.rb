class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.50.0",
      revision: "ca43e4c6a217650447e2928c2e9cb493c73ebd7d"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 arm64_big_sur: "437ed6697432b7b5c9b6e4d4e90b5c77ccc35a2e22546463a328425bf7fe9600"
    sha256 monterey:      "3b342e85783dbdc6265f671add55d1293552f673efc293f58fc19b0a4bace1c5"
    sha256 big_sur:       "528774acbc0e94a60c616773771d6ae73830e66f8e6adf7bf888c67947f04902"
    sha256 catalina:      "633d24b7cd2b20b5483f441fd8d7b90d0aaad4574add6ff7d740876a2236fdee"
    sha256 x86_64_linux:  "ad4ba705aa70bfe3dbd607e929e0fb9af02c81104ccd482869acedce8bb0a96a"
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
