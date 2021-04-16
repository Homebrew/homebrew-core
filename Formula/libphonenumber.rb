class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.21.tar.gz"
  sha256 "28849e2efc437ddb0c6e0d3a5a049964eaa0fef860c514762cf600f864864587"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "20450f4e43ba2a1813a9cdb73e901d5af253ee0b2ee95330b2b03eb0a99b30aa"
    sha256 cellar: :any, big_sur:       "46e60eec8234961f6ffcd70707ea9e37418af986f2ae994b60d1755efb960b7d"
    sha256 cellar: :any, catalina:      "f4a0fe43aa9176a6623edd12aeba4322c48e6f36bb7dd1843bec35d945a3ba56"
    sha256 cellar: :any, mojave:        "11ce292a09d3a37b442ea9140a5e3d32ef5c03716ce2477d7b6fe047215ebf91"
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
