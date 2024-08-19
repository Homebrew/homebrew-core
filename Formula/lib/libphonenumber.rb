class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.43.tar.gz"
  sha256 "bf5389a66aa065eac62f1220b2f0f8a9848ba339ea12df3f9357abd9fddcbed0"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d488ab45e6f5b2be1477576606baf62b7ea30e1fc5cd2d16ad6630ad522298e8"
    sha256 cellar: :any,                 arm64_ventura:  "a9186a24f5d0e2e30a59a33ca135560d9973831353b1065cbb2c29bff863ba42"
    sha256 cellar: :any,                 arm64_monterey: "7302b1a83ef3c79a1219414193e57113001493bd8834dbd07af6d49d96e2d794"
    sha256 cellar: :any,                 sonoma:         "ab967668adb32f36887be4d32e270ee24bbc28e0db91d5a884308ff916becdb6"
    sha256 cellar: :any,                 ventura:        "63a654dee14cbd38b0b776945b61a3729e161515dd2c86b399a7d094138d5cb9"
    sha256 cellar: :any,                 monterey:       "47bf1ee071a60cf1b65edcf22d60dff8fdb0e83941afb9d2db05deccb650181e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d35b8d636936c24f61a5408fba87d80c922ac12808a45e23ad4bba98bb6fa68"
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
