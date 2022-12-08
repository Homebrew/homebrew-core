class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.2.tar.gz"
  sha256 "54cfc482c712646d825fd4ee82f72767e74ce2595154da8e1c0bf7c5dad70bb1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "db6b3ac0221a7dc9775eac5aa6c939788222641d90c9214a6b4d063f27b6052d"
    sha256 cellar: :any,                 arm64_monterey: "a698863b570042a43c2657e553b4563f8e82e0e0c8b4f0de80e235015723ab9a"
    sha256 cellar: :any,                 arm64_big_sur:  "4c633bc688c53400a4fc47e206e5c5a357f3ca2191b6d579d8fe963402f0ce29"
    sha256 cellar: :any,                 ventura:        "7715a51988368e208e13573cf78fe3a5a8f3de17d441ea7d4c7ba21ecffe979d"
    sha256 cellar: :any,                 monterey:       "758363bfba33b189c4a871a9b313ee41c1f609651f5d5f6fc790c47c82f7f3d1"
    sha256 cellar: :any,                 big_sur:        "aeec1abe791fb86fe00a4d5bb098e307ec5f9d65f54c157beb85cae8fa89ae6f"
    sha256 cellar: :any,                 catalina:       "436edd0d5251142827e13b9e99d4143b55174a6a48c48d34f05ae0bf1bfe8571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90715858807c39c9d910d684f8b0a6cfc23862c7e378081d4a6fba61eca4fb79"
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
