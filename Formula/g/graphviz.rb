class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.0.4/graphviz-14.0.4.tar.xz"
  sha256 "a005977de2fec13753f5bde767cf97fdc28ac54bfd6a2737c563748bc4f32317"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cce0dc29c78a32b066a47802aaaaabf72a7d463adc60142bf5a42ab820e07a31"
    sha256 arm64_sequoia: "6e25e19cc2b16342ef73ffa3c81803851d359735b36fc0d3da428ea0ca62b2aa"
    sha256 arm64_sonoma:  "272258992639d52f83ab17559e227b5026d29f2c200d525def530022dfee5135"
    sha256 sonoma:        "f2d178512138c415d1f91aa66eccf15ad6188e8b4dbf50eb4d20206f63bb8076"
    sha256 arm64_linux:   "5cdc27b9e2f8cf425d1403add65d4767c5234a7b367cfeeb0c63ccd4f26a0bb8"
    sha256 x86_64_linux:  "0c28a182e25425e4fa20d74a971cad8eb072bc55f3209d98b8aaa180e334dfe1"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
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
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system bin/"dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
