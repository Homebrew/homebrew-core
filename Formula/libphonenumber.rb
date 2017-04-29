class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/v8.4.2.tar.gz"
  sha256 "0dae06329d17efc306680c421295767f2cbc013926794f03ebd4e2ed23c3b764"
  revision 1

  bottle do
    cellar :any
    sha256 "bc33c7052cfa4c27ddbfb5bc4ba6396bb9af17b47fd8cdda120eef0c2186939d" => :sierra
    sha256 "43b90b2ad31a21b5ee4e2d928ecbf72ef6a46bef7ad1746813a47fb16555a1c7" => :el_capitan
    sha256 "3b2c7b7e1ce75300c89920d512fd33caf97884259709b2803185944992fa60a8" => :yosemite
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

  def install
    (buildpath/"gtest").install resource("gtest")
    system "cmake", "cpp", "-DGTEST_SOURCE_DIR=gtest/googletest",
                           "-DGTEST_INCLUDE_DIR=gtest/googletest/include",
                           *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
