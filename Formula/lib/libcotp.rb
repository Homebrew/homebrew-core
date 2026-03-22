class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "6b17323779dac1699462d8914b81155d69914b0d28b5ed837f1570ed05f2bd90"
  license "Apache-2.0"
  head "https://github.com/paolostivanin/libcotp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "366cde6e9830afd63b98a7072b8944c2ffd884538fdfb7b2a7654a19ce92940d"
    sha256 cellar: :any,                 arm64_sequoia: "1b6d2de3ca5ba1eebc06db7d5c761a68e47b37c9ba4c8a16590cb77c5960bb6f"
    sha256 cellar: :any,                 arm64_sonoma:  "eff6bf6b8dad34fb773d6e3e93a88b5deea02b3bbc9a6081f686308be397d416"
    sha256 cellar: :any,                 sonoma:        "b0c06d774fd8497727ff3d2c817cc9c79a030dbf4dc95fab77bbe8b22b389659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "339708868c22ab1e04a054e2d3fa6b97101f89831cb82b30adc992194b63f1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d8f4381f2cf656c98d513bdb3a68212b5222ed529c7726876b9f14c9fb5fa7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libgcrypt"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <cotp.h>

      int main() {
        const char *K = "12345678901234567890";
        const int64_t counter[] = {59, 1111111109, 1111111111, 1234567890, 2000000000, 20000000000};

        cotp_error_t cotp_err;
        char *K_base32 = base32_encode(K, strlen(K)+1, &cotp_err);

        cotp_error_t err;
        for (int i = 0; i < 6; i++) {
          printf("%s\\n", get_totp_at(K_base32, counter[i], 8, 30, COTP_SHA1, &err));
        }

        free(K_base32);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcotp", "-o", "test"

    expected_output = %w[94287082 07081804 14050471 89005924 69279037 65353130]
    assert_equal expected_output, shell_output("./test").split("\n")
  end
end
