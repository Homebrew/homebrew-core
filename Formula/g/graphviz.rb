class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/15.0.0/graphviz-15.0.0.tar.xz"
  sha256 "937fe4757687260e46a1c9a171cc677e3d4c89abd1efc8885ccb66467c3616ff"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d9e6126ec4c334ffa46251f345f95c3c7dd569c7ea81be2727829f6508f241b6"
    sha256 arm64_sequoia: "3d19ecab0dcf0e35661f8f80d0cae140c809fd1304ba5aee28d735630fa6218b"
    sha256 arm64_sonoma:  "0a77a1e487198836b7b666c34bee1d07b53abb5f8d769dce2b64ebda2cd9db1a"
    sha256 sonoma:        "5de8061d9582837627ea06f951b45d4339baa5dc7b810bf4c6f831a422dd5a3b"
    sha256 arm64_linux:   "9d53ed2f98c72b819b238d3920512350c0aa3fd837185c86983f1e564d428d50"
    sha256 x86_64_linux:  "29533bee06b915f4cefa8633238c42a2a955a00c29967db35b5a713975fbc41c"
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
