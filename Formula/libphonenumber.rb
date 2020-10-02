class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.10.tar.gz"
  sha256 "5a19dca47d2958f59a6f0f57f88d154f9f4f0572ba842f2d1764b099326b5503"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "3589fc5d918b59e10b1fc6590c530bdb641865dd6678c947e8c35c36c5f180c4" => :catalina
    sha256 "3135b2b4479a949b7b125bc853120a913120e36485450fc5d01af76b3dddb1fa" => :mojave
    sha256 "c69c75bbae94678c3addc55cac3173f44838adf549ad7f1f07ee9fba9c5f0727" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

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
