class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.5.tar.gz"
  sha256 "32e61961bbf81ffea6ff30e9d70fca36c86178afd3e3cfa13376adec8c687509"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a1992fd6a094c7ac73f4d12fa5b606beb62bab208003f221e50dcb2d51fda26"
    sha256 cellar: :any,                 arm64_monterey: "f55c895afdcc122f8b49f1404a288ed4aeef6b7539577da70987e3d1968a3770"
    sha256 cellar: :any,                 arm64_big_sur:  "15cfa6fff49af80574e0108aea825dae74e28a1e318b790d79ced54d33dc309b"
    sha256 cellar: :any,                 ventura:        "56efa790f1df122940ebd87ac61875e4e86217116356ed20a8f51a9e44d2f288"
    sha256 cellar: :any,                 monterey:       "a9789c30f2081f39220ad4bf55d80ba1acab4688d8c21d0272010a736c63e442"
    sha256 cellar: :any,                 big_sur:        "83b0928b9d75fa1b0d9f12d43044d7147b5124b63ff872ad9027c4071440a31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "030ac448ebe514e55f1fef4cec0690ce839e62ea7015385c3f52180e0f8dc9ca"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
