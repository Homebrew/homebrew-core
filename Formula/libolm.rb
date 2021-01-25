class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.1/olm-3.2.1.tar.gz"
  sha256 "d947d9570345e68696668cb855f1a6a7141b7b89cbcc15a08b1fae18535c4c45"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "0634af436ccc158ea8ba3e15a53df9b3677b88db950691aaf1174189a925c8a5" => :big_sur
    sha256 "850ca4e75b42221ea5ec4ed0ffb845b9f9d032f711b6ceb600d85813e81d50a3" => :catalina
    sha256 "09cad39ec7953a8f3d0c9848673490624153107f1fce18db4a489147fa1170bf" => :mojave
    sha256 "efe5613af63cc93f582b0e6f6dbe81ec9863d49dc347bf354e202ed8c9ed3ed6" => :high_sierra
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
