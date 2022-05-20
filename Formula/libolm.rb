class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.11/olm-3.2.11.tar.gz"
  sha256 "dd32cbaf7745bb3c8e792c91572bd91d5fcfd172a965aa37267e8eb89c21a9d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bacee7bf54245a34cb91d2d956b24f97af4d3dc36ec1662bd73312b7932f8ac6"
    sha256 cellar: :any,                 arm64_big_sur:  "5fe0c428aaddc4d7ce273c58dc3c87411a9ae4018e049d8d9d5ea3f31596cb6a"
    sha256 cellar: :any,                 monterey:       "0c7df35ab79f283e750b0227589a46a1605390185385307ffa0d31863d9328d1"
    sha256 cellar: :any,                 big_sur:        "fdd17b291c4441e41fdd7d3d1d5f06f400886e7ba957b8bc897e5b470f81c1e3"
    sha256 cellar: :any,                 catalina:       "296839bc2cbe0941e8778a943d084fc1a04bc35630921c51d9914311ed453e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "627cb1752220cfa2cc02452221847d7df20bd08268983a9919d5a4529f644448"
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
