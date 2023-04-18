class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.14/olm-3.2.14.tar.gz"
  sha256 "221e2e33230e8644da89d2064851124b04e9caf846cad2aaa3626b876b42d14a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a36d40b111b39b24c66c295b79f8dec191ee3a7970fdbf305a8151ffed707dfe"
    sha256 cellar: :any,                 arm64_monterey: "4ae925a9a7dcf206e59c76408b6996f9904ea4a2f438ee80da6f4857def8af4e"
    sha256 cellar: :any,                 arm64_big_sur:  "6224e35aead4f2be51d0f2d3ff8c72a09f8d736a637c1defce99a4b8e234852b"
    sha256 cellar: :any,                 ventura:        "8ccae9cefef268b83627db7f1b8f6126f3db0abbed37563822cadc3e96e01686"
    sha256 cellar: :any,                 monterey:       "3ea53f22b716377f30f0724cd7645e74b0a10ba29b810a4d0e55583c9cf74947"
    sha256 cellar: :any,                 big_sur:        "83453551f4961c06b3e2cebd296d15f4491864ebe1c002bf968f0de05a78c39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b964f76b48baa96aea07e2b660a29a2a62398b59146c25bea480ab7b9628f85"
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
