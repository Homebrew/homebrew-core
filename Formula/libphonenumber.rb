class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.15.tar.gz"
  sha256 "0a734a63e70ecd7bbb3c2f59ef05acd724e3f98e8d2edba26f153cc8db58a500"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "ee9063f6468e03a32ac4c4c486a988312be41d34d0cd99ac657d1612a70569e1" => :big_sur
    sha256 "a4b52514ee47582d893d00d2c5740c00ac9ac38a2570e5e9e506ae79b0e250c4" => :arm64_big_sur
    sha256 "53a33a6126452a7c65f92a7b344e047703692426d18976456703cda6de911a5c" => :catalina
    sha256 "a5259c647acf6281508df5d490a138edb640f295ed31109206e51f5882acadc0" => :mojave
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
