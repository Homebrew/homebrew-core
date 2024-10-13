class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  license "EPL-1.0"
  version_scheme 1

  stable do
    url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/12.1.2/graphviz-12.1.2.tar.xz"
    sha256 "cf9e6de9d5949dffbc4dd46f833085ff8e7e55482ffb84641819bbf0d18c5f02"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_sequoia: "accd5d178bdc7bbebf1be68d9fbe1402da214ef68e8765118f7a7510b070bc1a"
    sha256 arm64_sonoma:  "14e7491fe5b85a4890e8e01b32de20960588d5bcc647fa74055c81e452decc87"
    sha256 arm64_ventura: "5a42be5c7498cd9d7bbc4af699ab0a3336d705a65a5e7f3a6af76eabab62412c"
    sha256 sonoma:        "ebb09e2baaa70735fac3f32dac40632ee84ece1520a18c8faf548a5d11784295"
    sha256 ventura:       "7ad8731d788993b5ebc551038a84ee8864c77e67e922f503cb1559efb7d4ac37"
    sha256 x86_64_linux:  "f04c1a6fb9b7fadbf6d84cdc6ab1d27a9112957e1733a960945d07bd732a462b"
  end

  head do
    url "https://gitlab.com/graphviz/graphviz.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
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
