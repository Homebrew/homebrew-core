class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.7/olm-3.2.7.tar.gz"
  sha256 "1bfacda8a4dfa49f38056f7eb813abbb976ed31d8e04915ed87f4c7dbc8d10ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1fbd6924c7636b1626c793fbea66b8388409d74f5c68e1d33d371a4b75b49f35"
    sha256 cellar: :any,                 arm64_big_sur:  "66b377b55dcb4b22d3582991e72a6fe59c841e525701a3e557a9638b4dca8d62"
    sha256 cellar: :any,                 monterey:       "5216e89d696aef868f32353cc561a40cdbc7f83b60780a68fc5ec742e1927b8b"
    sha256 cellar: :any,                 big_sur:        "f4ada6417d1a85e9e7c98a95c6708c87643b5b65dec9371108eafe3517afa612"
    sha256 cellar: :any,                 catalina:       "bfc6de868f6c35b0d06ab48664066c9101cbf3c5105d5fec305a73dbb7ea0942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9d2d512747d8332ace6f41f38642db34f57c7a3b77724bf991dd30936f4ca91"
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
