class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.27.tar.gz"
  sha256 "f19d771fe372edcc476c1be68b9dbb3d4bea89f83f15b37b3ed9c5914e3c1b5d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "42e64eb7f163f8fc698eaeea481bf1604276b511d866ce97ee4721d7444c6528"
    sha256 cellar: :any,                 arm64_ventura:  "1263aa0faa19b42767417c84f0d2e71462f96fa92dcac19ec9c61e9748f77806"
    sha256 cellar: :any,                 arm64_monterey: "046e4b8c5fcfb3f88ad086f9dc0d43989dbabaae196ada0494b2a18bd47a5955"
    sha256 cellar: :any,                 sonoma:         "0fe5bb883bd07ce4f81e9a9fdaf01771da45767e88c39932614e6639adccd204"
    sha256 cellar: :any,                 ventura:        "6d529867c883d2548185613f817b111361fceb969c99dc962fb46ff2d021f1a4"
    sha256 cellar: :any,                 monterey:       "5dc8a8c784516eccc95c25f67a39b2a7fa1d2d56585758ace40b3fbf9851d400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b1965f0a8b010b207bf99e64e04ae829cd40ca2f2b0d0d971a1972a30c76819"
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
