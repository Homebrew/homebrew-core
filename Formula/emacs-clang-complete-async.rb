class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  revision 4
  head "https://github.com/Golevka/emacs-clang-complete-async.git"

  stable do
    url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
    sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  bottle do
    sha256 "08dca3de2da57f0e30d45e2b79d3e00c27b8b156d32c156a10538ab066cab9f8" => :high_sierra
    sha256 "5aff677b9a5b7b4204ce2d215c88addb88f33c25cfd58d17c2f90e481f24fe60" => :sierra
    sha256 "cc2e004b547fc63cca8b497c8be80d21862c5ee42d5d4cca62e4f512703982c3" => :el_capitan
    sha256 "4afcd62c7f11cfd189893a4caddda27ed5ceece303e5e7b4526afd89cafcdeb7" => :yosemite
  end

  option "with-elisp", "Include Emacs lisp package"

  depends_on "llvm"

  # https://github.com/Golevka/emacs-clang-complete-async/pull/59
  patch do
    url "https://github.com/yocchi/emacs-clang-complete-async/commit/5ce197b15d7b8c9abfc862596bf8d902116c9efe.diff?full_index=1"
    sha256 "ba3bbb1ebbfdbf430d18cc79b9918ca500eb4d6949e0479a24016e46fe5a920c"
  end

  def install
    system "make"
    bin.install "clang-complete"
    share.install "auto-complete-clang-async.el" if build.with? "elisp"
  end
end

__END__
--- a/src/completion.h	2013-05-26 17:27:46.000000000 +0200
+++ b/src/completion.h	2014-02-11 21:40:18.000000000 +0100
@@ -3,6 +3,7 @@


 #include <clang-c/Index.h>
+#include <stdio.h>


 typedef struct __completion_Session_struct
