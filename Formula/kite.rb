class Kite < Formula
  desc "Programming language designed to minimize programmer experience"
  homepage "http://www.kite-language.org/"
  url "http://www.kite-language.org/files/kite-1.0.4.tar.gz"
  sha256 "8f97e777c3ea8cb22fa1236758df3c479bba98be3deb4483ae9aff4cd39c01d5"
  revision 2

  bottle do
    sha256 "b55449bb1c1b6a3f190926a44dcf090479a190bad3389372157137b46c1e20ca" => :mojave
    sha256 "3b293d215be3d011ec9110b6b3f8fad331f36eb8a4062cafa7c0601315454bfc" => :high_sierra
    sha256 "5f090153489b27969c99e30a3be64e747da75738d9377f830a717bd856df3a72" => :sierra
    sha256 "0c4b034731a0b3fa2f492f1a435122e78bdda3508d778507de3679c353894ad8" => :el_capitan
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
