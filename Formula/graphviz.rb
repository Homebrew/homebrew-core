class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz/-/archive/2.42.2/graphviz-2.42.2.tar.gz"
  sha256 "b92a92bb16755b11875be9203a6216e5b827eb1d6cf8dda6824380457cd18c55"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 "fd65173d4f2bf9b4412f42939acc10815ba8974f5cdac342a9afd619acc70829" => :catalina
    sha256 "abf938b188d15e2bf1b7447635f1e13a46baaa00f0e38ea6e5122e603f6b491d" => :mojave
    sha256 "df7bafeabe8c94cc513c394ba3fa587ae2b209a25fa42f1b507dfae67029f47d" => :high_sierra
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
