class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.4.tar.gz"
  sha256 "b5ee5f5c5e025eb2733ae3af8d4c0e53bb66dff35095decfd377f1083e8ac9be"
  license any_of: ["CC0-1.0", "Apache-2.0"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e837d3aa36fb1e776dddc4aec4a0d74ae0dff19f58367a5d704db4953708c82c"
    sha256 cellar: :any,                 arm64_sequoia: "06bea5c3e886103bc8dc8e8175c23f2e19266ef437bbde9ea561f96c2ae3f31b"
    sha256 cellar: :any,                 arm64_sonoma:  "80cf11c7cb7e014b5506c3ca3b196d32ef65aa5b33a23818cc831baaebe59601"
    sha256 cellar: :any,                 sonoma:        "a3a0bb10da7efcd93ff9a7c6fc48a6baa647bd187d353f235a22c63e88a55387"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "177bef680538a691f70199802fd6ce9f42541daaec879b7870eef0905ce883ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "873eca1bee8c7c5081b4e0dfb7d27e5fbd5922b8bd668bd3b3af43dc7ecec634"
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
