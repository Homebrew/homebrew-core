class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.4.38/libxcrypt-4.4.38.tar.xz"
  sha256 "80304b9c306ea799327f01d9a7549bdb28317789182631f1b54f4511b4206dd6"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a064d22be7cf3136359f8bc7ddfe69d3d1da83cecba23679e8be3d5c3a6715fa"
    sha256 cellar: :any,                 arm64_sonoma:  "70ff0492ab9b04005ac3a10be7b840926e79c8e1005795a245e10a2845741897"
    sha256 cellar: :any,                 arm64_ventura: "b44196ecde239115a28ed7470d21bd679cca173739c24a863ce393df04faffd2"
    sha256 cellar: :any,                 sonoma:        "1eb38a921fe68f9bf101f6ead351a71335a143ff842d1c294a771e1eecfcae88"
    sha256 cellar: :any,                 ventura:       "7876b0bfad028648259367023f14a2fb6c9b13db5e489bf6b002818fe36ec9f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5e89a07cd3d52af14132f1323096d2b0e9519dd71b1b52e192697817547500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1835a4d7d45333637814fbd4d0184d6ebdb81b2e7e4a09e2d803202a497cf8a"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build

  link_overwrite "include/crypt.h"
  link_overwrite "lib/libcrypt.so"

  def install
    system "./configure", "--disable-static",
                          "--disable-obsolete-api",
                          "--disable-xcrypt-compat-files",
                          "--disable-failure-tokens",
                          "--disable-valgrind",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcrypt", "-o", "test"
    system "./test"
  end
end
