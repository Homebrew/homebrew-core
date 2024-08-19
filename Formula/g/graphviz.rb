class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  license "EPL-1.0"
  version_scheme 1

  stable do
    url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/12.1.0/graphviz-12.1.0.tar.xz"
    sha256 "fa174c57b11f3ca48f096cf3d4dafa695bcc30a6ffea61804efe3f91ed9bc7ba"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "8c0e1b033dfc051343da9263386578280231639b81d2553cdbbe668a1ac6dddb"
    sha256 arm64_ventura:  "3617782e9e225d89eb24b2582b057b69511fcc1b8f6d0b63f7f8a11a0596fb52"
    sha256 arm64_monterey: "927b65455c8ef50fe0f54a7a68bb0338843019f78c9c1c61265052dd3be6bb99"
    sha256 sonoma:         "d26fe0fd87c9c0b8e937e95840991bdd127ef5f0e56c6219e7e82bc7125a531a"
    sha256 ventura:        "a19e53054ffb674cdb8bfdf51b899a4fa1b34ab061140eae25bdce6512fda2b1"
    sha256 monterey:       "b6d7d71800f9bd3c63553501fe9e9ea15498cf3b8a9bb19deb640e3d4ac3fdde"
    sha256 x86_64_linux:   "4ed2808ee6781e6d7d4623c358eaf0be7e2cfde1f9aac273daf93376dc774732"
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
