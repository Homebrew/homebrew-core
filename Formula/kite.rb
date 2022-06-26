class Kite < Formula
  desc "Programming language designed to minimize programmer experience"
  homepage "https://web.archive.org/web/20200217045713/http://www.kite-language.org/"
  url "http://www.kite-language.org/files/kite-1.0.4.tar.gz"
  sha256 "8f97e777c3ea8cb22fa1236758df3c479bba98be3deb4483ae9aff4cd39c01d5"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256               monterey:     "941bc654ba679eee9d935a158acbfd26f3c73ccd0cf4c92d230fd068938e9cb5"
    sha256 cellar: :any, big_sur:      "e42d72077eab99bf9765a87691d809c953ab94bd36c65b1dd51a6f681a3962fe"
    sha256 cellar: :any, catalina:     "34c4f01c0b9290e11773e9bd9f971bdefd47dba7d2bd9023aed4fb0b50738184"
    sha256 cellar: :any, mojave:       "45a37540be7705e4daca4716415228a99a6ad77ec46d4916834cce0f71f7f08c"
    sha256               x86_64_linux: "45184970c4f76d2230063944b65f3f8b48fa90c8860dc502f6f677db03269a63"
  end

  deprecate! date: "2021-02-12", because: :unmaintained

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
+#if (GC_VERSION_MAJOR > 7) || (GC_VERSION_MAJOR == 7 && GC_VERSION_MINOR >= 2)
+    ret->old_proc = GC_get_warn_proc();
+    GC_set_warn_proc ((GC_warn_proc)kite_ignore_gc_warnings);
+#else
     ret->old_proc = GC_set_warn_proc((GC_warn_proc)kite_ignore_gc_warnings);
+#endif
 #endif /* HAVE_GC_H */
 
     return ret;
