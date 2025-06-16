class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/13.0.1/graphviz-13.0.1.tar.xz"
  sha256 "eabb50ea256165a072e99c46a00cce9cb9063b6bf6b3bd8e088c9855212b664a"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c5d6cb3dbc7323a80870c1ba9e9c10237db5fe4919d00a67b2145bff48eba46b"
    sha256 arm64_sonoma:  "5db7d6daa4aa3e75b199acf5ff24cabda1545651dde312c771ff10e2ac142509"
    sha256 arm64_ventura: "3a000c9603cf79fe0029e85a38826cea17b785bdfd55607275e5fe87e8c14c80"
    sha256 sonoma:        "ce3e38b6c21e2fac17d11aafce0f9463be29c2718e37aba9eb0922b64937e84e"
    sha256 ventura:       "8893cbd03aaaf9c1861693da71b78bc57981e8d41fdb6831bdd35d2e7c3fef64"
    sha256 arm64_linux:   "cf78490227861bdc8390c4d24a929bb5d166a73cb4a66c3da2e2935b5170ab35"
    sha256 x86_64_linux:  "2759f62c80d2985eceb1ed1d90237bf927f63f968f81fd117994dcacaecceb3b"
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
