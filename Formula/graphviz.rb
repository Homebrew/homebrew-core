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
    sha256 arm64_ventura:  "a7ff70a9ce1f252dfdb08cc5a27322aee5f2af9ab7cab2cffaf6c2fa9185801c"
    sha256 arm64_monterey: "ecca99b5558884c1d255138faace43ef6fad89270ba215bb4a885a7b29ee16d4"
    sha256 arm64_big_sur:  "0926713b1f47f20e05cb56071fd951fd6e903cb28376e508dfa5449e1229cbdd"
    sha256 ventura:        "23ef592c8cc211d4825c5a895122035c83eee14688d9a8c087b7b78d2dd399b1"
    sha256 monterey:       "6e62d1c95521fb0be40553722a04e8da03cff13f1d7e84c175c47eac239fe3d6"
    sha256 big_sur:        "37333054f6c111ea065d29cf6124875122434c264b7b6d2c78eabc4d82936b12"
    sha256 x86_64_linux:   "01d20f323d5765b14d6afe84321e4655224130a57f818d17bdf356a710cf5452"
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
