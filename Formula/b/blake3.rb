class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.1.tar.gz"
  sha256 "fc2aac36643db7e45c3653fd98a2a745e6d4d16ff3711e4b7abd3b88639463dd"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ae7a5d11b12fc0fb64cea8881f65db817f1f2a6bbde29c2a1787d9f95f64d09"
    sha256 cellar: :any,                 arm64_sonoma:  "da6189c6ef56b588d3d08f4c821bd44f9d33ff2816aa17adf7164613decfee57"
    sha256 cellar: :any,                 arm64_ventura: "b03763e6a25c48732f9c20994ffe1c7d58ecacd31b91e508e39257620a31b7ba"
    sha256 cellar: :any,                 sonoma:        "4ebd0e744956db93d9012e1dbe83654428598166068fecfe1764abc280ab24fb"
    sha256 cellar: :any,                 ventura:       "22a7c26a126e62eabbd56af06b5f647d4f62cfd921fac91c65842b9834ac8cf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8f94bb99da8f7a073bc82999c169556e3f27331ef5e794bc0807a7ff49d8064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ab87339de37d746471bfed3d39a29b73fbb30fc984f6c4b4ad28314024ce01"
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
