class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.1.5/graphviz-14.1.5.tar.xz"
  sha256 "b017378835f7ca12f1a3f1db5c338d7e7af16b284b7007ad73ccec960c1b45b3"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "40068b6586535cf4cb83b859ba34bebbe86eaf9adf73704c0986411c6bc1144f"
    sha256 arm64_sequoia: "32244b7da39e7c2889e8479ef54a2fe92940d2d0cf8ba75aded5b01f4420cf90"
    sha256 arm64_sonoma:  "1c4742bb2b0967b53c3ad611a0276961d0e14985f8a238ea6572bbd50ff2331b"
    sha256 sonoma:        "a1cf1e88c5c1f32b135776e3b17d9e9720ab85a43d27b209f6557be07ad6f35e"
    sha256 arm64_linux:   "2671201ccac5ede38e9780697dacab56080ce6f9e87d52c4626a55a745401ecd"
    sha256 x86_64_linux:  "c37039d11f3d05417a0d6e4c901df487d29c5db45a1621f454736d5ab7df0377"
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
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system bin/"dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
