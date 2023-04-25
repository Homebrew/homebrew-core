class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "8.0.4",
      revision: "a2a825846905f05e9b6be4dfaa87c9f96cb43b15"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "94e817aec8e7b9c2236dc4efd15b30859061ddefd0e7b9ec851c612308da510c"
    sha256 arm64_monterey: "2cb7f7d3faae05476ee6a6513ba6bd03150223728f81c4befc39ee9e3b7708ea"
    sha256 arm64_big_sur:  "5abbd090650d5fe979b28058effec41c26dfc3b4ed868913388b8430faba4b2d"
    sha256 ventura:        "4e619c97031b2c51c2a486173827b5ace9086800a922a67a8d99386a575eb03c"
    sha256 monterey:       "109e60acbe344e8d5224c9582fd641cbf694355f0f6259f8d3faf89e21030b31"
    sha256 big_sur:        "c26d986425cbfaf63083f2d1240f98f8fecd0ac8c2441efdd0e5eb37d344f3ab"
    sha256 x86_64_linux:   "7feb8c0ec323db3cafb0c70d09f5999a7646e05126d853fbfda4dfc56bebb827"
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
      --without-gdk
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-freetype2
      --with-gdk-pixbuf
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
