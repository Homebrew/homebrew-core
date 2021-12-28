class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.40.tar.gz"
  sha256 "2ab57fa740484e1a2354402b29d633869c7b883b8edc8cf9bf093ed984861e1b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c3e6b6418516e7e25195d64c70c58b405e23806dcb87038998c36eac60dc909"
    sha256 cellar: :any,                 arm64_big_sur:  "011d2d61d13578da5109e95ac4d1264382dffc13278f951ec14f41a66b5698be"
    sha256 cellar: :any,                 monterey:       "4ab5c91f328457017c119659bceb55e9622c537c3fa2465e2b869e73d63a06ef"
    sha256 cellar: :any,                 big_sur:        "3c8eb7c346e54c43fc5c1d53cfac758adbcfcfc482ec7867774d624e60388dd7"
    sha256 cellar: :any,                 catalina:       "ab39a21f7a01bf2df289e39c820908208f5f5e54dd7c01ae1df33d268c4f17f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21db6b56d9f1a39c51a70699542c0148a92ff4292a46f1a2270c5d95e8b7eccb"
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
