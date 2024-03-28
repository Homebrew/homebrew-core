class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.33.tar.gz"
  sha256 "656c080c0fd713b9bed61efda4b006846d40914b5412d6d7082a5397653e2fef"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef7f4f349a6f2723b9ecd33a71fff5ece72bf44abc563626fdf579035f9ea619"
    sha256 cellar: :any,                 arm64_ventura:  "393e3e6ebc7d2924a907f6d8f7c8548a5bfddfd544351441465acbf14e4bc6e3"
    sha256 cellar: :any,                 arm64_monterey: "411d46b311ca8f16964cc6186bd7be91d4189d8c55452b7c1353ef02b569ee28"
    sha256 cellar: :any,                 sonoma:         "4323ef0573bc265abf9e0a4566e27147061791bebd0b1ac580f27a0624d09e03"
    sha256 cellar: :any,                 ventura:        "45b0b4581f1831e7863e960a930313a723fe0cbfbbddb68dde12e7ad56f02aac"
    sha256 cellar: :any,                 monterey:       "a41cb4217c1a6861682357584a755cacaa2ed9705c792cfbb27bee02a52c29bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72b44c93eca7cf2027c931dfdc0437827b467764bc999f241808cecae4be301c"
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
