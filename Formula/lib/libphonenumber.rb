class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.22.tar.gz"
  sha256 "d3594f65d1f1c585bfbeeb5662ef442a4ea2ec4ea2eb3c8e96314f44e06f08ad"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34ef7ddc196d27ce692083c30bca7cf2d9eedc2af2f856ce1aab7919f8ed68ee"
    sha256 cellar: :any,                 arm64_ventura:  "948f217c409c4a82c9483d5f684e445be8ac8c23f9840ff81b3c8c9498f3ff32"
    sha256 cellar: :any,                 arm64_monterey: "a23fb52bc10156fcbcab3fdfd956541acacc4c66a47c29124f4c34b1fdf56afa"
    sha256 cellar: :any,                 sonoma:         "f76eba9efabb1918789590db22e9103c34a39a313627cac4fda4be5fbad55d13"
    sha256 cellar: :any,                 ventura:        "9b3f81c648ff4b1bdcaf7c4a75dfa00053e41c3ac7e7a9b215646b1674771d17"
    sha256 cellar: :any,                 monterey:       "abc342d22aea4b9eae5b9016bdbb5f1107a94bf47d19d3abdbef17193057c762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91f0b9156556e59b9fecfb3bf75db46dcf4115eae115c168e5550f7e7ae9271"
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
