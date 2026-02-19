class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://github.com/besser82/libxcrypt/releases/download/v4.5.2/libxcrypt-4.5.2.tar.xz"
  sha256 "71513a31c01a428bccd5367a32fd95f115d6dac50fb5b60c779d5c7942aec071"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45b16874ed374eda84779a795aa32640f86759dd480f470567949b7639a8e3ee"
    sha256 cellar: :any,                 arm64_sequoia: "04b6d0459d587d4137b8fdc9d7a711bf5df1405afae64997d4d8f6016df50e20"
    sha256 cellar: :any,                 arm64_sonoma:  "6f459775883ffb7e1cd95dfeef36d3f490f20e3dcaa79055d318c46991d31f5f"
    sha256 cellar: :any,                 sonoma:        "909d2e42bae6c62c05e5c52f6f45aa3da6a4c668c6a88f90a0cc6ebb6794f212"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591376dcb066e3abf120b46895aabe9409aadf8f9577bd2672e52524f05a1952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9319e1e70e1e3e476e421956baaeebc0d7be9c3030897844a3c348fe4dd116a5"
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
