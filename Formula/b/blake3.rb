class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.4.tar.gz"
  sha256 "ddd24f26a31d23373e63d9be2e723263ac46c8b6d49902ab08024b573fd2a416"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1572b7c66fd8e1e74db8df0663a0f5f8e8672c6f5617419d3894f1b6d0408188"
    sha256 cellar: :any,                 arm64_sonoma:   "b98d30812404a382e2e0a4128c9c751359f6f5e416ed8be61de0cd70689c0b26"
    sha256 cellar: :any,                 arm64_ventura:  "fa8e067197369778b60dd612db3310e9b97cea62ad449904372b57795438f0c1"
    sha256 cellar: :any,                 arm64_monterey: "55fa7bced465117ebf342d11fa2dca0d466bbe66419fe2f119ed68b0278cce14"
    sha256 cellar: :any,                 sonoma:         "c1dbb15d592fc823840875cc5cc0c98314f88ecf5bdbde7933e949964286ba8e"
    sha256 cellar: :any,                 ventura:        "de367d003e40a75bc3a0649b62e435a6f55ad116f51e79f13c8cf056a34baedf"
    sha256 cellar: :any,                 monterey:       "946aa7915986ed4ba1b2442c1a446358d7e429becd25450585c96f14727164fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1b7ef6252d7f5d1aba488f178a347a90359bb6b759dfc2805e9904784210ffb"
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
