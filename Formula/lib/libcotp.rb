class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "f8c843004d18880eb41417853fcfc3855f6197e7a32dcd87d23a6609cf0a116a"
  license "Apache-2.0"
  head "https://github.com/paolostivanin/libcotp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0432f71957f15840f25f6a7cd62e503e0977da69ca646d7413cb802f3399fe89"
    sha256 cellar: :any,                 arm64_sequoia: "edfd170ad7ef376ec709f6800a185d8bfaa64cb79221cc18dc8c956a6c48e025"
    sha256 cellar: :any,                 arm64_sonoma:  "bf9b1fed333f5416705027187e648592fbcad50f6c64617511d854dc28d80043"
    sha256 cellar: :any,                 sonoma:        "5cdf7ca276d63052c7da8babb64d8d6ac4b77d2b60da26b5bfe409b116746b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48d6c3db6d207670b88ddc3e3ebaafa52cc906014b3e28e4b835739a19686cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50912d744adc2980feffa5fc72eec2ce61ba2b391b7f87d53e7402b5a4dfd98f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libgcrypt"

  # Backport macOS-compatible linker hardening.
  # Upstream PR: https://github.com/paolostivanin/libcotp/pull/76
  patch do
    url "https://github.com/paolostivanin/libcotp/commit/83fd77822e774032387b9e38b2d612bb3fab236d.patch?full_index=1"
    sha256 "6a117238f03a838c3e842f4a7e652e5dd792f3c124ca9f792e56a00d01b004b8"
  end

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
