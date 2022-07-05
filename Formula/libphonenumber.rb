class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.50.tar.gz"
  sha256 "9ed244d569d62001190aac5dd8aa85166e2b68b938315a5ae038af8242c2ab1a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d4692fe8006747aa16e131381097922fbfc9826398220db6068069c9514add5"
    sha256 cellar: :any,                 arm64_big_sur:  "7cec0906b938f505103de77281a5730b193c70485b86c96f86ba511c0bd4e93c"
    sha256 cellar: :any,                 monterey:       "8109872f17d94846255cc92ef880d7fa958ac45403fee997845a96384ab310d1"
    sha256 cellar: :any,                 big_sur:        "f5e92a6627d36e0f8c91d33ced2efad3f1944431b76dad0d0cc6628bf52b98a9"
    sha256 cellar: :any,                 catalina:       "216f7a2a964ceededb7e10e564032addb93c56c0557ae6970240691dfb426734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8aba9188bcaf8dfb08ed20aa014e8ba7a465c70575d263317beeb19f9ac174"
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
