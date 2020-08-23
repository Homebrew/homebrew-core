class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.1.5/olm-3.1.5.tar.gz"
  sha256 "92ac1eccacbff620a1bc1a168ba204893d83bcb72646e456990ebe2480638696"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "bbe4e24d1c0a1e584d2feb1b4cdcf2b3b6f995e8e01b48367d2b60d5b25ab2c6" => :catalina
    sha256 "0bcc49962732ee4eb211fc59abbc803444dab90486539f76605b233bdb765705" => :mojave
    sha256 "7c5a282fba56d8968e138cd7c36949757397f8cc2ba8446c683cf3b24f5ff6aa" => :high_sierra
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

        uint8_t output[43];
        ::olm_sha256(utility, "Hello, World", 12, output, 43);
        cout << output;
        return 0;
      }
    EOS

    system ENV.cc, "test.cpp", "-L#{lib}", "-lolm", "-lstdc++", "-o", "test"
    assert_equal "A2daxT/5zRU1zMffzfosRYxSGDcfQY3BNvLRmsH76KU", shell_output("./test").strip
  end
end
