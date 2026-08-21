class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "5f0cc41049e9fa296c1edf09c6fb0bb6dae588b149d5049adbc41d21aefc1bb1"
  license "Apache-2.0"
  head "https://github.com/paolostivanin/libcotp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "89aaa0b61256652958c90a61f3f82c59a7fb6f5afa32364b59c1093308467f7f"
    sha256 cellar: :any, arm64_sequoia: "069635228f8a0182050038461b51ad26949391ef6bae57e0fd304b83e7e1f661"
    sha256 cellar: :any, arm64_sonoma:  "0e9bb7e9d5b67337df2bfd7e7f618f506b383d87112ced2e9a3a678e2a9b5683"
    sha256 cellar: :any, sonoma:        "6dac76c234edfd66e5b6f5a5e5880420f017ce5af6e6c0991c66b399575350d0"
    sha256 cellar: :any, arm64_linux:   "b4fd5d204436162d64a817f4fe258cf44a6397bf0e2eb27ee89d9027ed76be6b"
    sha256 cellar: :any, x86_64_linux:  "81790c9183e22d2fb1f2c38ae40d8b3543fc14a1ece83c06556f108c9061e47f"
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
