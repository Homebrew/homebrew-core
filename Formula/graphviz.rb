class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "5.0.0",
      revision: "f7e586644a2665a69eaac4248977f438feda2a18"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "1bdcf7a0252caf046e2c819c6c828156701bf74fe78ab1271f34a54c2808fb1b"
    sha256 arm64_big_sur:  "e5c7257512297971fe0a95b519919a36aec8b5fc9fb95051b1a051f5da9c600e"
    sha256 monterey:       "8df16a221a8a93639b184e337480d6dffcd75cc941ded49f7104e58b3926153d"
    sha256 big_sur:        "dcdf3e025344e9ea8704bd9eefb35082fec71fab5d923b758365238fce92f6fb"
    sha256 catalina:       "e745aa705e0e32c63667bae0930ee016829eb48b59cc7c26adec2524e0e0f483"
    sha256 x86_64_linux:   "ac3ea21ce72aa1f89fbd2d9d4561509bea96ec8269d36ef78d6c01020935886d"
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
