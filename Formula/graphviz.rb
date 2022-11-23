class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "7.0.2",
      revision: "d0d7dfca5824e1ba0f62cfe9a3c07447cabad921"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "ebbdea8bb6330188f8cb3d5c0038c09f09eb2e7fd091cae7c57552cb39b50160"
    sha256 arm64_monterey: "fda7e74339989992cf4d4fca89647c7f73bb18861f570477327939cfa0ae4e26"
    sha256 arm64_big_sur:  "7ac6fbdc80251654bff4b1653431db90966dcf529157465602d0e00bd01331cc"
    sha256 monterey:       "ab35ba2102ca64802900db9967d2cd88db2de69c3263250a2b3579ac6207e6cf"
    sha256 big_sur:        "58d30f6a792cfe812197b5610edb126ba3659578fd7617868a6d189def4f5c73"
    sha256 catalina:       "64ead4239a24b0eb7a7b663e10083e369d21f21a801a320070342b5a11ac04b7"
    sha256 x86_64_linux:   "18df558ca8b319f722a924af9e9e7a93450ca380f906b27e358d136b1b789bb7"
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
