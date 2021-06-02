class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.4/olm-3.2.4.tar.gz"
  sha256 "d6033363fe27bb1ad88940f2acfff5517b1ba9e32b556f5b0fa4c365e5ec892a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d1237f08f04399f5f58f6a6efb883f39e92542d8f55584474fc50536d804285f"
    sha256 cellar: :any, big_sur:       "3696c62a152595e3e02e340a599836262b2ecef38fad76cc9a9fcc5b0e18308e"
    sha256 cellar: :any, catalina:      "3e83a3599eecb36c40c9d0eb73e797e73d732e91b643bbed4d83ca9b6dbdf0b3"
    sha256 cellar: :any, mojave:        "b73c1b4634938af192b4eba0d7659546cb01b4c05dbcba5e4d1097ff7205852d"
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
