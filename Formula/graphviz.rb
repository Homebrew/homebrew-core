class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.49.2",
      revision: "cf96d517357e42b00279cacc042ec0c0bd2a5e89"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 arm64_big_sur: "38a15a4c92697a5687a01e353a9ef2a4bdcf9985a4c5855c00286a0a503b27aa"
    sha256 big_sur:       "8b19b59f00d6ade978359b8dede760da5b3245ad060f924cef32e4d7f01d2363"
    sha256 catalina:      "f8519ea03d5b71c213bbf0b637eb143ab542039df80bc2941de5aa9c01fd39f2"
    sha256 mojave:        "503c919bc6fc3b24dd6a777ec21c213ca23a6e32b82247a474b0f222a465378a"
    sha256 x86_64_linux:  "473c98095450dcbc1e68730da7bf9f817db5b0438850e6eb3547ac921c21ba27"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "byacc" => :build
    depends_on "ghostscript" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --disable-tcl
      --with-quartz
      --without-freetype2
      --without-gdk
      --without-gdk-pixbuf
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-gts
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"

    (bin/"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
