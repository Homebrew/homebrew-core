class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.44.tar.gz"
  sha256 "02337c60e3a055e0a4bc4e0a60e8ae31aa567adce59f266cfd37961fceea74c2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d31aa380f7329cd41a1db35fae58e4abda0699a91610c5010d61608b4e44335"
    sha256 cellar: :any,                 arm64_big_sur:  "efa5b9ed4c6ff164db15f3b4f95bc04915589a60949b590abb6ed3c39b446e0f"
    sha256 cellar: :any,                 monterey:       "d5a76a56e4b0de0e18ef38c179880cbf30d8ebaa69a97f682b118a02dcbd246b"
    sha256 cellar: :any,                 big_sur:        "421a22a948275f7e1418286c6f28a961adb21d1deea1ed48158f08ae0aba3fbc"
    sha256 cellar: :any,                 catalina:       "1de7423f245f5f67480bf1c0b234cf9c021ecaa73a3361dc55ab400279823bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8deffa47b92037526c35d1c565d21aa9d0f61e34f3b123e9c1cba0b5f61eb5"
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
