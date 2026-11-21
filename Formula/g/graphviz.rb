class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/16.1.2/graphviz-16.1.2.tar.xz"
  sha256 "9780938f03659e2effbbfbbaec94940108e794199b73196fa339ca911890e8c9"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 2

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "08d538760f0712d1ad95725c4cb6e46d5835f6896de818b068fc797d1f069ea3"
    sha256 arm64_golden_gate: "7321ae8d9beb275809a7f291ae992bba3b5c7c3f7981795870b2b6f5c215e8af"
    sha256 arm64_tahoe:       "7ba1d8a29af2f4e7a9edd2bcb68cfd2f110dd4cf61c1f127b608f2ea1e2cdd0b"
    sha256 arm64_sequoia:     "cba731adaa8b4e167f8ac3a07b84f593ec01e0daa6e8ea6aebb1dd712010530a"
    sha256 arm64_linux:       "8d5bd268af48d29ff39773801a309edab91bf15c9ecaa49ecbc59c01c1f91aca"
    sha256 x86_64_linux:      "d4e16fc9ceb2ed32b19516a805a925a0397557ff8bc96bd4645fbc37a0460a4e"
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

  conflicts_with "gascity", because: "both install a `gc` binary"

  deny_network_access!

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
