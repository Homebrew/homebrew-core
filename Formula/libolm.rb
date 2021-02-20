class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.1/olm-3.2.1.tar.gz"
  sha256 "d947d9570345e68696668cb855f1a6a7141b7b89cbcc15a08b1fae18535c4c45"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "dbb54bdf65d2e73e09d55bfd240fa2e8caf86fafd5c35cc75f06b07d2d6eeddf"
    sha256 cellar: :any, big_sur:       "9d964030f0a1920373121784c9cc6ac41ee5941019b8eff7dd77923dd1573128"
    sha256 cellar: :any, catalina:      "aa31087429ce7f4382dc14996c7b820eb8d03530f9c0f2f06221df53ba32f79b"
    sha256 cellar: :any, mojave:        "b2530289c9735b329e9e9985467075e779bf57cc8e9be9a25868df4dd767a54c"
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
