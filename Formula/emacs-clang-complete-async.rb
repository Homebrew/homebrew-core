class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  revision 5
  head "https://github.com/Golevka/emacs-clang-complete-async.git"

  stable do
    url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
    sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  bottle do
    sha256 "18f453799c1a970ed786f58def3826c9ad07d67fd099a3335f42bb9f08c4d60d" => :mojave
    sha256 "0ba317a80f92e3edc59b0e9205cd4854f2b8debcec89e7844c6c4a82570b9b1e" => :high_sierra
    sha256 "75d385e6d09ad1ca380891f2835d07ba1eaf3091ab0d82d063a4c977464d5cd0" => :sierra
    sha256 "9501489cb080eef8a51eb5d3891df8d75f1ccb2211b5d1e95e4ac52c031ab191" => :el_capitan
  end

  depends_on "llvm"

  # https://github.com/Golevka/emacs-clang-complete-async/pull/59
  patch do
    url "https://github.com/yocchi/emacs-clang-complete-async/commit/5ce197b15d7b8c9abfc862596bf8d902116c9efe.diff?full_index=1"
    sha256 "ba3bbb1ebbfdbf430d18cc79b9918ca500eb4d6949e0479a24016e46fe5a920c"
  end

  def install
    system "make"
    bin.install "clang-complete"
    share.install "auto-complete-clang-async.el"
  end
end

__END__
--- a/src/completion.h	2013-05-26 17:27:46.000000000 +0200
+++ b/src/completion.h	2014-02-11 21:40:18.000000000 +0100
@@ -3,6 +3,7 @@


 #include <clang-c/Index.h>
+#include <stdio.h>


 typedef struct __completion_Session_struct
