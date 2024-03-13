class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.1.tar.gz"
  sha256 "822cd37f70152e5985433d2c50c8f6b2ec83aaf11aa31be9fe71486a91744f37"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5654ab78f8c7fd6f55cb0d2103f11becd02c04cf9362ed57751b624793774ee0"
    sha256 cellar: :any,                 arm64_ventura:  "e59ac72e04980fb310ced2cc7912c5c86950b39ccc81e286a4ffe222ef653f51"
    sha256 cellar: :any,                 arm64_monterey: "8487a126819d36da442ceeeb3c1af4fd1ff5255cedf7ced3f12be817a043fa89"
    sha256 cellar: :any,                 arm64_big_sur:  "0d5d99d1b8330e0a42b29b047d0b139e35f1b34709efae83d67cd4ce33d34a05"
    sha256 cellar: :any,                 sonoma:         "0cfd5ea27bca1037d04e6220ccf49cbb6c851ffcd519c8eca51c2febeece73b8"
    sha256 cellar: :any,                 ventura:        "babb670730a53c2ded50ef12a539db9f7692d5a16034e23d6fd2d732f1c5e593"
    sha256 cellar: :any,                 monterey:       "cf4edc0afc3fb61589af6340a9516ebeeb6518c148382181b4a823ec198f63bd"
    sha256 cellar: :any,                 big_sur:        "dc0681c2c905aa9c7dc295bfc9ba35900e0423e55816cf3892a9ef683226b9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073d1b30e6ffb685609beb059da688a18f097674c3600555a779faa9bb717a24"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "c", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    (testpath/"input.txt").write <<~EOS
      content
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lblake3", "-o", "test"
    output = shell_output("./test <input.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e", output.strip
  end
end
