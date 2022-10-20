class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "6.0.2",
      revision: "fc13ea9684066d28b3bcb61670202d28c6110d60"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "c588135346970f3afb8b5bfb00b36f51e0ae161e88cee3932da9ec5034f7a024"
    sha256 arm64_big_sur:  "e32d033b450a6f8caf5b6c38a0fc117af862f736ba6537a632d6135d707bc3a8"
    sha256 monterey:       "7cc5b7de1813e54b322b49fca4a6ebfaa0671611ab52c4c87fd534f67544e640"
    sha256 big_sur:        "ba4d3e59a7edaafae99e063099fa5436433fbcea1d7478d795fbb5291d9ff45d"
    sha256 catalina:       "69de8aaaba70f3ca896b1c1d59fbe853641c8b2eaa3189ce2007e36c5b856d8b"
    sha256 x86_64_linux:   "2393110242bbc0f172499842f7132eb173d6cdb6eadc1d8930f9ad8d16cc63ae"
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
  uses_from_macos "python" => :build

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
