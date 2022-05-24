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
    sha256 arm64_monterey: "3b575a16d37e23e588a0f3e5d3aca7dea79a541ed1002f1540bc2fc5b2c830ec"
    sha256 arm64_big_sur:  "357e652a052ee9b1de3964c3f01f8d13ce517ddb456ffec56ccb030cca4d528f"
    sha256 monterey:       "647130062b73224aca1d68ec95767d697a0d13c2c648a42dfa88f73815e94568"
    sha256 big_sur:        "1eb4418f89a2d320d1497fad4f78ac0e44fe6e111b3cb87937015457b1fb75f7"
    sha256 catalina:       "211955f9b587b29786b64f1ccb656ec9dfc85538e2ccf2581d6d6fa86c5ccaec"
    sha256 x86_64_linux:   "f7cee7ae761016528d39d9189dc658e4c5f4d758c68dabac282a1017bca26888"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV.deparallelize

    # Avoid -flat_namespace usage on macOS
    inreplace "src/configure", "-flat_namespace -undefined suppress ", "" if OS.mac?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-libffi-prefix=#{Formula["libffi"].opt_prefix}",
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
