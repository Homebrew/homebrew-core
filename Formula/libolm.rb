class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.13/olm-3.2.13.tar.gz"
  sha256 "3226d94118ec048bc3ab40ceec1835e58837fe56752328160b347e70d3d5e444"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "11da17986449174ebb22d5d93b449fd20638ca48c8f54eb5932fb18485f63e1d"
    sha256 cellar: :any,                 arm64_big_sur:  "fb3ab4c33076c7d719ea681eec5f1dac5ea61c887fbe98a57aa2ab48190cb45a"
    sha256 cellar: :any,                 monterey:       "eb976f1a17e3634ef8b1965576edeec00ebef78e6f7b88628c67416d20c3bf7d"
    sha256 cellar: :any,                 big_sur:        "ca98f748ecc6ee8ae889e4045a2eba159a38d41fcd2bde6b9f118d0fe43b3bfb"
    sha256 cellar: :any,                 catalina:       "3e6690f68ebc3161cbba3c1128cb23020795c7130808be1fb4b4a92e36842617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f33f70729d92248d83f0bea9e030651d133bb5ef8d3ebe6d4a54632071f4c9e"
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
