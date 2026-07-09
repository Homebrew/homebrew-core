class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/15.1.0/graphviz-15.1.0.tar.xz"
  sha256 "4c44f9f6654d39638db7cdb6a088735117469015299298d82087b24dd4042b16"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "92f027fdb3e41bd3cfb84c2012204690006aa379e8147c82b508c58aaa8ef423"
    sha256 arm64_sequoia: "cb785019f4398ea3edd47004b5e03cbc29e3bad996d8b72f1c1af953a90854e5"
    sha256 arm64_sonoma:  "d6465d942f370e36044b926c4c598a29fc1ffd62efea03d564a663237829123f"
    sha256 sonoma:        "52f464da8597752d1d49f2baf55b0f26a486f0dfead4f5021c421f7a8fc16e7b"
    sha256 arm64_linux:   "03a3ef1baf58963244ba9acde5dc3768c6466b394805d6f007fd8be978eecc8f"
    sha256 x86_64_linux:  "cd63ba4f07170a3d2edf3b307e4503b4e213c2bea5429b09274196cbe01d05cb"
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
    (testpath/"sample.dot").write <<~DOT
      digraph G {
        a -> b
      }
    DOT

    system bin/"dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
