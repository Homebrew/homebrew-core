class Cmigemo < Formula
  desc "Migemo is a tool that supports Japanese incremental search with Romaji"
  homepage "https://www.kaoriya.net/software/cmigemo"
  license "MIT"
  head "https://github.com/koron/cmigemo.git", branch: "master"

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cmigemo/cmigemo-default-src-20110227.zip"
    sha256 "4aa759b2e055ef3c3fbeb9e92f7f0aacc1fd1f8602fdd2f122719793ee14414c"

    # Patch per discussion at: https://github.com/Homebrew/legacy-homebrew/pull/7005
    patch :DATA
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b8bf233fe044c8a2bd5bc24fc9bf11eed7aeb0464f67bd7d7ad48f6d9e8edbbf"
    sha256 cellar: :any,                 arm64_sequoia:  "68bc0630d1414e71d16c8a0f39add12897a7f874119a8eeae19e44f28df8706c"
    sha256 cellar: :any,                 arm64_sonoma:   "f5e1a00386582c24b8b0659a907f9f92a52aa22a428d054969d180f43d2a340a"
    sha256 cellar: :any,                 arm64_ventura:  "4da77419c2e50f2a97340f7d6ad6a125895c46ed40900ba6c60ffb73256185c3"
    sha256 cellar: :any,                 arm64_monterey: "772f9659f6828e8404a849a9f52accab024a59e012d7b1c671a47facf7afdead"
    sha256 cellar: :any,                 arm64_big_sur:  "231afa328130c08c9ae6429cedbd5221633dca46fa478477f5ff441ec6c1ff8a"
    sha256 cellar: :any,                 sonoma:         "98d5b0ab1db6fa4d3ce9aea1932b88cf9dd973e1130a0fe1a5803bfd69fa8012"
    sha256 cellar: :any,                 ventura:        "20da1760b82a2a4b9857dbddc20f48ea095f655df971cf06d3dcfa9abc2932d5"
    sha256 cellar: :any,                 monterey:       "19cbf239012e58e7d04dafdf6b10b52f46331f1db420343d7a51331f98b86395"
    sha256 cellar: :any,                 big_sur:        "a113cec93a42734d9751b9199f7aef92d77649d7921128f9f04d83260dd0effb"
    sha256 cellar: :any,                 catalina:       "81ea6aecbf5b3dec1ebc423d3503bd134d79f4fbfbb91b291e90c1b5a9fef1a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e6b4c7d33ec77482edaa20121f9060c0661de32d941565e67da798e5adc37b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3551bebcc00f059d5acf9e60c4e757596c4c8349cb2870a00fcfdb75aa079db1"
  end

  depends_on "nkf" => :build

  def install
    chmod 0755, "./configure"
    system "./configure", "--prefix=#{prefix}"
    os = if OS.mac?
      "osx"
    else
      "gcc"
    end
    system "make", os
    ENV.deparallelize # Install can fail on multi-core machines unless serialized
    system "make", "#{os}-dict"
    system "make", "-C", "dict", "utf-8" if build.stable?
    system "make", "#{os}-install"
  end

  def caveats
    <<~EOS
      See also https://github.com/emacs-jp/migemo to use cmigemo with Emacs.
      You will have to save as migemo.el and put it in your load-path.
    EOS
  end
end

__END__
--- a/src/wordbuf.c	2011-08-15 02:57:05.000000000 +0900
+++ b/src/wordbuf.c	2011-08-15 02:57:17.000000000 +0900
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include "wordbuf.h"

 #define WORDLEN_DEF 64
