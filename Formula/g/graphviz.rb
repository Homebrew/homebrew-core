class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/13.1.0/graphviz-13.1.0.tar.xz"
  sha256 "13339b83ee5467001a035cfacd175702ac4b14f5d390f0d34e89437b29881278"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e799e4a7d2fbcb2b5d322986dea60d4256e8e1b5c1c1ab5480fa7e32d2e405ab"
    sha256 arm64_sonoma:  "aaeb1f8883fe316f4792dcf694709b3e5599108f933e8fb2a899aa84becd834a"
    sha256 arm64_ventura: "e3369d0d656b28e413d429b7e3aafba9763faab86b46db568b078fffaa623404"
    sha256 sonoma:        "412dffb92791d044f6f8646c1da51424654283cbfacdbe8ca1e0cbc03b1405dc"
    sha256 ventura:       "b8c3a88a8964f76d576f36fbbaf24aaf5639acd12438be229fad86f77e5414ad"
    sha256 arm64_linux:   "1a6a9fb65405a5bc8ff59c8b350fd41b44d8a607f193546dd94861a08e7dffdf"
    sha256 x86_64_linux:  "541fad631f1c345ee2d98d551be029ae011098cd673fb9e377e47bad3e032b0f"
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
