class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/16.1.1/graphviz-16.1.1.tar.xz"
  sha256 "52e7fb9a57b52b5c67f41dba6504ba3231e118258779421cb8f4f99104de71f6"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 2

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a865cebf76aad452afc0fa52786a03f31992df93246b9957ef82ae81007acd57"
    sha256 arm64_tahoe:       "bc761aaa9b27619351aa2bce0417a47adfb00e4196dfaac28716490c2acc035c"
    sha256 arm64_sequoia:     "65baed923de3296d95353216d37fe1915126089336bc3b2a805a98888b0925fa"
    sha256 arm64_linux:       "958fcd99d2d5b2ebf75a974e82c8f274e9239597972751058342787444ad2033"
    sha256 x86_64_linux:      "79e0c313d190899f6d38e8222fbdc857f2d5fe6a2859e9c673b1877961da724f"
  end

  head do
    url "https://gitlab.com/graphviz/graphviz.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gd"
  depends_on "glib"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"
  depends_on "webp"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "expat"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "gascity", because: "both install a `gc` binary"

  deny_network_access!

  def install
    args = %w[
      --disable-silent-rules
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

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.dot").write <<~DOT
      digraph G {
        a -> b
      }
    DOT

    system bin/"dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
