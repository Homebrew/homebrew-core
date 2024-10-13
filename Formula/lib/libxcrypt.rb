class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.4.36/libxcrypt-4.4.36.tar.xz"
  sha256 "e5e1f4caee0a01de2aee26e3138807d6d3ca2b8e67287966d1fefd65e1fd8943"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "481c5b702d575bfd810c213ea54a7fceb0fd03ae4ab4946b347a2816036f3463"
    sha256 cellar: :any,                 arm64_sonoma:   "605b2d35f9ca3ef6adb5d0d4a9f0de1549d00bff742b8243fbb14e1dae38dee9"
    sha256 cellar: :any,                 arm64_ventura:  "95e6481674d9f4cd29bdeb45f0efb5eda7c96cab827212acceda923d27a52a66"
    sha256 cellar: :any,                 arm64_monterey: "aecdd70eeff240670db9c78bb147623ba1d23e2b2ebbe7cb92e57ea1d03b8d20"
    sha256 cellar: :any,                 arm64_big_sur:  "81f38fded3d8f8a10657051bfbe8a0660b5b60d691c42177638c72d6181e092e"
    sha256 cellar: :any,                 sonoma:         "d918088f5ae5c728ee3da95dbff9b4eb2454c2d9b6cb0a61aa1b20aaa67c6428"
    sha256 cellar: :any,                 ventura:        "6fc07249ae12fef0b10f26aa56d3a52b26c285593ed416d6cb5589e8455c58b9"
    sha256 cellar: :any,                 monterey:       "92fdac7885e9f441437725c76059b58386445951fec07bad2bc88af873333e2b"
    sha256 cellar: :any,                 big_sur:        "ca6918b378488e583071841562c5ce1632053124b2916951bb968478033b99f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad1c4b570d7a66046038c13345b54337d858a2db78dcfb7e90a2b21adc1d6802"
  end

  keg_only :provided_by_macos

  link_overwrite "include/crypt.h"
  link_overwrite "lib/libcrypt.so"

  def install
    system "./configure", *std_configure_args,
                          "--disable-static",
                          "--disable-obsolete-api",
                          "--disable-xcrypt-compat-files",
                          "--disable-failure-tokens",
                          "--disable-valgrind"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <crypt.h>
      #include <errno.h>
      #include <stdio.h>
      #include <string.h>

      int main()
      {
        char *hash = crypt("abc", "$2b$05$abcdefghijklmnopqrstuu");

        if (errno) {
          fprintf(stderr, "Received error: %s", strerror(errno));
          return errno;
        }
        if (hash == NULL) {
          fprintf(stderr, "Hash is NULL");
          return -1;
        }
        if (strcmp(hash, "$2b$05$abcdefghijklmnopqrstuuRWUgMyyCUnsDr8evYotXg5ZXVF/HhzS")) {
          fprintf(stderr, "Unexpected hash output");
          return -1;
        }

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcrypt", "-o", "test"
    system "./test"
  end
end
