class Libscfg < Formula
  desc "C library for scfg"
  homepage "https://codeberg.org/emersion/libscfg"
  url "https://codeberg.org/emersion/libscfg/archive/v0.2.0.tar.gz"
  sha256 "cf37ef00ac8efb28821dac1ad49e2c6b23b242d9d961fab6fcda72fc73a7291b"
  license "MIT"
  head "https://codeberg.org/emersion/libscfg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2fe577dbd81fcd64b6ac33853c187e28069ff167363f8be5d6ac3507b3cb1f6"
    sha256 cellar: :any,                 arm64_sequoia: "44fcdc6be6a0003395e4ddacf2c33f312e918c5ede3b88455de3b1bcea6a6a73"
    sha256 cellar: :any,                 arm64_sonoma:  "8a889b0add828e0e7c3b723a464c40ddb74659e7058d14eee49108eedaa28e24"
    sha256 cellar: :any,                 sonoma:        "34604bad443610829eb83ba2d145c931f279ec1f12dda0665e5a5496c4164656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "741d76d2418edf9de7c2b1b1b343982ed7132d16ea88417d8629e746841fe8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f8785fc852815aac74b2ee236e1ee4ea058deae1d83546cebfe98b665dc4533"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cfg").write <<~EOS
      key1 = value1
      key2 = value2
    EOS

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include "scfg.h"

      int main() {
        const char* testFilePath = "test.cfg";
        struct scfg_block block = {0};

        int loadResult = scfg_load_file(&block, testFilePath);
        printf("Successfully loaded '%s'.\\n", testFilePath);

        for (size_t i = 0; i < block.directives_len; i++) {
          printf("Directive: %s\\n", block.directives[i].name);
          for (size_t j = 0; j < block.directives[i].params_len; j++) {
            printf("  Parameter: %s\\n", block.directives[i].params[j]);
          }
        }

        scfg_block_finish(&block);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lscfg", "-o", "test"
    assert_match "Successfully loaded 'test.cfg'", shell_output("./test")
  end
end
