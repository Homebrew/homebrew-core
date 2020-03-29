class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://www2.graphviz.org/Packages/stable/portable_source/graphviz-2.42.3.tar.gz"
  sha256 "8faf3fc25317b1d15166205bf64c1b4aed55a8a6959dcabaa64dbad197e47add"
  version_scheme 1

  bottle do
    sha256 "ad22bb28b684c6fb9c51e32000ada1df8cc2f6f2711f8e85c4599fbb5e213e7e" => :catalina
    sha256 "7f11871b1618a4e005a38462522b251bda2c97701aaa944b77a82e212d928ba7" => :mojave
    sha256 "9b7c8b58ae0ab87ab5af31f6d72c61e9840f3fbb24029156a937bb1d3d75310b" => :high_sierra
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
