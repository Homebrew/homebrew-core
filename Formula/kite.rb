class Kite < Formula
  desc "Programming language designed to minimize programmer experience"
  homepage "http://www.kite-language.org/"
  url "http://www.kite-language.org/files/kite-1.0.4.tar.gz"
  sha256 "8f97e777c3ea8cb22fa1236758df3c479bba98be3deb4483ae9aff4cd39c01d5"

  bottle do
    sha256 "b431d9a70177ca5f5b14cadf9d91efe73cf448583f5326767fd6c492cd032f5e" => :sierra
    sha256 "9e2e8d816c2ad95f0b1cb25a457f12e47ec5e1d73ea5bbb65d9655aec9ecbe6b" => :el_capitan
    sha256 "2833a3382b4fde542e4e5277e4f4dec6e0d9f1beb74c905db525b37e226a638f" => :yosemite
    sha256 "55688f9323627d1ef884615c6de641885b1fc60031522ae584ce5ee54941fa87" => :mavericks
  end

  depends_on "bdw-gc"

  # patch to build against bdw-gc 7.2, sent upstream
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
