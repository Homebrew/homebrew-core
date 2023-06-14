class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.14.tar.gz"
  sha256 "65aa0c7d6da4b070794fb1d7d34f7322e613708c3f10ddd90fe3725e049f1fb0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5263d5ee802979acf0ab84d3b20d7abe61b152184a19680cb0b4348bcc89d581"
    sha256 cellar: :any,                 arm64_monterey: "6115779450d1e0e4556d0aecc340f65b2b1ee3d76621dc6073d3a3227753baa8"
    sha256 cellar: :any,                 arm64_big_sur:  "d10b5d5437bcb7fc78fe5d5e2a001691a0ec606064f60771fd11c3c8e9def8c4"
    sha256 cellar: :any,                 ventura:        "a333f9e060e6556c1cb66f3b11e4101f107de7a0706a96254a0c543f4fa78d09"
    sha256 cellar: :any,                 monterey:       "f03a2ebb2e7ca2af1edafe296934da60f6056ffb7d43b768826b1824c6f423dd"
    sha256 cellar: :any,                 big_sur:        "45f6a0030c73529a51ba282329a4c097060c34328174f4cff4c42bf5d27bce79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16e684355ef176f6a8dd922231754c0b6c5609e013467b346bedb5183e9f124e"
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

  patch :DATA

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    # https://github.com/protocolbuffers/protobuf/commit/4329fde9cf3fab7d1b3a9abe0fbeee1ad8a8b111
    ENV.append_to_cflags "-DPROTOBUF_USE_DLLS"
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
    system ENV.cxx, "-std=c++17", "-DPROTOBUF_USE_DLLS", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/cpp/CMakeLists.txt b/cpp/CMakeLists.txt
index d2d111d..5b7d2b2 100644
--- a/cpp/CMakeLists.txt
+++ b/cpp/CMakeLists.txt
@@ -19,8 +19,8 @@ cmake_minimum_required (VERSION 3.11)
 project (libphonenumber VERSION 8.13.0)

 # Pick the C++ standard to compile with.
-# Abseil currently supports C++11, C++14, and C++17.
-set(CMAKE_CXX_STANDARD 11 CACHE STRING "C++ standard used to compile this project")
+# Abseil currently supports C++14, and C++17.
+set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ standard used to compile this project")
 set(CMAKE_CXX_STANDARD_REQUIRED ON)
 set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)

diff --git a/tools/cpp/CMakeLists.txt b/tools/cpp/CMakeLists.txt
index 91c9052..ae8db75 100644
--- a/tools/cpp/CMakeLists.txt
+++ b/tools/cpp/CMakeLists.txt
@@ -17,8 +17,8 @@
 cmake_minimum_required (VERSION 3.11)

 # Pick the C++ standard to compile with.
-# Abseil currently supports C++11, C++14, and C++17.
-set(CMAKE_CXX_STANDARD 11)
+# Abseil currently supports C++14, and C++17.
+set(CMAKE_CXX_STANDARD 17)
 set(CMAKE_CXX_STANDARD_REQUIRED ON)

 project (generate_geocoding_data)
