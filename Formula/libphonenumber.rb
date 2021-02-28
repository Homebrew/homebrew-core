class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.18.tar.gz"
  sha256 "280fb7ff1a7019c825e33bb8540524873f60ac8f26dda4ad66106802034da60f"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8f2243830f9b48eab4ef574f5b8f9c553d384b209157a0cc1fea8139ff2e9729"
    sha256 cellar: :any, big_sur:       "b3e8051a7003b00297db21388a370075b3ab3ee34d082d99a6ed0ea5a36cd356"
    sha256 cellar: :any, catalina:      "d55043eda2234d384dd0d86ddf9b1130e93d725d29b2498cffe7d2efab812fbc"
    sha256 cellar: :any, mojave:        "b8559766f03a97481c6fa9f6e3f0979d4d531e11a62aa194f271edcd8fa20fc5"
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
