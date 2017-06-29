class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  revision 2
  head "https://github.com/Golevka/emacs-clang-complete-async.git"

  stable do
    url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
    sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  bottle do
    sha256 "0255c8398339fe0382ee7c42c5ebc4900ebcdd2fe9c33d9b8e26aa80bc31ef70" => :sierra
    sha256 "0cb9c1647dbd3d904942000d48df978d2f7fa2c97d83a296a031492b791d3ecc" => :el_capitan
    sha256 "1f876df4d7ac08883b365dbbf03e8a4ea905bfbd98aff14d85441f4e51e762eb" => :yosemite
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
