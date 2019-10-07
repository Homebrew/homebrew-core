class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz/-/archive/2.42.2/graphviz-2.42.2.tar.gz"
  sha256 "b92a92bb16755b11875be9203a6216e5b827eb1d6cf8dda6824380457cd18c55"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 "9cce10295f139ee106efb2ea147a2ddfe96f3e01019881d4378d1a5f67086ae5" => :catalina
    sha256 "c3e2b2f06d1a2190405ccb16cde3cbddb8bf0be080fb84448a0c43f473eef39f" => :mojave
    sha256 "2972d06c626e9a7d39c06d0376b1b425cae55d0e5d5a56d6f1440783d7e76890" => :high_sierra
    sha256 "3336446bf3ad335583744a88549b19a0bae2fd427270863476c2590a575ff021" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "libtool"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --with-quartz
      --without-freetype2
      --without-qt
      --without-x
      --with-gts
    ]

    system "./autogen.sh", *args
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
