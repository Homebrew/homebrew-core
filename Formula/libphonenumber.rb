class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/v8.9.13.tar.gz"
  sha256 "3f0a061457ea6260e03f32f01ad9d953f51cf30f29884924cad5c3eec7d635e1"
  revision 1

  bottle do
    cellar :any
    sha256 "ce61a953ff3b54be7c68b224acad77769473accd5ec53bbf92308a7c1457d93e" => :mojave
    sha256 "db689d7e9a5c8c5d110db9a9e528b3ef0d7ae88216305b9e76c62af1ee1d4263" => :high_sierra
    sha256 "0c2d7d7a004dbb369c11d615fc277a948fc8fd6ac14eab03cda9fce491e64582" => :sierra
    sha256 "a7013b67e84fcbef19d9e0b4951ba514d29326bc9fef73357614c1e3183e34c1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :java => "1.7+"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "boost"
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
