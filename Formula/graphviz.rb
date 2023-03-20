class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "7.1.0",
      revision: "e650d3ba65f6d672a1fe09505bb576d4fed320bc"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "8f42f2e0db33e105b865830b59e9e5b4f4a467b03c696ab05ed3a5dd8509f6e8"
    sha256 arm64_monterey: "8c4dba8b1b5aea545a1ef92dd9bf5280135a0ac0fa368c0a421d6987934f5063"
    sha256 arm64_big_sur:  "770bb46c1fb618ab107dc7772c006b3ee3040c4d261dd1e1a715424f4fcc1d65"
    sha256 ventura:        "523f45619747d194acf888e4fa4d7405b4afd51546341b07a1ae5aa661fbcb38"
    sha256 monterey:       "142317a4a3c9342bbb08d973ae167a5eeb3c6c73a9a8207999602477b9187ec5"
    sha256 big_sur:        "9497da9a2ba4ef8aa0a6540897945ee87a5df345833b75632bad550d0ffee803"
    sha256 x86_64_linux:   "40b2a381152cdd1829408f79eeb6be9ac35f683be4c59fd8ec6cdebe197c8859"
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
