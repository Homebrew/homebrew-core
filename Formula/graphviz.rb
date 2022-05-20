class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "3.0.0",
      revision: "24cf7232bb8728823466e0ef536862013893e567"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "c3735f9c7a06e03d883a330fc7bf0cb997c2041d86a358f793fe2f0fcd967ade"
    sha256 arm64_big_sur:  "f43ff5e042bb74b1e5a5f005d2ecb7ed731886884d5c897b9a3f89881d68e511"
    sha256 monterey:       "1111378fa7618775b3263c211789f4995f07f02252a4464ed2ceb3c01708213c"
    sha256 big_sur:        "59ab5de4deaad4b07149471b7013500e7595c9f6bdff0074e2339d3087aa78ed"
    sha256 catalina:       "8bfb00c8e472b66a72f1c69ddc21abb8ba4891388d3c94b23000a3c0744704a0"
    sha256 x86_64_linux:   "293374d97d2af3bfb5a2d6cc6d21438b356943980f791bf0391c5d1db84bfb20"
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
