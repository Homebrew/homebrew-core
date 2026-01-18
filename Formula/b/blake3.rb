class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.3.tar.gz"
  sha256 "5a11e3f834719b6c1cae7aced1e848a37013f6f10f97272e7849aa0da769f295"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d03ff32973f9c9bd2d13bf2e6f9f3dd8a202aeb15adece0f3c68aabb4fb192ac"
    sha256 cellar: :any,                 arm64_sequoia: "e93d74df84bc4730e302bab4a5a2278ee63968850978355fcfeda870cc92a82a"
    sha256 cellar: :any,                 arm64_sonoma:  "184c47e40d55751ceaa51d9e4d95db25b87a33f702a48f7079bf714ca2bdfc69"
    sha256 cellar: :any,                 sonoma:        "3eb62e0891d816fa1fc1c499887a5af2faee41462a9e26986c7fb69933332531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31e0a06ff7300cfceeaaa677739bced2f2deb9ff860aaedfb14e0ca423288e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93a8cb77d2f071fcf5d2dfea6b6191d291ebf38af76e5bc8c4eac4a8cf185e4"
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
