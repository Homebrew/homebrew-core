class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  license "EPL-1.0"
  version_scheme 1

  stable do
    url "https://www2.graphviz.org/Packages/stable/portable_source/graphviz-2.44.0.tar.gz"
    sha256 "9aabd13a8018b708ab3c822de2326c19d0a52ed59f50a6b0f9318c07e2a6d93b"

    # Fix compile on macOS.
    # Remove with the next release.
    patch do
      url "https://gitlab.com/graphviz/graphviz/-/commit/4b9079d9fc8634961d146609a420d674225dbe95.diff"
      sha256 "689b54eda5b19e92cd51322c874116b46aa76c5f1b43cf9869fd7c5a2b771f0f"
    end
  end

  bottle do
    sha256 "b7622910804f75702b6124ed0a376f7d4f1c8aaa8dde38601549bb4c9a84589b" => :catalina
    sha256 "cadbefa8657abfbc63d66827ca1492226d10fc6fdba9276f41e62be3b9434ba2" => :mojave
    sha256 "c3b0269db2fb418c0e1b7413f10e0bec2d4f69485cfda484e8acf99cb1b86a54" => :high_sierra
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
  depends_on "pango"

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
