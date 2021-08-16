class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.29.tar.gz"
  sha256 "1cd6257372fdb966bd7edee0db8731cf281d2b710c53e7f39bba1478d0b1ff3f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "efad8c104d5c944aa859499b8a5596fc069cb77a67b138d219be7c0c1daa4345"
    sha256 cellar: :any,                 big_sur:       "ae813ac11c78619a88fdfabd6a9b30c257e5646935fd1e81afbe2758fd2f0ac4"
    sha256 cellar: :any,                 catalina:      "ab5152c989f291f79393d4faa779967a644034307b2420da9cbd50dc368e4462"
    sha256 cellar: :any,                 mojave:        "1cbaef5bb5aabab488010970bec7406d15b4c5b0c0b465224bfe47c84f1f4c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97fdd6f309e4e08474d8481f22d7b7b4b7d7d66ca6058cee89a81537d7919079"
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
