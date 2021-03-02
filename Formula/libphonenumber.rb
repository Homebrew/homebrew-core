class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.19.tar.gz"
  sha256 "3069686a4683db7d3dfdd023cc85e8a5436300cd8a6fa4b5c9d0bc652c2c86ac"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "81e515c8ada65b9b5a95d6ba16e0fd70af88a8875dc1cfb2b75de9222dddb207"
    sha256 cellar: :any, big_sur:       "1a2a953cb0f5fbee3d33125d2b257763b70c1b6135ef11edcd9ed247750e237b"
    sha256 cellar: :any, catalina:      "da1005d0a1070f9084c71e5df65600ad4e87f46bf6d188ae67596654a513d523"
    sha256 cellar: :any, mojave:        "612054287980d5ace887b0752bc78f4eef27bd55794368e90eab39d71ff18ea9"
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
