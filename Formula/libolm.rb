class Libolm < Formula
  desc "Implementation of the Double Ratchet cryptographic ratchet"
  homepage "https://gitlab.matrix.org/matrix-org/olm"
  url "https://gitlab.matrix.org/matrix-org/olm/-/archive/3.2.15/olm-3.2.15.tar.gz"
  sha256 "0c63362b8be78580c2ff862297386ceb00fb05b295ce346f6fff8be8ac49eded"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae2fce79fbf4a831388686618bf59126dbd90ff8695cc88c5b22997ac8022240"
    sha256 cellar: :any,                 arm64_monterey: "b829de0f052d4256e5ac278288ba80f652b1501abd305a914e8733db02dbe2c2"
    sha256 cellar: :any,                 arm64_big_sur:  "acc275d512ad0e668d3eafe8882f5a527b7ca6b179bfa470a5feecb850ea6557"
    sha256 cellar: :any,                 ventura:        "a89325d517b1e2a49fe253cdd4fa50fed2aff90682ea081591595d72a6d17521"
    sha256 cellar: :any,                 monterey:       "22379c3407fd3cfc393a40f281ca11782b58a8207e4aecdc102c9535023235e3"
    sha256 cellar: :any,                 big_sur:        "2aace47f007fb57beea4c7f8d72d5b1f6f7775b58721c2097a0e3a2e410dfebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd99aa0000266d83803aeed496decb2df14b7d7ed78035e63d0aeaba501f83fb"
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
