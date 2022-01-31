class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.42.tar.gz"
  sha256 "56e8ecffa47e48233cb582344f7d796eb73d2606c21572ecae7bcbb6456a832b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cf3ff517725784eb9cca46d353368c13ddac364673e18c0be45ade62c4c64393"
    sha256 cellar: :any,                 arm64_big_sur:  "9a4c1ec6723f3009cd2edcf88798433402f6b59ae4094a30fb239cd4762fa209"
    sha256 cellar: :any,                 monterey:       "22a548daecab4399bf876cd0ca2502aa49999f4aeef7b299ada633726dd9888b"
    sha256 cellar: :any,                 big_sur:        "65fd9e3a7548884ff271baae51be081eb86016c000f1697b8ff3c3bf1fb51b9b"
    sha256 cellar: :any,                 catalina:       "6f8b77944a64f11b265bdfbc0d34b21dcbba0ef8ec6fcd0dce3790a8a48869a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41811ff208839c356658b11c4a46751be12a52f61e3446950c590edc1e630435"
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
