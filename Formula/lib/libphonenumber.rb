class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.35.tar.gz"
  sha256 "dc3dc9aaa48510f424f8b9ec520c0451a7dafdc46c800d1ba3701f82e6dab078"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7e5aeb6d3377414db5d114196ddb22412dd2c1e47b2a017d435788bac7f3054"
    sha256 cellar: :any,                 arm64_ventura:  "089f760057f736d959eed4887a1ffc81cc966349dc9c3aab5b57ddc98d180089"
    sha256 cellar: :any,                 arm64_monterey: "7c704e65748ebc816d87c891b77ffc361cf890b0ef5149609d06b99020d973cf"
    sha256 cellar: :any,                 sonoma:         "0ae15c2ef6833a43cbb66a93e76fed29e3d43f79abe1c0571a6662c0c6f7d08e"
    sha256 cellar: :any,                 ventura:        "30b3b875607786a0dc44941d3f93ee141bf454cf5e9421fb25a09bd17d75d791"
    sha256 cellar: :any,                 monterey:       "2048725bd6b2084700179057a36b227c4179f62745da6624f28e42bd047d907d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a732409539fdf137c5bc551e853c789294a8aa8be1e376da0240e596be54cdc"
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
