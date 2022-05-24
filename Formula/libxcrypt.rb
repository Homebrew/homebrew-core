class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.4.28/libxcrypt-4.4.28.tar.xz"
  sha256 "9e936811f9fad11dbca33ca19bd97c55c52eb3ca15901f27ade046cc79e69e87"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c9167b6a2004c17ae0e8c2bfa87b836f46117e2feaf11e81bceb4f10f88a1797"
    sha256 cellar: :any,                 arm64_big_sur:  "379a8c183e939aae7c2cf36e8e4d6f0d4a48663bfd6ba0a07685840a8644ede7"
    sha256 cellar: :any,                 monterey:       "10efe49691ec1185d451d7525597fb8f74de2cad09901d0b0e0ea02b2efffb7c"
    sha256 cellar: :any,                 big_sur:        "bd3ae4e71a255aca43f3ec06111094b6f8d245552388f734c6e4ee2f33089333"
    sha256 cellar: :any,                 catalina:       "bcda7c42bf3a2021aa83bd00a8fcb3158f02e791f792eccceda4257bda67cb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84269a82afe1a9e94ba6828c983a4b8e65d8d672d36d88232daac832017ab327"
  end

  keg_only :provided_by_macos

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
