class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.4/olm-3.2.4.tar.gz"
  sha256 "d6033363fe27bb1ad88940f2acfff5517b1ba9e32b556f5b0fa4c365e5ec892a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "045f0bc56bafeaae9744901421f656bead5039c6cb4a21188aebb35add7f2066"
    sha256 cellar: :any, big_sur:       "82e30127cb2da730a3e88d37122a3d9bcf1766a4f17bc446f9c9a2964213f6b5"
    sha256 cellar: :any, catalina:      "b9b37a7a344e2d0fd81b2c534f5ee1847620c7ee27dfca3eddbc98124795f818"
    sha256 cellar: :any, mojave:        "ec54d3a11b1bfa84653372af1a9b9adf9e599b9413dde97ee7085bf9e6a79f11"
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
