class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/16.1.0/graphviz-16.1.0.tar.xz"
  sha256 "0f661718f3e5268dc3bad0fb53ab646605d26db70f4080799aff1dc2f61783c3"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 2

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "95e16aa7a3a16775ed16a50a8d4a5347b8c6edd5604e6006206bfa2b23da2365"
    sha256 arm64_tahoe:       "9fba08a285c160f3c1c5db363b06bd5ffe6b1175c74b6be8d36383d1f1b0ab13"
    sha256 arm64_sequoia:     "2f2c0a364687e48071a527f352024faaad7aacf20e928a1657bc15fd006b9964"
    sha256 arm64_linux:       "14b6558a629a614c57cd4657a04f4d569cc91e91cb4762d207c82d253766f117"
    sha256 x86_64_linux:      "b577048dcf51da574b0d6feaf37ec54ffdffb8c2d69fa96b47767f98316d5448"
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
