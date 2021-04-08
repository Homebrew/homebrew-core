class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.21.tar.gz"
  sha256 "28849e2efc437ddb0c6e0d3a5a049964eaa0fef860c514762cf600f864864587"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "833d131c18e4075266e9a7d036aed634ee6afed3b60adfcdab544a2603ce5c72"
    sha256 cellar: :any, big_sur:       "3da794404f364641ced3615e97acfda547a86c112dd4d3569fd5453522473ab7"
    sha256 cellar: :any, catalina:      "ddc9ddb6c2178af9c4772e2563c728696b2ac59e36f02fe55d8b52964c6e9f00"
    sha256 cellar: :any, mojave:        "d9503ced2ea7c11cdea1e6c150aa0be98ef57164a5e5893bb90aba0b79e3e930"
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
