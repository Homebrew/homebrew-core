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

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "772f9659f6828e8404a849a9f52accab024a59e012d7b1c671a47facf7afdead"
    sha256 cellar: :any,                 arm64_big_sur:  "231afa328130c08c9ae6429cedbd5221633dca46fa478477f5ff441ec6c1ff8a"
    sha256 cellar: :any,                 monterey:       "19cbf239012e58e7d04dafdf6b10b52f46331f1db420343d7a51331f98b86395"
    sha256 cellar: :any,                 big_sur:        "a113cec93a42734d9751b9199f7aef92d77649d7921128f9f04d83260dd0effb"
    sha256 cellar: :any,                 catalina:       "81ea6aecbf5b3dec1ebc423d3503bd134d79f4fbfbb91b291e90c1b5a9fef1a4"
    sha256 cellar: :any,                 mojave:         "28db47c1cedcff4dc6ee2d48bd07a147ae18f400e035e6a583d6b8e6cb36dfa1"
    sha256 cellar: :any,                 high_sierra:    "a56e9422e30145d388649e9c85bf814adb58688c2c5e374385f4260b8daa049a"
    sha256 cellar: :any,                 sierra:         "612544771bde1676044d35e8cb1f64134788580b76c59ced3b651e8996d46b51"
    sha256 cellar: :any,                 el_capitan:     "866dfa4f493c088c1b2eb3cff23ed04e33862f7bc5dcff0976ce5b7cb4835dd2"
    sha256 cellar: :any,                 yosemite:       "4ab378bb5f5d2462a6043d9226aade8b87974b52a7fec8a24e3814f93ac936f6"
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
    system "make", "#{os}-dict"
    system "make", "-C", "dict", "utf-8" if build.stable?
    ENV.deparallelize # Install can fail on multi-core machines unless serialized
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
