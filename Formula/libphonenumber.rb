class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.23.tar.gz"
  sha256 "49aed4e11eecff703207ad46f40cdb5995eece24d0f7e9aa25537aef5f011e51"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1ec46d2dbc58dd08679e11b72e1a00b7bea1b00c3ad359a6f256dd02798a195b"
    sha256 cellar: :any, big_sur:       "48e4638d0e4142306a2ce73ecbbcd0e89911fdaac588a985aee75f3f922ef94b"
    sha256 cellar: :any, catalina:      "8238631ca23b4a5c7d81e12de828824c389643fd4da506f58ff2d1236da17cec"
    sha256 cellar: :any, mojave:        "6e12debcc4ab0ebb262243bf3dedcae8d45c7c3e0d54e535b813a9ec9e328e61"
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
