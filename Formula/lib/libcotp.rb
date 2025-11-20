class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "9b5778b8e38d9b0c33d6331ec980094b0035bf53e6064bbcc2ed988b0d4b3d13"
  license "Apache-2.0"
  head "https://github.com/paolostivanin/libcotp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84d385a54915c1048ff6a18fc4b150b9f0641966afee99596318f578a60a808b"
    sha256 cellar: :any,                 arm64_sequoia: "6050b9fc9fb8e8179d90486ba1bed1a08b76303fa8994dfee894199956dec6f6"
    sha256 cellar: :any,                 arm64_sonoma:  "1ae0f2b236927c8fd0471d308190a2df8cac550defcdc4439e804a3c345e9796"
    sha256 cellar: :any,                 sonoma:        "bd5666bbdf0d655a9079c1ef37f8aeb3b881e2fb55459eec2956076a1a78c642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7db49b6cff8e362d1b905247c2d97360f30e386ff85f041bc19bd88ea7f14e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85418e6ddf1ce99c62d2e0e524503cd7b027481a8cd44c6cd867f129a02f3ce9"
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
        char *K_base32 = base32_encode((const uchar *)K, strlen(K)+1, &cotp_err);

        cotp_error_t err;
        for (int i = 0; i < 6; i++) {
          printf("%s\\n", get_totp_at(K_base32, counter[i], 8, 30, SHA1, &err));
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
