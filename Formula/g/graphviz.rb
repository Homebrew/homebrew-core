class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.0.5/graphviz-14.0.5.tar.xz"
  sha256 "0dc035352de489eff466c4f6f03bb5a163d7a35f3785de52c0beef1059c35277"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ed48d344872f7319150590938e54632889c874f89f95f4c365642f90c293f647"
    sha256 arm64_sequoia: "387a27cf4079547d66827828bc92c65530f8bba4075eccab0ed311f01d41dd97"
    sha256 arm64_sonoma:  "d9631f5059a53dae4ae3c9ef90fdc4f0b6fb12345db63805a703bc253c36abc0"
    sha256 sonoma:        "371d57f1d0b0788bbbd8034514aec4b86d77e0941039753663a8cf243a858c69"
    sha256 arm64_linux:   "e573d8de405403155a140d3c20b533ce102090c43e1eae3694f682a3d429de1b"
    sha256 x86_64_linux:  "86f9e3ac897380665e3d10e3cd844a69c2636fe35b2069822b383d96b90d25f1"
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
