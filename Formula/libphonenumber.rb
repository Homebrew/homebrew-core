class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/v8.10.3.tar.gz"
  sha256 "dfd649bc9b4d8886d801018e7c6e21ff978a3e75ee9526228b10c0107ca4fd46"

  bottle do
    cellar :any
    sha256 "5a5706bd17022fbcce77b43f065e9da20e486e9b8bf64c3eb5395f56b203cf0f" => :mojave
    sha256 "5f03fc4cf803829b94427efc944c68c6cd347325233aacfc6fdbf5f231f3acf9" => :high_sierra
    sha256 "0214d90522bd862a0724b49e2684bf08833e5c0c5ab425a3033780f0cb139822" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on :java => "1.7+"
  depends_on "protobuf"
  depends_on "re2"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  needs :cxx11

  def install
    ENV.cxx11
    (buildpath/"gtest").install resource("gtest")
    system "cmake", "cpp", "-DGTEST_SOURCE_DIR=gtest/googletest",
                           "-DGTEST_INCLUDE_DIR=gtest/googletest/include",
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
