class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  head "https://github.com/Golevka/emacs-clang-complete-async.git"
  revision 1

  stable do
    url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
    sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  bottle do
    sha256 "f687621434cde6196cae86145e93bafed9338e2ad688e4f735c6ace2b3fa7e4a" => :sierra
    sha256 "1bb00c471767e0cf5f4308ee93cd9a983e125a553e871803132de4c265d5e097" => :el_capitan
    sha256 "561dc57692f71d0ed1fd64568e8b2a8dadd95dc4e90c8f2ffd43aa2e9a363ff6" => :yosemite
    sha256 "71eb2c1de91d5704d933ee259dbdaeb43be717ebcb7ec18d3dfc5c43db220f3e" => :mavericks
  end

  option "with-elisp", "Include Emacs lisp package"

  depends_on "llvm"

  # https://github.com/Golevka/emacs-clang-complete-async/pull/59
  patch do
    url "https://github.com/yocchi/emacs-clang-complete-async/commit/5ce197b15d7b8c9abfc862596bf8d902116c9efe.diff"
    sha256 "6f638c473781a8f86a0ab970303579256f49882744863e36924748c010e7c1ed"
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
