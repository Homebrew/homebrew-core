class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.46.0",
      revision: "4f263aeb7fccdfac1e71a305f437a997385bdf59"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    rebuild 1
    sha256 "b38583d700c03638f21f0e71c53ae61231353aa31fa207cc048063981fab412f" => :big_sur
    sha256 "a7197b21212f9f379306da1acc85f5b2e6764c3575c70f13dfb8cf6dfbd9ccc3" => :arm64_big_sur
    sha256 "3ffa8ff77c3017ebcc9998216a2df08ff461fa3c6866e233c189b9d53cd01b18" => :catalina
    sha256 "ab61b971ce56a1caae7aeff6a4957b1141b4267e232caaf42124378c5708caa8" => :mojave
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
