class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.35.tar.gz"
  sha256 "8ebd00c89a441d1989f609ad2c7eb7cc0d900d4f126fa3df835a805e25235dc7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d6c4a3f343eb993dd8349ef77d4f72c64c1abc3134eeb25a67e8f8b615502a19"
    sha256 cellar: :any,                 big_sur:       "41d9263373e2eee2ab76322f60eae5e4e66ca45504023345a4244159b17b3102"
    sha256 cellar: :any,                 catalina:      "0f707bfce5820a757b52d482a0c24a58bf9c88306284e05d1a2275c5d1c7c21f"
    sha256 cellar: :any,                 mojave:        "2775fe1e8d7c86bcb32aeefc232030d9c63fe40cad8e452fe1cb7e2449754c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc57b042ceb01d841d5da5e89f3c9d9d9a5f21df224caaaaf6e87712e2f0e42"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  def install
    ENV.cxx11
    system "cmake", "cpp", "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].include}",
                           *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
