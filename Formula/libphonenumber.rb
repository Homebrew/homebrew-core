class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.23.tar.gz"
  sha256 "49aed4e11eecff703207ad46f40cdb5995eece24d0f7e9aa25537aef5f011e51"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3238d7f2a4ba863ab67c37001a32674529920a534e14da5a9dae345285eb8303"
    sha256 cellar: :any, big_sur:       "02947bbfe3b2628baf233f428bd9114d34357726f0e5d0acb26e01f43cfb51ba"
    sha256 cellar: :any, catalina:      "7fe1e9f5e4914667b9aaf088db733f1aea2b1b64ba1fbf0b601c04a2ccb3f906"
    sha256 cellar: :any, mojave:        "db25193574e06d3418196f1293e38e5d1b7a53b8f41e5815d0e85a9cec6af6ba"
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
