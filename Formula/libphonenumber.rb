class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.43.tar.gz"
  sha256 "7ee08a09c0949bf827e62bd8e02a540de616639cccd7b28913f200db15a0ef78"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "986b6ad9d3c25de277a4b64a09b58e41e6f8515b710f2a8c61520c1eb4d68387"
    sha256 cellar: :any,                 arm64_big_sur:  "7ebb4c986a34a33fa1e10e941fe26a376582c706b45522939e138220cd63ef7a"
    sha256 cellar: :any,                 monterey:       "604c6bf9527db17fbb9cc01b2fb2179bc911f90622671ad45d583cb30fbccaaa"
    sha256 cellar: :any,                 big_sur:        "253664d239d3cdc23ccdbf90de132b50169ce5e0c8e79cde3b8eac708512fcc6"
    sha256 cellar: :any,                 catalina:       "7537711fcc1a67cd7dc01d5fd389ca77e1a27598c2a14ad0d6ab22c1c181d983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a325046b7be5d88093f4fcb5ec3376d246fc037cec8a3b356e496f3e0404d7"
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
