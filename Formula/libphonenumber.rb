class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/v8.8.7.tar.gz"
  sha256 "68c45ab16e090b31c506d542aad7cab10264b9c92c342537d7b7262c960344fb"

  bottle do
    cellar :any
    sha256 "cf171f5eab3d99e1e366b4420e6204e34de43f3d50715b1a154d8b01628f8c1a" => :high_sierra
    sha256 "52663071fd310322f780da7b42f4043514f5d0a03da2d75c171bb9672df2fc2d" => :sierra
    sha256 "4f54f6290454ea3210aa73e6b1896b110bfcac1f7966fffa1233799fc6907223" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :java => "1.7+"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "boost"
  depends_on "re2"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  needs :cxx11

  # Upstream PR from 2 Dec 2017 "Only use lib64 directory on Linux"
  # See https://github.com/googlei18n/libphonenumber/issues/2044
  patch do
    url "https://github.com/googlei18n/libphonenumber/pull/2045.patch?full_index=1"
    sha256 "4d47d0f92c994ca74e3bbbf020064b2d249d0b01f93bf6f5d82736eb9ed3aa43"
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
