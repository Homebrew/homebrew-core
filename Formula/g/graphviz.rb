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
    sha256 arm64_tahoe:   "b94cc2abc1f05de1bc853b9d401dff2b640607f375694978c4bd657174e0b998"
    sha256 arm64_sequoia: "ba99a58f356b7d1344a2ca4e6ebb20128fd8646bbd4f6c1a957641d931a1d010"
    sha256 arm64_sonoma:  "0d5d7bdb56306e6597627b2ff813397172f3c18086c5b645c19e29e66775a2e1"
    sha256 arm64_linux:   "e7e1467a77d4fb28d222af75ce17f1daacf290e5d45d9e0e4ad3a2f55f919ae6"
    sha256 x86_64_linux:  "31398a8fbcf9bf70f8d38addfe768df93d282b48b5e19a0a19b10cc274527ba5"
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
