class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.8.tar.gz"
  sha256 "a5b927e875e16ebe76bacc1961107d2135637aab39ef227006fea27634e94cfe"
  license any_of: ["CC0-1.0", "Apache-2.0"]
  compatibility_version 1

  bottle do
    manifest_sha256 "4f1dcbc745244c417fcc0adbac7afd0037b1393b02ae645073ef4ba516bbb27e"
    sha256 cellar: :any, arm64_golden_gate: "f652c9fc262ba9c36370f79ad541bcfd25f0a5657db25ab09930dfa5e104f6a7"
    sha256 cellar: :any, arm64_tahoe:       "fef921e381113065838e3bdffb9115784b80caf8699befdae9cb649d2b48a7da"
    sha256 cellar: :any, arm64_sequoia:     "b20bf3f3ccff301131690d322fdddd9ee8f6b2812f7f3ecd44cb62420bf928cc"
    sha256 cellar: :any, arm64_linux:       "4141ed3ebc4ff8865f068a30177ef787b3be51a47c706504e41f2e33e9feef33"
    sha256 cellar: :any, x86_64_linux:      "caf9f69a09729c75298d46a58efc3c3b4bc2194ed1081214ed0f43458bee56f4"
  end

  depends_on "cmake" => :build

  deny_network_access!

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

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lblake3", "-o", "test"
    output = pipe_output("./test", "content\n", 0)
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e", output.strip
  end
end
