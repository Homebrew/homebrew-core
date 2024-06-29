class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.39.tar.gz"
  sha256 "700eb7a7b9a4bbd1c8aa757aaa7b0cc8c5047d4c33c48518564eb3f0938e193f"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "420e1610e454127efdfec303162012ca5c183e537eaf2adaf3ac4783df59330d"
    sha256 cellar: :any,                 arm64_ventura:  "9426fbf9d3c9c38030f332bc90098111c8da9c835668d1010fa0cf64dc1c7563"
    sha256 cellar: :any,                 arm64_monterey: "04a9172bafecf03fa72da69475426b9115bb6d816bfd94552c6f3c0e91ca3835"
    sha256 cellar: :any,                 sonoma:         "f28c4830582ba4d604ac6e1efb979dc07bf401afff4cbd9bd9565ceda1bfb691"
    sha256 cellar: :any,                 ventura:        "a9a7d5b706ecec930dbf799693ae9d43bca586b43c662807de509d7fe0213aa0"
    sha256 cellar: :any,                 monterey:       "1fab1a8a88f4ab2f3b2f7acd3351ebeffb150433bcf0ce34914eec797b8adc9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f53912714f9fe5eda2364377d366bd7c4f1aa292d3e7a1fab33a1006b6f065e"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
