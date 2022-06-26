class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.12/olm-3.2.12.tar.gz"
  sha256 "32c81f7fed1dbdfc1322568e4c2f4d12da3974848d4b41b7721b1bbbc0296a12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bf7952e643e6d501003cf26956f09aa0c492abbb2e0ac099393ca2a17aa4d21a"
    sha256 cellar: :any,                 arm64_big_sur:  "e113ddf0542c3892c4adfc66f0683ded20c4d35f99966ed8e56bec932ca7d29e"
    sha256 cellar: :any,                 monterey:       "318efaae41e59e5abce32933ef82f55cf9b18259ab73f334b426f683e424b45c"
    sha256 cellar: :any,                 big_sur:        "5707ea67ed3f049c02b7cc6c0dde28f9d214e0caf006967b16e2e1cbff522252"
    sha256 cellar: :any,                 catalina:       "6585fb3d0af941a52c8d74de4f91fafd7924d87252149e3ba49fdfc531c000b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b53d055793f37b30bed1a54ba78b086463e006a087611c750e2f544337c90915"
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
