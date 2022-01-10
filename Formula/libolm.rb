class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.10/olm-3.2.10.tar.gz"
  sha256 "e3be900ce7983f2ce9c4507431d7c784b5ebe09b58f4f8b68e8adabdad010b59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "23de7a8f72f29a9b386cf529280540acc665bf9cfdf0628c423ca5150d819e2f"
    sha256 cellar: :any,                 arm64_big_sur:  "0c36ddc7a6452457109a6e4be4f52d54cfdbae3a8726d06aa54ea8e28fb49da3"
    sha256 cellar: :any,                 monterey:       "6ee3a21a446cccb33a8a857a818f397e21323c97ec895ffe9e2e5aacad20a863"
    sha256 cellar: :any,                 big_sur:        "10e90f31858d95a6f5bbce5fdac55b7303512930d191545364b74086e0e50a0b"
    sha256 cellar: :any,                 catalina:       "577c3456b85fb375e2d050a4059faf0edfd4efcc63094708ac08c595ed4cee40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42fa0f8ad7df0688413889442ccb2606720067f9f988a93db3c8980b27d594f3"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-Bbuild", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <vector>
      #include <stdlib.h>

      #include "olm/olm.h"

      using std::cout;

      int main() {
        void * utility_buffer = malloc(::olm_utility_size());
        ::OlmUtility * utility = ::olm_utility(utility_buffer);

        uint8_t output[44];
        ::olm_sha256(utility, "Hello, World", 12, output, 43);
        output[43] = '\0';
        cout << output;
        return 0;
      }
    EOS

    system ENV.cc, "test.cpp", "-L#{lib}", "-lolm", "-lstdc++", "-o", "test"
    assert_equal "A2daxT/5zRU1zMffzfosRYxSGDcfQY3BNvLRmsH76KU", shell_output("./test").strip
  end
end
