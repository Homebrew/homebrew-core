class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.34.tar.gz"
  sha256 "2e133ca9f1ab5f54de23b2c17b59d7b47114ce5af1b83762238d769a2864a46d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4f8ea2026a22aa8dbfd37df363493496f9b6b1353d54771f85a84945d9bb182f"
    sha256 cellar: :any,                 big_sur:       "49e9c88174602cc85e6eaa34b85fca340ec0467d328116539818d8cc2faa2519"
    sha256 cellar: :any,                 catalina:      "19776654648cba8b056c26a86fb17ea55218defdf3bf9e06da361ff72107a415"
    sha256 cellar: :any,                 mojave:        "0963fb344f0df9c9340bedaa2a55818b86aaeb285a6add4327a9437e586cd913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d91edd51de9a20d19bf5345ac207c0789267641a967ba94c8aa27efc3136599e"
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
