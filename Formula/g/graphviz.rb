class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.0.0/graphviz-14.0.0.tar.xz"
  sha256 "2e3531733cb584668c09bebd319d42b7284278e7702581b1ffdb279f2acd2fce"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "132eadbf3b9835e35086408b2d13b0c59f62e580d7462418c44ff3e3cb97874a"
    sha256 arm64_sequoia: "a70c98e275abbd55cb32365ac3ebeb52e79fb2610d25d4a55338a5f7c84f5785"
    sha256 arm64_sonoma:  "afc5ef6f2049b03c40cf1e1dac7a0935a056ee1b002d93b8098c7be14a3f95fd"
    sha256 sonoma:        "6a3cb371b12c08888c03ec686f0835403f5600df372afd9a3691f2529e59f138"
    sha256 arm64_linux:   "bd4f6c8dcce98611a2c3f3b540d577688967cc74fc8e2550330a0616878433d9"
    sha256 x86_64_linux:  "a9151746f32af4e4d3ef83529b6e3885cc8526f091e73445ddc5b7b3aae98ca5"
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
