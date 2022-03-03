class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.44.tar.gz"
  sha256 "02337c60e3a055e0a4bc4e0a60e8ae31aa567adce59f266cfd37961fceea74c2"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d832993e0319465f133ab8d4cf4d2464b22857681e454d21f760cf4ea00de6d9"
    sha256 cellar: :any,                 arm64_big_sur:  "6a6684e697969c0fb657f1eb5d99e7fc18fd8c790999c1c74222f85fa5438b9f"
    sha256 cellar: :any,                 monterey:       "bd52ceb68b3bd4eeea286892d05071f42bb6c9c677ca9c2b18e31a3804d5f737"
    sha256 cellar: :any,                 big_sur:        "d2de4ea8a71bfcc5c8c2c1f644adf3d1ddc51a5a6b7990e452e436eaee46f71f"
    sha256 cellar: :any,                 catalina:       "46551a909b0a97881188c1ef0359028f133b9fc22b6d33607aea9601657915ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14766d7811f0b31836d78acbf140302371ef52371108bb3203b09630f8fcd15f"
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
