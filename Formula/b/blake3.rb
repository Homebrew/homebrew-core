class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.5.tar.gz"
  sha256 "6feba0750efc1a99a79fb9a495e2628b5cd1603e15f56a06b1d6cb13ac55c618"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9d053b51e933e41cb5949074ad9a299fd2b31cbd59804a8c853e5e5c85cf6f0"
    sha256 cellar: :any,                 arm64_sonoma:  "0df024291db039b86a0de52917c0ec819085256130547ad0b534d0206a2e0d84"
    sha256 cellar: :any,                 arm64_ventura: "ae11cf3d5117500c362a13b1e3e26df04004e14a2c0739914b81fbef270ccea0"
    sha256 cellar: :any,                 sonoma:        "dd4a5e905c5b2bb06a323ede9c871c3284ba739c8a6934c8443c5ebfe548c8f8"
    sha256 cellar: :any,                 ventura:       "f6f057edf60d9448debbe993061fe1ec0a19f706473a7f99a43cc122ec4ad95b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6138af9754e790d10ef2aa346c41860730a9ebcc1beb1d737ef57e73b1a21cf"
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
