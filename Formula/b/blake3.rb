class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.2.tar.gz"
  sha256 "6b51aefe515969785da02e87befafc7fdc7a065cd3458cf1141f29267749e81f"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2462ae6e1dbb7572a5c56e5c7e942d6d81f690b8dd7a8a6094f51e651a16f02f"
    sha256 cellar: :any,                 arm64_sequoia: "601904a1b1f08581bc60847875b444ccd2c23f11aa68acb8d635ae57fb104304"
    sha256 cellar: :any,                 arm64_sonoma:  "ab21d31a2ea8bfc1c5dde99a668ef0bd3a804db97c8834300f4e5f27ea34533b"
    sha256 cellar: :any,                 arm64_ventura: "2afe34ef022997cfddd89c7f605be83dec6dd5eac01191877d57340c109e1119"
    sha256 cellar: :any,                 sonoma:        "5e3979ad7b545050d0649b6737690b573c9a2cae8440c239e04f2c3deb07caec"
    sha256 cellar: :any,                 ventura:       "bcaabb50e183c271a6fdb8bcc7cfc4aefb20f01a8549d2b4dfb91c0f9e423a5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19550713c46e8be51cf069d04fb610fc86fc808125c4df118e6b5eb979402edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9b135dbb37c400ed1f02a52ec4d40eff9a971bd960d8e65646242baaed4dcc"
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
