class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://www2.graphviz.org/Packages/stable/portable_source/graphviz-2.42.3.tar.gz"
  sha256 "8faf3fc25317b1d15166205bf64c1b4aed55a8a6959dcabaa64dbad197e47add"
  version_scheme 1

  bottle do
    sha256 "fd65173d4f2bf9b4412f42939acc10815ba8974f5cdac342a9afd619acc70829" => :catalina
    sha256 "abf938b188d15e2bf1b7447635f1e13a46baaa00f0e38ea6e5122e603f6b491d" => :mojave
    sha256 "df7bafeabe8c94cc513c394ba3fa587ae2b209a25fa42f1b507dfae67029f47d" => :high_sierra
  end

  head do
    url "https://gitlab.com/graphviz/graphviz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "libtool"

  uses_from_macos "flex" => :build

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

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
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
