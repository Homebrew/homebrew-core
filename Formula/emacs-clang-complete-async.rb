class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  license "GPL-3.0"
  revision 7
  head "https://github.com/Golevka/emacs-clang-complete-async.git", branch: "master"

  stable do
    url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
    sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d98ddff053cb22024c2edf5a57d87f3e0c6ce35a7564cd02d77de2df76617204"
    sha256 cellar: :any,                 arm64_monterey: "35afe0fc0c8a0e576b2dda2f27235d51b993bb125d308b4eca8e8cf785d6feb6"
    sha256 cellar: :any,                 arm64_big_sur:  "9e656250e970d8d29241331c93f8fb96a9bd3ade44a72b96f4dc48341dc1a064"
    sha256 cellar: :any,                 ventura:        "d6b9df18bb4f4a75278afdb31ee7dac53b969205da6169c9a6cfbe8e9f88d84a"
    sha256 cellar: :any,                 monterey:       "c0369e9c9f3478cc55864811ddfd144cbdfedb5468c35dd7ed638792f7a22c98"
    sha256 cellar: :any,                 big_sur:        "0cc47180b3732f46e0d5fd3e551cf22f4d5a73a089b841a213b3df29e5999e07"
    sha256 cellar: :any,                 catalina:       "fab75b269e2d7d3a1f8560579f3e845b0fcbca3202a3d384510a9c8bb22705b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40581606a267a0ae64dc7f85c994f7d6eb80a2c50c1ffd9dfa92a2d985ce80d1"
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
