class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.57.tar.gz"
  sha256 "c7b47822d3c16c29ec96268bf1a8bb536a11e3b2c130f0ad92cfa671ac212b32"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54f7678aa6d23266a1967779c6344e34fd3a8c00fa3a4a9ba2a98402ce520db4"
    sha256 cellar: :any,                 arm64_big_sur:  "bdc4975126efce7b44c187f0c5a510828c0023ff6ad2a1934d9fc72b1584ef78"
    sha256 cellar: :any,                 monterey:       "5a52fc01dce40ebb23cd90ac3922e5c375906e5ea1835a4a37daa8a4c327134a"
    sha256 cellar: :any,                 big_sur:        "5028caf22b2dd9d239ec70c8badce1f67f746b2b2a54a08c534f5a52a723820f"
    sha256 cellar: :any,                 catalina:       "89bf14bd986b5587899efdd1f3fd704a53d21d3b02bd18d9dc215768f8514c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83feda6072c377611d69d172fe6b2ada8dc2c957cb75446d799b427da2bf87a8"
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
