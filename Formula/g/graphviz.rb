class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/15.1.1/graphviz-15.1.1.tar.xz"
  sha256 "afc7c28dd43d3639910f58820bdce7d89655aa9ac0a4961ac67ffcf77e6a9ac3"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "19c0fafefc3e9732beb182d17baf39b83188f998ba450fb29db70b4671385e58"
    sha256 arm64_sequoia: "537e91b292ad608e308e051de32158540a8254a655785665be939d85e90fa7f8"
    sha256 arm64_sonoma:  "322d12799ff9a06979970e820d6c161c7f251746fc3b2c6930b2e566d69c48bf"
    sha256 sonoma:        "99adaa05b653b77085ce3efac33c0974e863b1cfbcf738a24777b4c0d4f8ebcb"
    sha256 arm64_linux:   "c3bf965a92f628e3a07fe7acf2cbbe94cf99e14dfa537a788afeb1c185948e8c"
    sha256 x86_64_linux:  "716a6582df2b9211ff6f0f11a7758fd3639c69f452baee5caac895a2999c0ce9"
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
