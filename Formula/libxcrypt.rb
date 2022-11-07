class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.4.29/libxcrypt-4.4.29.tar.xz"
  sha256 "75ee3cff4821498c52356382c4a1df5799a1bf0d56ac5ea94d9542b7cee9f786"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "355d536ef46ee9ab49b3d4ae4266433f1a876ef41131e711ea4ee0f0aeb7f2cd"
    sha256 cellar: :any,                 arm64_monterey: "51c47d976fb8ee19b38db3d2c8c9a40afcbfc4d4b8f4b6356243c764454f3c8f"
    sha256 cellar: :any,                 arm64_big_sur:  "df4a392059fde19aa843e2e9a5de654206732e9030091c2c2ed8a6825ab15aac"
    sha256 cellar: :any,                 monterey:       "b1961f69c81ef3a90c8d4d8f748438d5fa52359e7a74ea9dbaf79d269eb48bf8"
    sha256 cellar: :any,                 big_sur:        "c32dcaf7bb2f1fe08d0732e9b009233b71b08faca37518c4d4a1f497db5cf438"
    sha256 cellar: :any,                 catalina:       "0ee2220b8fbbf419f8e8103d77be02f4aaad8d273718e1584bb2ef91290b20b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2de70a22e315a97f1d49f5b172e66a4d0e78699381c8c68b87694857081080"
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
