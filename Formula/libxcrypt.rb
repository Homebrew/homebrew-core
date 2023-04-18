class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.4.33/libxcrypt-4.4.33.tar.xz"
  sha256 "e87acf9c652c573a4713d5582159f98f305d56ed5f754ce64f57d4194d6b3a6f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4ee3bf38db315e567b4bab44ac9c00c4426a639fbf927504c41e71696c35909a"
    sha256 cellar: :any,                 arm64_monterey: "5b05ce5f75fecd782e3ba5f79e6374366e387aafc2bcd3a3be2f62f8f5630ebd"
    sha256 cellar: :any,                 arm64_big_sur:  "e2ab1dd4cf1eb83ae294eea6573a5cea05b2256369be2ca4648c53e72fa1be60"
    sha256 cellar: :any,                 ventura:        "11fe5967447401b73f5ed9e4354b728b71fb9c7b80cacedce61cb78aea76d117"
    sha256 cellar: :any,                 monterey:       "51cdca6f5314291e1567693e36e79a8f520bb5286b9dcc0a9ac8263679c792ba"
    sha256 cellar: :any,                 big_sur:        "d5fcb26fdfc1c8fe8971593a370795b065845792d9339327c7b79b186a7f7c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809ff345c8f0d705ea1d84f086fe5b19f590b540db3902784db6f6c3c8ecf0b1"
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
