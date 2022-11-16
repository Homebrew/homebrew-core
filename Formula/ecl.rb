class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://ecl.common-lisp.dev"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  stable do
    url "https://ecl.common-lisp.dev/static/files/release/ecl-21.2.1.tgz"
    sha256 "b15a75dcf84b8f62e68720ccab1393f9611c078fcd3afdd639a1086cad010900"

    # Backport fix for bug that causes errors when building `sbcl`.
    # Issue ref: https://gitlab.com/embeddable-common-lisp/ecl/-/issues/667
    # Remove in the next release along with the stable block
    patch :DATA
  end

  livecheck do
    url "https://ecl.common-lisp.dev/static/files/release/"
    regex(/href=.*?ecl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "d1833fcfef55781606e6793becf3f235c6d27b32d65f969f606bfd4c23e654c7"
    sha256 arm64_monterey: "c0e158eaeda959f3502a2c08d9640fdb3d9ed42c4a562d504f883703320952ec"
    sha256 arm64_big_sur:  "06222b960fadf45796e2570b8d1304dc5c111bcb12f216820962020677207ea0"
    sha256 ventura:        "c30e496ebece4e2b03b3ec7f06c1950967be0b2efec95114b60a88a7d50d441d"
    sha256 monterey:       "ebe596bb4a260b50143fff6a4c7b9a215ba37035e7014e661cd801580d40852e"
    sha256 big_sur:        "b7249ea59449d4fc8b3e509f3f61f6c9f660659745ecb30f7dc056e73edde275"
    sha256 catalina:       "c47af2ea084746d721142998ed720ca7c627a428134fe6c1e38e067c5aa24b6b"
    sha256 x86_64_linux:   "c61e19e3dfc2f9e971ecd48ac1eb68246dbd0db41e154c214fe4b2ab20c17695"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  uses_from_macos "libffi", since: :catalina

  def install
    ENV.deparallelize

    # Avoid -flat_namespace usage on macOS
    inreplace "src/configure", "-flat_namespace -undefined suppress ", "" if OS.mac?

    libffi_prefix = if MacOS.version >= :catalina
      MacOS.sdk_path
    else
      Formula["libffi"].opt_prefix
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-libffi-prefix=#{libffi_prefix}",
                          "--with-libgc-prefix=#{Formula["bdw-gc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end

__END__
diff --git a/src/cmp/cmpc-wt.lsp b/src/cmp/cmpc-wt.lsp
index 2f5f406..1a68145 100644
--- a/src/cmp/cmpc-wt.lsp
+++ b/src/cmp/cmpc-wt.lsp
@@ -19,18 +19,7 @@
 (defun wt1 (form)
   (cond ((not (floatp form))
          (typecase form
-           (INTEGER
-            (princ form *compiler-output1*)
-            (princ
-             (cond ((typep form (rep-type->lisp-type :int)) "")
-                   ((typep form (rep-type->lisp-type :unsigned-int)) "U")
-                   ((typep form (rep-type->lisp-type :long)) "L")
-                   ((typep form (rep-type->lisp-type :unsigned-long)) "UL")
-                   ((typep form (rep-type->lisp-type :long-long)) "LL")
-                   ((typep form (rep-type->lisp-type :unsigned-long-long)) "ULL")
-                   (t (baboon :format-control "wt1: The number ~A doesn't fit any integer type." form)))
-             *compiler-output1*))
-           ((or STRING CHARACTER)
+           ((or INTEGER STRING CHARACTER)
             (princ form *compiler-output1*))
            (VAR (wt-var form))
            (t (wt-loc form))))
diff --git a/src/cmp/cmploc.lsp b/src/cmp/cmploc.lsp
index c6ec0a6..a1fa9fd 100644
--- a/src/cmp/cmploc.lsp
+++ b/src/cmp/cmploc.lsp
@@ -181,10 +181,30 @@
 (defun wt-temp (temp)
   (wt "T" temp))

+(defun wt-fixnum (value &optional vv)
+  (declare (ignore vv))
+  (princ value *compiler-output1*)
+  ;; Specify explicit type suffix as a workaround for MSVC. C99
+  ;; standard compliant compilers don't need type suffixes and choose
+  ;; the correct type themselves. Note that we cannot savely use
+  ;; anything smaller than a long long here, because we might perform
+  ;; some other computation on the integer constant which could
+  ;; overflow if we use a smaller integer type (overflows in long long
+  ;; computations are taken care of by the compiler before we get to
+  ;; this point).
+  #+msvc (princ (cond ((typep value (rep-type->lisp-type :long-long)) "LL")
+                      ((typep value (rep-type->lisp-type :unsigned-long-long)) "ULL")
+                      (t (baboon :format-control
+                                 "wt-fixnum: The number ~A doesn't fit any integer type."
+                                 value)))
+                *compiler-output1*))
+
 (defun wt-number (value &optional vv)
+  (declare (ignore vv))
   (wt value))

 (defun wt-character (value &optional vv)
+  (declare (ignore vv))
   ;; We do not use the '...' format because this creates objects of type
   ;; 'char' which have sign problems
   (wt value))
diff --git a/src/cmp/cmptables.lsp b/src/cmp/cmptables.lsp
index 0c87a3c..4449602 100644
--- a/src/cmp/cmptables.lsp
+++ b/src/cmp/cmptables.lsp
@@ -182,7 +182,7 @@

     (temp . wt-temp)
     (lcl . wt-lcl-loc)
-    (fixnum-value . wt-number)
+    (fixnum-value . wt-fixnum)
     (long-float-value . wt-number)
     (double-float-value . wt-number)
     (single-float-value . wt-number)
