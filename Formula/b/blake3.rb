class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.5.tar.gz"
  sha256 "220bd81286e2a0585beac66d41ac3f4c2c33ae8a4e339fc88cf22d5e00514fe9"
  license any_of: ["CC0-1.0", "Apache-2.0"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80e977e2e9668c55d5ca1d53195a04d451c878fe97f4f57e1a172b54f1f148bf"
    sha256 cellar: :any,                 arm64_sequoia: "0a24accc0cda47ffd83ba4668046e3dac514cfd9204596a86b03efe0a900c6bb"
    sha256 cellar: :any,                 arm64_sonoma:  "9ae1041f6e39cb3d9e639aba9908f84d64582292a44de080d4ad4a52ea0a1b94"
    sha256 cellar: :any,                 sonoma:        "d50b522ab3b02bec3489cd6f27d7316cabefa2ad50a367f0d5adb5fa8823cdd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6436d2783c1b7583df65fb3cb8e59112f1344c19f8af9c48cff34d73b7d9ecd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c7ef98730437bd12515491ae32ccade7b4623d4cfaca35d53a711cb577cbe38"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "c", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <errno.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <unistd.h>

      #include <blake3.h>

      int main(void) {
        blake3_hasher hasher;
        blake3_hasher_init(&hasher);

        unsigned char buf[65536];
        while (1) {
          ssize_t n = read(STDIN_FILENO, buf, sizeof(buf));
          if (n > 0) {
            blake3_hasher_update(&hasher, buf, n);
          } else if (n == 0) {
            break; // end of file
          } else {
            fprintf(stderr, "read failed: %s\\n", strerror(errno));
            exit(1);
          }
        }

        uint8_t output[BLAKE3_OUT_LEN];
        blake3_hasher_finalize(&hasher, output, BLAKE3_OUT_LEN);

        for (size_t i = 0; i < BLAKE3_OUT_LEN; i++) {
          printf("%02x", output[i]);
        }
        printf("\\n");
        return 0;
      }
    C
    (testpath/"input.txt").write <<~EOS
      content
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lblake3", "-o", "test"
    output = shell_output("./test <input.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e", output.strip
  end
end
