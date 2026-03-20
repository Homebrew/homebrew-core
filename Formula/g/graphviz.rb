class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.1.3/graphviz-14.1.3.tar.xz"
  sha256 "fe76529477c22c0cf833ec5a35b430cf710f4705afc465d86292bf13560be584"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "688ebaa954a60593c897840c5c881c119a183832f42af6ad3c62ed9b6ee5e204"
    sha256 arm64_sequoia: "a3fb247607668a4d9042342515e5162055df356c4e784d299418726fb9a7a7cf"
    sha256 arm64_sonoma:  "4cb2f2c06a8709e5cdc61d0377923e11382b5c5c46994bf43e48f43ddc4ce82e"
    sha256 sonoma:        "599536d416ee8b2bf63bbeefda10ba9ae08b2e4212bdfb2bfecae24a1d350985"
    sha256 arm64_linux:   "003e46d32c7bcc37979bf25ddbf9f1fe9f774e3537d7c72c7c4edd683683b4f8"
    sha256 x86_64_linux:  "492e7dd144e65efcf0020337543c459bac72cae906e697e3f89147183fc8e36f"
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
