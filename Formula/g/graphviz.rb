class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.1.2/graphviz-14.1.2.tar.xz"
  sha256 "65572cd29317cfb96eac8434fac1d8861c905e9b761bd0442beb2cfcc0211354"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "5246c42814bb1ea6af9482fe1c62ce908e3ec89c3a25b04b422421f30a939dae"
    sha256 arm64_sequoia: "7aef01ff2997c74204d194105bd1d3d827e88030a0ffbc23eb55511295eef505"
    sha256 arm64_sonoma:  "13bfe90453c4bee82dee23e6d29b776034fe78349793dbb8ed790f9ebe638562"
    sha256 sonoma:        "733f2e66373f61bc46fb4590b872c8aff2565753677a675d884e734eea87f6f0"
    sha256 arm64_linux:   "0a230485ac10edc495964d50979ce18ab455b4fdec1acf40de13fe4a7cf356db"
    sha256 x86_64_linux:  "c75ba568514630cbbf45addcb852ba71cc50b9270e000efd26e107d76a6ed364"
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
