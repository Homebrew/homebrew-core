class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.6/olm-3.2.6.tar.gz"
  sha256 "9b61bd9182bb0ae0c5a800a8b0496b69600a0a22e3a21fce0aad119d2b1c99ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "245688a835df1a73a40e477c19cc8874f52b36e56731af9381f3513f7e71ea97"
    sha256 cellar: :any,                 arm64_big_sur:  "a0d40c19dde560b6c429ede66a7c549f46c36f58872a055e6fcacb24b565d72f"
    sha256 cellar: :any,                 monterey:       "5dc746624fa4f5cc0613bca33f65ded6dfae709e0c987278cd326104a31947d1"
    sha256 cellar: :any,                 big_sur:        "9b0fa6f2b8bcf26a480b43cf8fd38bdd474f2296d1a13a378228468811ba3876"
    sha256 cellar: :any,                 catalina:       "dbc06704bf32fedbfd2c8aad88ba9d504e44d055c553d22677298ec877f40c8a"
    sha256 cellar: :any,                 mojave:         "be9653954751491a58c54ea5f9c0e6284af4975a8d09f0c4248d14ec735e0d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fcdb358514800ef0cf2248b20b36e57ee1faf258936514a05b2d821e5322bfd"
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
