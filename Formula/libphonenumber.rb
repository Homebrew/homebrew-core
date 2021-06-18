class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.24.tar.gz"
  sha256 "7622cb6d1096f2c90650084084ab8fa5e554319b63622af2a5b2ec0308e8db15"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d303c4a5b36b3fa94cf392b58fdccdfc5816c1189205dad32f8018dd02db9578"
    sha256 cellar: :any, big_sur:       "f6dc8f6f8c3ea1e13b674d00576cf74a03671a04e354cb3fb85a6b9b145c3e46"
    sha256 cellar: :any, catalina:      "0d134787f468db28f20d44fec123df740e2c3e79ff25c9c308a9fa57d37e0ada"
    sha256 cellar: :any, mojave:        "1e05b66ba4ff4c70f39f414ec2546876d197105669d7e57a9ef49cb6483b8af6"
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
