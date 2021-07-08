class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.27.tar.gz"
  sha256 "4695831c8a3ffb0b164121874fe423fcf2c4b4bd60da7b99fafd074f52cb0a1b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "540deb0d016c60759fddbc27cea074d0cbf41bea280a3a5f2bebad3d2669d50a"
    sha256 cellar: :any,                 big_sur:       "1e2c75707e6c6e10fa88f916edc4026fdac18edc82aa9f990030909267700372"
    sha256 cellar: :any,                 catalina:      "98e020bf06d169e5f6d6c8986292dd184401de5ab701883f76499d0c99b88f78"
    sha256 cellar: :any,                 mojave:        "109575396900c8b2e98aae4b4c86adebdd75efab8d9e15c8fdae9eae6d183a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bfd7d1d1704a023ffdb21d157e9d14299c2d99b2ff2e10f8529eb993e719a54"
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
