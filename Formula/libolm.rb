class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.11/olm-3.2.11.tar.gz"
  sha256 "dd32cbaf7745bb3c8e792c91572bd91d5fcfd172a965aa37267e8eb89c21a9d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b7c728434be90bceb4f8958622c430ee4ff356e1d6e7f6d8ceaa60a2ee1e522f"
    sha256 cellar: :any,                 arm64_big_sur:  "1b732bde482f7f8ade23cc9f92cc47b7bd4a193fb2d482c2a4d20a99466dd5de"
    sha256 cellar: :any,                 monterey:       "7354d1a6c04e9fd1eb4cb64e72871adf8475443d7d7a66b17da9e208ccf514d5"
    sha256 cellar: :any,                 big_sur:        "e53bb220099cd0227a9662915c210a388d2694360a138caeac11d11d6554ead9"
    sha256 cellar: :any,                 catalina:       "7bbe110a3e2f5bb4a0f5d45c349d44a904a0cedc6b6fd9c238251db85b5bd1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3108c9d27510d43ffdf77970499af30067a8b24181dc6e5b50b34625451dcf7f"
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
