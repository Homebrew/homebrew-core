class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "a48bbfd95b7ec12d23e4e2c4a017f8acddecc14bf10541ff144563cee044b39c"
  license "Apache-2.0"
  head "https://github.com/paolostivanin/libcotp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a55767669aadfbc33ca5047a9bf5a1371ebaf4ccb3c9e3e14a3296516f0702e9"
    sha256 cellar: :any,                 arm64_sonoma:  "3c1f7d889c8212c2a7e8763c9bc712ce98ce0e8cd2520a27e6ed13468bdfa922"
    sha256 cellar: :any,                 arm64_ventura: "626c19565338f9e6ebf991ffdb7c7acb0beea6fb5ce65317ea12a08cdaea63d8"
    sha256 cellar: :any,                 sonoma:        "6a56e1465c12f7f4a88da73e4feb96255e03b2739a4a9e2d7fe176c9a9290960"
    sha256 cellar: :any,                 ventura:       "540f3a6ecfea711699139ec94e16bf0e194094a0508e7e111777632c637388b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7b568b96cf41f1440fb120c229765e4d092f1425a286fe067b907a367a7f9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc3ff644b09e647890b68df9d726edcc2a8d18e293cc4773d921141147a6ffc4"
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
