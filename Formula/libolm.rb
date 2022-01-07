class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.9/olm-3.2.9.tar.gz"
  sha256 "614c0e4dc4721f57e56c3385bd8def2f71c6631f928a480efd0b4bd8e5435df9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35e5fbd3bc69497ccc8e7de8aee6d006abdeaf4c7716d1b0aea9069a3bb74afd"
    sha256 cellar: :any,                 arm64_big_sur:  "8c7e1f4e371ecc08c4292767862c465443314a7abac6676113610edf580b60b6"
    sha256 cellar: :any,                 monterey:       "426914a30a06be78449ef8d52d532201afc71177b7127ef7255378facf9db59f"
    sha256 cellar: :any,                 big_sur:        "3ead0e0ee40b270618d0f850c99d6d889df95408cb9c05838d29bca81339423e"
    sha256 cellar: :any,                 catalina:       "5428c4b62541f9239d6948492e7990080154d66883d3add129b5c390f7335be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9a2b620769063ca9823c1eb1ef3f8cc384add4c7c31299f67f92d53e1897eb4"
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
