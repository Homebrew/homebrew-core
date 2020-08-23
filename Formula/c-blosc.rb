class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.20.0.tar.gz"
  sha256 "992ab5b475b7ba94f91c5ce58359ff0d6069fc65ba0c5bee373db8daecb17ce0"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "00348f59148443e81e625ad88e236d40a57306c49a09bcf8da32205dd61ec23e" => :catalina
    sha256 "a39d6a45c92a867a8082ddb54c85534c286539d955937b7e61bf0cf417bd2beb" => :mojave
    sha256 "8ea83dcfe9216f4f6b31fe113090db1d842c35650119348049f70d17ca848719" => :high_sierra
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
