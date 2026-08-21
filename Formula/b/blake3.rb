class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.7.tar.gz"
  sha256 "c6782a28842b1c0478524ac06a4f2ede784038ee298d6e2162c0b089c4306a3c"
  license any_of: ["CC0-1.0", "Apache-2.0"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "58e8c92c82c52ff4290097cd31c6b6cfc61f9095b8ece8ab4157338f9ebd22f9"
    sha256 cellar: :any, arm64_sequoia: "dcb28e5b04890bd9c788e9ed948ace5c4e1ad7782faec3061e40e20300271204"
    sha256 cellar: :any, arm64_sonoma:  "a3fec96703f5afaa29e78be7a8d00c811d506a6e134d3875349b93e99a3453d7"
    sha256 cellar: :any, sonoma:        "c7611f7cd8e93ecbcf1b9e325e6dfdf2a7b5e2d451321b5e97d9028d17d6b854"
    sha256 cellar: :any, arm64_linux:   "3c09c17aaa702ec0e77d643fb6624042cb852f60a819e300c53bae50b3780968"
    sha256 cellar: :any, x86_64_linux:  "b9de15ad16931c25be34da4f9ede237100aeea4613a4cb8eb415f92c270c9874"
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
