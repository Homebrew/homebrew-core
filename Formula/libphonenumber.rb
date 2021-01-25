class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.16.tar.gz"
  sha256 "b97d25d884f596f819679039d4ce34cbf5965e8e4681cacd9bd24fd93b4cf44b"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "03228a25ff7a53f1d583765badfd91f2411b797e85e752fce94bacb59b4cc483" => :big_sur
    sha256 "7b9d1d3ac5878888b651c36632d1fc735fccc49a0205115e6cc27586fb210ff7" => :arm64_big_sur
    sha256 "f2ab269cbf8146d93453344ce168f11749d202aec6ddfc02aa88daa1c002da40" => :catalina
    sha256 "e861f54b8c6ac3292fcac64325195f28cd57abfea01276f6327e1266687eb4ee" => :mojave
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
