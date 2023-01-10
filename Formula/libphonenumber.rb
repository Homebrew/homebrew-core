class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.4.tar.gz"
  sha256 "7c9d1b7bc3320e1a234bdd9435486bc01fca181d74455e2866af19543289ae6c"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "373665c3d8d7c3f59e9f9e0caf722685c0adba7d325cc3a6d3502e81b574fad5"
    sha256 cellar: :any,                 arm64_monterey: "d6670ef04a92106393147b9cd0e4eeca2ae890139d92d4ceab8d463ded13437d"
    sha256 cellar: :any,                 arm64_big_sur:  "163aecafe952fdd190a4f50bf3583573629fac7e8220b7a454d9f691305f36ae"
    sha256 cellar: :any,                 ventura:        "8db4bdc04c39e87c637d4ca8037e4c067cce297861eb6ca1c3a801bc4c857f27"
    sha256 cellar: :any,                 monterey:       "d074eb4ee71925ff0f0cbf31bf267e0543533edf8aedd513949ed1fceef1bfc9"
    sha256 cellar: :any,                 big_sur:        "a1e4da6c63301dd394ad4fb3e5ddaf662606ab70a85e32338d9fda53e32c8f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d38db7eb2a8c5c2d5fb127e5d080ca79e299e31e56d0c1a2c9a3b7f155a25e"
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
