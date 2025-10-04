class Libscfg < Formula
  desc "C library for scfg"
  homepage "https://git.sr.ht/~emersion/libscfg"
  url "https://git.sr.ht/~emersion/libscfg/archive/v0.1.1.tar.gz"
  sha256 "621a91bf233176e0052e9444f0a42696ad1bfda24b25c027c99cb6e693f273d7"
  license "MIT"
  head "https://git.sr.ht/~emersion/libscfg", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1dac3227bc441e8972cebc203cb937d98052015d98ee04aa86955b3eeee6f519"
    sha256 cellar: :any,                 arm64_sequoia:  "74d709bca0afdc5fc76a319c6aa32143345c13688faf76817316a4a89537ee95"
    sha256 cellar: :any,                 arm64_sonoma:   "6d14be1b7b275a2200ee9b3805b4e54263a61f59f052103741d54ea9e9e59725"
    sha256 cellar: :any,                 arm64_ventura:  "151dba4fa8ab28312b907dd4598df11c81cd8ed0986987faff0fce50263c49c5"
    sha256 cellar: :any,                 arm64_monterey: "e072b64d3301ffa6537dfd489761f376718445c727ae4a29f8d98e06d9f8de11"
    sha256 cellar: :any,                 sonoma:         "f46bf808c8969460ddbe01818be5a33f0572fe1804be3725e2907499fa820470"
    sha256 cellar: :any,                 ventura:        "bee4bac2d9a37bb294bb16acbc35f857ff2e6990c793391802bcebcfabfaff25"
    sha256 cellar: :any,                 monterey:       "d30ecbf9f5ad0e9c5864a8a5c3412311b983a74bf8dd439f0d5948aa9fb39c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a817080442cc4da90056b4b04736b09b4c7a5a149b53e1929d409d7e646ef4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdab5431a3a4c023c5f31b1728107a988eee126552f1860ffbd2ef588edb1243"
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
