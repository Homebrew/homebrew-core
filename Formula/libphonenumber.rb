class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.17.tar.gz"
  sha256 "ad061ac8e98fb78a731e1517531e1cad9ccd8f076c7cb37c8d8e587bfdabff13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8e94ade3f7fa698e29d900b8dc8516bd6b9814db7ca469674a461399ee0b1fb5"
    sha256 cellar: :any, big_sur:       "dd83f808788ee05a84a704c297c050ef70eb85b1649ceada403b75300c9a5123"
    sha256 cellar: :any, catalina:      "45b3b221d8a87c96c367d4d207fb9b31c286877ae56639a73a35c8f2fac071f5"
    sha256 cellar: :any, mojave:        "6df01ba3cc06bdf3b21e54a4fb7466e40cb2d3bf84e11bbb83eac4732c2f0caa"
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
