class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  license "GPL-3.0"
  revision 5
  head "https://github.com/Golevka/emacs-clang-complete-async.git"

  stable do
    url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
    sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  bottle do
    sha256                               arm64_big_sur: "1aa78bbcd4d00d0b93ff4cd24c4c4713937acd6759264e50bc180292ed6336a5"
    sha256                               big_sur:       "9f3d6f44651fe4c55baaa1e75d3948d3506932f669cb02490d2218d2edda494c"
    sha256                               catalina:      "d0582c74bee8c8379cd6aed9d150d38473323fb1993c7219536f1a783d1fadeb"
    sha256                               mojave:        "3e57ed30a99d26abf1dfe26989adfa19b258fe4c7e372eac8469566ac89be31b"
    sha256                               high_sierra:   "628ef0dce4d14042267c54e8baa1c20b594c7853f23ac35c012a5a6a2f506880"
    sha256                               sierra:        "3161dd4faf73ca236e5258011e2bd6229706a01dea444fbd2fa22de05070c0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659cf85abdc84ceff4bce635f4ea700f39e7622c51c20fe4082478f34017104c"
  end

  depends_on "llvm"

  # https://github.com/Golevka/emacs-clang-complete-async/pull/59
  patch do
    url "https://github.com/yocchi/emacs-clang-complete-async/commit/5ce197b15d7b8c9abfc862596bf8d902116c9efe.patch?full_index=1"
    sha256 "f5057f683a9732c36fea206111507e0e373e76ee58483e6e09a0302c335090d0"
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
