class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "e51016eb220647e7f16b67c0baae2a42730b07fec3131aaad0f39a3a2a638b89"
  license "Apache-2.0"
  head "https://github.com/paolostivanin/libcotp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "109112f087502712ed5814400e416e69fd297633f9f33126910fb0d18cef558d"
    sha256 cellar: :any,                 arm64_sequoia: "b065711b5ce070c8cc37d352feb02d3c10038b1271d36447d4ca2a4d39d04e7c"
    sha256 cellar: :any,                 arm64_sonoma:  "39e5ed7667e0661e07a5989cd3b1cfc3de9ad96990cc301ab562af5ed7c55871"
    sha256 cellar: :any,                 sonoma:        "57c91529239a09b366685c102809be4931df36fe9095cb45f1c15114ec61ed35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72d0815bf444b80e9e3d0fb837bccf29420161c496ae69eed3e0ec0f137226ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe129d50e25913db0f719c9ea1ee4078dccb6d1691c4db4653aa7479feb2853e"
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
