class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://www2.graphviz.org/Packages/stable/portable_source/graphviz-2.44.1.tar.gz"
  sha256 "8e1b34763254935243ccdb83c6ce108f531876d7a5dfd443f255e6418b8ea313"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 "e1cc69e09c92ac1507e461e374de9a0b2d7b01d15e29bf43808f8f458303c67f" => :catalina
    sha256 "facbce9f3c97e2ad4b0ebf7344da4937722d6ae03c2091853c0bdd4f0e313e08" => :mojave
    sha256 "86d0bb5111d0f97f4de3b1542280815f0b11cfda64bdbea09ba6ea2764205b8a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build

  # See https://github.com/Homebrew/homebrew-core/pull/57132
  # Fixes:
  # groff -Tps -man cdt.3 >cdt.3.ps
  #   CCLD     libcdt.la
  #   CCLD     libcdt_C.la
  # false cdt.3.ps cdt.3.pdf
  patch :DATA

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

    system "autoreconf", "-fiv"
    system "./configure", *args
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

__END__
diff --git a/configure.ac b/configure.ac
index cf42504..68db027 100644
--- a/configure.ac
+++ b/configure.ac
@@ -284,8 +284,7 @@ AC_CHECK_PROGS(SORT,gsort sort,false)

 AC_CHECK_PROG(EGREP,egrep,egrep,false)
 AC_CHECK_PROG(GROFF,groff,groff,false)
-AC_CHECK_PROG(PS2PDF,ps2pdf,ps2pdf,false)
-AC_CHECK_PROG(PS2PDF,pstopdf,pstopdf,false)
+AC_CHECK_PROGS(PS2PDF,ps2pdf pstopdf,false)

 PKG_PROG_PKG_CONFIG
