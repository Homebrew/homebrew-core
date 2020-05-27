class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.1.4/olm-3.1.4.tar.gz"
  sha256 "1ca9926ce71d778fb7352d1ee77513194db8c7f49c0d69d38ac49ec3bafcea38"

  bottle do
    cellar :any
    sha256 "87dc2b50b798509939fe13070a430ce9b272cde84a31dea24096893360cc8742" => :catalina
    sha256 "58d57753b78ee0a0689251f7db57d941e082bee89016a1eae8491eb7426596f2" => :mojave
    sha256 "691c24a47f7a376d1e5e6db1e3981561c07d1b82531de4fd7796a0577112def9" => :high_sierra
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
