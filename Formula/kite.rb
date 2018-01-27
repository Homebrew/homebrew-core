class Kite < Formula
  desc "Programming language designed to minimize programmer experience"
  homepage "http://www.kite-language.org/"
  url "http://www.kite-language.org/files/kite-1.0.4.tar.gz"
  sha256 "8f97e777c3ea8cb22fa1236758df3c479bba98be3deb4483ae9aff4cd39c01d5"
  revision 2

  bottle do
    sha256 "40de335c9146382fe8e2dbb428cbbe81fb5463cdedea0270e043ecffb4b52635" => :high_sierra
    sha256 "80afe502ef94189f6628d9bc33ac95b0271aa07f2e008934a46554b0e2d904a4" => :sierra
    sha256 "7f8adfad9dcdf2d65050099d658e5277de444a69f2953569a93735780354a33b" => :el_capitan
  end

  depends_on "bdw-gc"

  # patch to build against bdw-gc 7.2, sent upstream
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/kite", "'hello, world'|print;", 0)
    assert_equal "hello, world", output.chomp
  end
end

__END__
--- a/backend/common/kite_vm.c	2010-08-21 01:20:25.000000000 +0200
+++ b/backend/common/kite_vm.c	2012-02-11 02:29:37.000000000 +0100
@@ -152,7 +152,12 @@
 #endif
 
 #ifdef HAVE_GC_H
+#if GC_VERSION_MAJOR >= 7 && GC_VERSION_MINOR >= 2
+    ret->old_proc = GC_get_warn_proc();
+    GC_set_warn_proc ((GC_warn_proc)kite_ignore_gc_warnings);
+#else
     ret->old_proc = GC_set_warn_proc((GC_warn_proc)kite_ignore_gc_warnings);
+#endif
 #endif /* HAVE_GC_H */
 
     return ret;
