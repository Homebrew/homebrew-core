class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  license "EPL-1.0"
  version_scheme 1

  stable do
    url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/12.2.0/graphviz-12.2.0.tar.xz"
    sha256 "66d4acc201536a378a28d5254deeec8cf3e98cc66d7e4cb1cbfa5fc620f86474"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_sequoia: "1a7f3dcf7da1766a1012e355d496ea66e595b7cd8e9c2fb9bf5a01cbe8342ea1"
    sha256 arm64_sonoma:  "239f9100b66e90cecd14c2d9d5297739cba49156b3d48b18fc73041e44794fa3"
    sha256 arm64_ventura: "ae00bb03d4710e302150e187886b1e03a94afb5db73a57583a2d5a81fcc7f331"
    sha256 sonoma:        "4130ae1666f1ba2654e3a273030e38a01c48f89a92920af712e90bdc8573daaf"
    sha256 ventura:       "434816d6367af81bdb41ed1778ae9c4982e18b2c563b54bfe739d99fe00c4df6"
    sha256 x86_64_linux:  "3613779d7832d4e4d0a6ccd4e05ec94a613bcbd238709ffc6d4e11f0dd3e073c"
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
