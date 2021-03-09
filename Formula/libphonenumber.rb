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
    sha256 cellar: :any, arm64_big_sur: "7c5ed7c7e539632a900e65847e928676311802ef62315884f5b95581eec1a94d"
    sha256 cellar: :any, big_sur:       "35e8bf2751f1937b1147a49d2e8d7258548cfcd7aff7e28849492367a4a89c47"
    sha256 cellar: :any, catalina:      "f3e69895aecd92da3378b7b79f384b2f6d7b1c28f489e15150fdea0dea8486b6"
    sha256 cellar: :any, mojave:        "9a7b8fef1f1fc7b952758a2754c042eaa9ccad999f78723c2fef0c4298defe14"
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
