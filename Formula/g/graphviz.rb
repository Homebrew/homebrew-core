class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/13.1.2/graphviz-13.1.2.tar.xz"
  sha256 "2229ae9265eb51967841fb43c150dd253f26f51ab5c854ce103f665aaf948b1e"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "69ffbaf032d6c2c422fb6747152b99b6ef64d3e53ab65cd3c1c426936ded0d45"
    sha256 arm64_sequoia: "4a62919e10d2a3e9c4371336d8c74e056b4624c00fc212b938fca3b632b3b715"
    sha256 arm64_sonoma:  "6be356c50912ff25716e6f4c981146d9c1dc11cf98c3a40201daa8d38012d9fa"
    sha256 arm64_ventura: "322bda6bb3c250556f6a24e737aea7f75aa9b340bbad84b5e75d0338609a1a61"
    sha256 sonoma:        "786223d3a374f55aa30a0b5353dbb4a6e803ca768ac6156a094a4112e4adea86"
    sha256 ventura:       "6ed3a9c317d65015650202ca0fad935f371aec544a2d5c57778369290fa5bbb7"
    sha256 arm64_linux:   "69fac75eb1e4be37bf8de1ca8f401357d314f71385afb6d9ec3513f4e6a67676"
    sha256 x86_64_linux:  "d5aa9726b12d0759d8ea65816c0bb2cd08c00476b135381a4bf3d8a4e5f1110a"
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
