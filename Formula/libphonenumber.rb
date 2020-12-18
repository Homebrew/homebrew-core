class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.15.tar.gz"
  sha256 "0a734a63e70ecd7bbb3c2f59ef05acd724e3f98e8d2edba26f153cc8db58a500"
  license "Apache-2.0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cdd10690bb2e9bbb0c900752504d28faf8d1163fa03e822ba70aa26f4ed58f27" => :big_sur
    sha256 "717db539645f03b99071ef901d0ff529cbf59d4e4849c177f07d9dc15adda997" => :catalina
    sha256 "80c48d6ab30ebba89b0174a5e75eca2fb5c4c56b4c90e9d1309b5c7187ff5aab" => :mojave
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
