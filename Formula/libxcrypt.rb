class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.4.33/libxcrypt-4.4.33.tar.xz"
  sha256 "e87acf9c652c573a4713d5582159f98f305d56ed5f754ce64f57d4194d6b3a6f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7cef5fa29821c3e9786693e506adc29fd1917f77f699a31e4512b2bd5c0c289f"
    sha256 cellar: :any,                 arm64_monterey: "aa876651a2ac195bd55bd06931c79de0e32b1ef8ea9b3171f2fdda57825c5977"
    sha256 cellar: :any,                 arm64_big_sur:  "a7539232c00c67015416429f96555539ca8ed040935bb5605f174a1b568c1588"
    sha256 cellar: :any,                 ventura:        "be098fd9a6b06234f68b1344e6eb2646293cbf5704ad4fe06021a4614b737c51"
    sha256 cellar: :any,                 monterey:       "36f09ae68a5cf7356c744f1e1c80c4977cc656e5c1841deee1dc58973ef677ec"
    sha256 cellar: :any,                 big_sur:        "922f1f6216b34a6ece4f865e252f061a57a59770c395f67865a5d407d28b4073"
    sha256 cellar: :any,                 catalina:       "8b414f01813fd8cbbe178baa526d5e33c46dd35d92f7bddd4a923009169c87f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e819c055eef672771e3779771b33892572d7c035316f3f1602d79badc4a8fb"
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
