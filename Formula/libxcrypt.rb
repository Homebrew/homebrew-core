class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.4.30/libxcrypt-4.4.30.tar.xz"
  sha256 "b3667f0ba85daad6af246ba4090fbe53163ad93c8b6a2a1257d22a78bb7ceeba"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b0411a9c5f0e83bc20b2da0ca51ec46ababdbae2676726f8e8d978f25d83ea4"
    sha256 cellar: :any,                 arm64_monterey: "c4a722e21edac36175956c80012714d7476b53b9182ef3176b93c4a5227a6b3b"
    sha256 cellar: :any,                 arm64_big_sur:  "7c48131e7e7e3ae916c5f0506d5cd68d206fb57fe6c3f21bdaa04402a074fefb"
    sha256 cellar: :any,                 monterey:       "bf14a761837d3de9e5b6d527522db7dd1771ca6ad9645b2cd024a6de33862561"
    sha256 cellar: :any,                 big_sur:        "649e7342c9f290301da598bbfe6046647ec64e9deb273822887ba7c01089fc39"
    sha256 cellar: :any,                 catalina:       "5b14b3e17fbe2925ca518e5836154299443f5fc840b32bc86759cf29f8503134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04bd1d2ae46eb4120621c5f5a7f99bbb47efd0e3474a74d6e9cab0e36361738c"
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
