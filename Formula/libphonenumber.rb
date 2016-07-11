class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/libphonenumber-7.4.4.tar.gz"
  sha256 "f42c74b6543a55804a2ef89dbd66492e425c2a07e3606cf5c43c7b18f39c1aa9"

  bottle do
    cellar :any
    sha256 "e4b8bf1a9af7f9e565e74f3d8d798fd877f405b1ed27857d8551e698319557a0" => :el_capitan
    sha256 "489a8e3fa8dd9f1961aa6286667aedbbde736ebf19118be82dada7b10ee21e83" => :yosemite
    sha256 "ca00bb7b9c8d4967273ff70cc755e504b854126bb08162972e01dae4bf1f4a69" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :java => "1.7+"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "boost"
  depends_on "re2"

  resource "gtest" do
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha256 "247ca18dd83f53deb1328be17e4b1be31514cedfc1e3424f672bf11fd7e0d60d"
  end

  def install
    (buildpath/"gtest").install resource("gtest")

    cd "gtest" do
      system "cmake", ".", *std_cmake_args
      system "make"
    end

    args = std_cmake_args
    args << "-DGTEST_INCLUDE_DIR:PATH=#{(buildpath/"gtest/include")}"
    args << "-DGTEST_LIB:PATH=#{buildpath/"gtest/libgtest.a"}"
    args << "-DGTEST_SOURCE_DIR:PATH=#{buildpath/"gtest/src"}"

    system "cmake", "cpp", *args
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
