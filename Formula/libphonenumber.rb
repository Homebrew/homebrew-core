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
    sha256 cellar: :any, arm64_big_sur: "323ebebdfb61503cde5186d8f5930afd31b43c28a462469a3d2bb2cffbe24798"
    sha256 cellar: :any, big_sur:       "fd9843c376c34eafeb20e0477f2ace03eb0398206a6eed9ec7e82bab651325f3"
    sha256 cellar: :any, catalina:      "590730025876543850ace332e7be5ef9fc70b0db4e526905004b6b3d053a8024"
    sha256 cellar: :any, mojave:        "6e787cf37001c7f51cfd719879c23afe8481e0c348d07d7a5ebbb3c010773d19"
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
