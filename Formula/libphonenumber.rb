class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.39.tar.gz"
  sha256 "ff16330f130917e42bc0b1a7efe5e4fba46633bfa62e35268acec855e17e385c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a88efcd9e2e3fc7b88c2d547b338b489a9464c34dcb5379b373f6cff8f1fbd46"
    sha256 cellar: :any,                 arm64_big_sur:  "be6a424ea281261dbc87472a396213788af847741280e0047c14827deb10a6ad"
    sha256 cellar: :any,                 monterey:       "cefe5040591ac37cc1ed084b679f09a82e0bf8dba8a42895bc2afe9b0ef23aeb"
    sha256 cellar: :any,                 big_sur:        "1cb623f85f7cdd6614515499049f1d0a7c70ffffbd8f9c11e1003f21e39e2b08"
    sha256 cellar: :any,                 catalina:       "27ab0236ba00f6f8bb9f1a069f5e61424d3aeefad3e3be1fe219109272de9c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f933801a07767652de4c30f5f7678e44db8e2317ac37226120b30d82cd97ef5"
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
