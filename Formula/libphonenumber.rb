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
    sha256 cellar: :any,                 arm64_monterey: "8d5e2206ae9c67232c1bf965e1a1bf384445a54eaf9ba02e95bc938b1c3577f3"
    sha256 cellar: :any,                 arm64_big_sur:  "6a165a7da76b1a77ded8fd08d070c6baa586f3ea05daabc690f06b3328651dc9"
    sha256 cellar: :any,                 monterey:       "e540a70968b872b655f59284be3be08ff792b3dbb7d2b9f3223dfda59f7e65ac"
    sha256 cellar: :any,                 big_sur:        "a809d9df4449af310f365a34d5173ea679dd22d9c9a3c5d46eeb171814093035"
    sha256 cellar: :any,                 catalina:       "f55e556c4d811ea2563a87a4709681d4e9945b4139e8c6834ce6cd3edf77c951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be7b75ae28b56e8389be9471f69fead52c1f57f177b0b16183df7fd088aec1ce"
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
