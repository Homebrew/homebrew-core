class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.3/olm-3.2.3.tar.gz"
  sha256 "59e698b53dc62d4812d968275f4e44ec335f4ad60db37e06baf6c6bf4ec3ba3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "54b8814692a2dc5a615c9b53f4f2b94b42fcfca3c52caecf98fe690733d997bd"
    sha256 cellar: :any, big_sur:       "1e247e10fb19a31ae58486726f1560593e16012d0aa57d47af25a46ab6fc3bc2"
    sha256 cellar: :any, catalina:      "fe465ba38be614bc1198b1344fc1c29e886d41f280be5c81920f1c09fc89428c"
    sha256 cellar: :any, mojave:        "ed7db7fa826c6ab887082eda37089298f00b183630ea8c0187563bcc56a87206"
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
