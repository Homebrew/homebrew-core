class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.1.4/graphviz-14.1.4.tar.xz"
  sha256 "043877c0857d8d46067cd2f18809d54fc876c399f0ecd438f60ea7f4d8037451"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c4f64883e87d59e4f9d73c99de2e01dac455ac95d5aeae8bec35751d4b5f5a57"
    sha256 arm64_sequoia: "7ebff14775278ad7bf4aff6e2e3cab52c0467bc70c51645cbdb4a05e56146567"
    sha256 arm64_sonoma:  "9b979f9535eebebc93c866903366a13bc28623d0c33cacb9649add73ae472166"
    sha256 sonoma:        "fbc084234f5b8118c60c9ddd52b619919446cd20816ef47763d7f9086bde10cc"
    sha256 arm64_linux:   "4d73b200178583389be54f143d929286a794080370deee3b9edb626607105841"
    sha256 x86_64_linux:  "bfbaf4337c9fe2f1b7c73f11e88f7e6914c764376141800f691fdd47e9305689"
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
