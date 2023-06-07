class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.4.35/libxcrypt-4.4.35.tar.xz"
  sha256 "a8c935505b55f1df0d17f8bfd59468c7c6709a1d31831b0f8e3e045ab8fd455d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27877e1758f120847d99fb7c7dc7213d82d3ec3640b091f2dcc58b0ef5885876"
    sha256 cellar: :any,                 arm64_monterey: "dd9394597082fc8e359393c8fc742610d8f8c2c82c74965d07b4f155cccfeb7c"
    sha256 cellar: :any,                 arm64_big_sur:  "54e5a2a31e5ca8a11f05cf09fef17003eb55393954cfa5bc2281a824b978aabc"
    sha256 cellar: :any,                 ventura:        "ef5532d18a325c1a8285fda1f5e9cdcb1c3ea2892551d17b8f18dc33d7b78743"
    sha256 cellar: :any,                 monterey:       "3b0efab0aadead901227f74cd48a6de6262cf633ea7fbb461f2cd5ceeafc6121"
    sha256 cellar: :any,                 big_sur:        "5f8f20e37db9473fde70092812535f33a7c65a7453076ff652d01d2dcf582c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccd3f6d3d09af37f8275ba1836c5cfb59917143400ec9549033e626d39acdf4d"
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
