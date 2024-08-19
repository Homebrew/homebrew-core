class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.3.tar.gz"
  sha256 "ec9114480857334858e73b727199c573bfdbed6138a83be573f076d37e671fc1"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7aa528547ebd01123d6a61b7f2856c9a0ef151f465977e3d09635caf85c6807"
    sha256 cellar: :any,                 arm64_ventura:  "d0908161009b153f258581416a8c92715b66fab4bde454239d9d10fcb71e2c89"
    sha256 cellar: :any,                 arm64_monterey: "4c139107b706715c3319f0c09d1a472e9438ac47109aff4048cfab12337c6985"
    sha256 cellar: :any,                 sonoma:         "1f36c5d92b9c0d32abf5555070a4540365cfa0964199d9db4232cf2825e436ab"
    sha256 cellar: :any,                 ventura:        "1df8866566b2d1ad8b11f7edc846b359ef54501e0e7ec45319f8dacecf3b6802"
    sha256 cellar: :any,                 monterey:       "ddb7a8901e47ca09bd4539eebad60c109fc78553f69c040cf08776e66c0d6b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08e4d04eaab578748a0507843fdf0c99a2a3c1ebc7ccfb0a9ea241841601297d"
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
