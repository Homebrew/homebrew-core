class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.31.tar.gz"
  sha256 "6d03446f096259552d34580a42ef6ebb450f2419dde3801a60fffca4240b3227"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8f47d7fdf1ba9675bc7ae710174207450d37f764069a875f05decb40696eda6"
    sha256 cellar: :any,                 arm64_ventura:  "ddbbec9be4a385c96d74100f78e1bfa4b9f2bf61ae3f6cabf63e7f3c14771cd4"
    sha256 cellar: :any,                 arm64_monterey: "b26169dbce01bf1cb9d058bbd574674c3de762ba344054148ff26ef4ca65ee68"
    sha256 cellar: :any,                 sonoma:         "0ed9a0e1a43a2492fe02a750454e1ca9a8723e72ab5eaf088a0adf421b43e9f9"
    sha256 cellar: :any,                 ventura:        "e7535a25a504eb7e2688e225874e666baf460ceaf1116784af461b7e60c815ea"
    sha256 cellar: :any,                 monterey:       "6cec2cb931b327f2946ef13e9d642497dd30f5fe5c28ca6c4364567de10399f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1210f2a97ab6580d92cee21cb28505ccd5360c2a0d332969f34d86b23e8420da"
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
