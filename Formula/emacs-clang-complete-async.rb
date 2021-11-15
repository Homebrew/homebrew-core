class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  license "GPL-3.0"
  revision 6
  head "https://github.com/Golevka/emacs-clang-complete-async.git"

  stable do
    url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
    sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "527869861adf5cd506ddfdddcd3c6ea99c501f1e6834f6c91f8172064bc03da7"
    sha256 cellar: :any,                 arm64_big_sur:  "9d8ebc3478af3719304ea88c3b782cdc7344df0d76970d705d3c1468d15d5ea3"
    sha256 cellar: :any,                 monterey:       "b10b046684973fa4ef52c3e501a8b932f98503e32cd60a90aa813cb8a54b1060"
    sha256 cellar: :any,                 big_sur:        "faedcebad555182998cba925ad4bc965d329134320b307f34f17a031e96a3997"
    sha256 cellar: :any,                 catalina:       "69789c4791f2ea78e6e35b20029994ed58b52ecb93d94d45f71b64db67970494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af452df504f3a00eed290079c2e616914a90abc21850de94d769fefb5fa2f572"
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
