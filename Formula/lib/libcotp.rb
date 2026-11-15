class Libcotp < Formula
  desc "C library that generates TOTP and HOTP"
  homepage "https://github.com/paolostivanin/libcotp"
  url "https://github.com/paolostivanin/libcotp/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "52baa968de23be3d54465f214ba2733f848702b211711ba625db2535e14433b7"
  license "Apache-2.0"
  head "https://github.com/paolostivanin/libcotp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "53cdd0596ed12de1be43ac322a8feba4c887b3f1761a3b15e7923ffd843c4537"
    sha256 cellar: :any, arm64_tahoe:       "da97fd9a50b2fcb476b324dcf09fe93b6ba982aa86bd50267bb0e7d8ebd6604f"
    sha256 cellar: :any, arm64_sequoia:     "50ef43dc367e65cf330ce335ee66ce02f77d49ca703b73b61c4eafb9bd2f6f5f"
    sha256 cellar: :any, arm64_linux:       "1175480ca5b9cb555848e43b3d78f1385785f6ed0a60fd4f38f54531b28aa55e"
    sha256 cellar: :any, x86_64_linux:      "c54b4bab0cf6face2c7001f50dfa48f48040d44ab392dcee6f136da571b049d6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libgcrypt"

  deny_network_access!

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
