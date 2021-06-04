class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.24.tar.gz"
  sha256 "7622cb6d1096f2c90650084084ab8fa5e554319b63622af2a5b2ec0308e8db15"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5300d8c1d8b53ccae0ec23ce78109d118366fa8e5ae398c3b690a1ff933f452f"
    sha256 cellar: :any, big_sur:       "5b2bc8b177126264f228ba80474777d89aacd62c01995ca59cf3e2638a38229d"
    sha256 cellar: :any, catalina:      "df63fc809bb6d2529c511278c5c3321212f51bbe5f5dfd50b517bb778cb954a7"
    sha256 cellar: :any, mojave:        "4d343e321c41bc97bb40759284887bfd0a9e18863a198f7533fb11b55876ab5d"
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
