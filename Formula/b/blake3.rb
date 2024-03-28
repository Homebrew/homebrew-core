class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.1.tar.gz"
  sha256 "822cd37f70152e5985433d2c50c8f6b2ec83aaf11aa31be9fe71486a91744f37"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2201b562ac720e557ddcd29b16967231efdb43ced0cb15360b71a8f50ba35d7"
    sha256 cellar: :any,                 arm64_ventura:  "d4d8f65bd488c430e008d1d2248ee700ec6f3e7c775bbf3f853787d176f5bb8f"
    sha256 cellar: :any,                 arm64_monterey: "f5d9b4b1e92f61ba7ebc9ab84aad73641044650b4ed5e66de373b7c650b352f3"
    sha256 cellar: :any,                 sonoma:         "2f4c994fbe40aa9550077ef7270d7529107706ab2b43e54c9bd42cd047f98280"
    sha256 cellar: :any,                 ventura:        "5a35a1a282fa9ad9ed1166aa14d3c073d6195c9c97600653c198d3f966cd8247"
    sha256 cellar: :any,                 monterey:       "9ae5366201da7e076fdcfa3c5b2f768de540c083798a6dde7363d19b6d8bccad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5c6ef340097f3d5195f8b77d1af22d8ef701f2ad47ef0344ed8897f74bddd4e"
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
