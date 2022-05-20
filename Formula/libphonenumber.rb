class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.48.tar.gz"
  sha256 "4bd2b7c89f1cba8dc78038395f4cc3236dd5aa62118feb4c354a8890634faea9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d832993e0319465f133ab8d4cf4d2464b22857681e454d21f760cf4ea00de6d9"
    sha256 cellar: :any,                 arm64_big_sur:  "6a6684e697969c0fb657f1eb5d99e7fc18fd8c790999c1c74222f85fa5438b9f"
    sha256 cellar: :any,                 monterey:       "bd52ceb68b3bd4eeea286892d05071f42bb6c9c677ca9c2b18e31a3804d5f737"
    sha256 cellar: :any,                 big_sur:        "d2de4ea8a71bfcc5c8c2c1f644adf3d1ddc51a5a6b7990e452e436eaee46f71f"
    sha256 cellar: :any,                 catalina:       "46551a909b0a97881188c1ef0359028f133b9fc22b6d33607aea9601657915ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14766d7811f0b31836d78acbf140302371ef52371108bb3203b09630f8fcd15f"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build

  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  # remove builtin abseil download step
  # build patch ref, https://github.com/archlinux/svntogit-packages/blob/packages/libphonenumber/trunk/absl.diff
  # upstream PR to conditionally download abseil package
  patch :DATA

  def install
    ENV.cxx11
    system "cmake", "cpp", "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].include}",
                           *std_cmake_args
    system "make", "install"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/cpp/CMakeLists.txt b/cpp/CMakeLists.txt
index 57261a6..8686f5a 100644
--- a/cpp/CMakeLists.txt
+++ b/cpp/CMakeLists.txt
@@ -18,7 +18,7 @@ cmake_minimum_required (VERSION 3.11)

 # Pick the C++ standard to compile with.
 # Abseil currently supports C++11, C++14, and C++17.
-set(CMAKE_CXX_STANDARD 11)
+set(CMAKE_CXX_STANDARD 17)
 set(CMAKE_CXX_STANDARD_REQUIRED ON)

 project (libphonenumber)
@@ -126,6 +126,7 @@ if (${USE_BOOST} STREQUAL "OFF" AND ${USE_STDMUTEX} STREQUAL "OFF")
   find_package (Threads)
 endif()

+find_package (absl REQUIRED)
 find_or_build_gtest ()

 if (${USE_RE2} STREQUAL "ON")
diff --git a/tools/cpp/CMakeLists.txt b/tools/cpp/CMakeLists.txt
index b094165..58a9b3b 100644
--- a/tools/cpp/CMakeLists.txt
+++ b/tools/cpp/CMakeLists.txt
@@ -26,29 +26,6 @@ project (generate_geocoding_data)
 # Helper functions dealing with finding libraries and programs this library
 # depends on.
 include (gtest.cmake)
-include (FetchContent)
-
-# Downloading the abseil sources.
-FetchContent_Declare(
-    abseil-cpp
-    GIT_REPOSITORY  https://github.com/abseil/abseil-cpp.git
-    GIT_TAG         origin/master
-)
-
-# Building the abseil binaries
-FetchContent_GetProperties(abseil-cpp)
-if (NOT abseil-cpp_POPULATED)
-    FetchContent_Populate(abseil-cpp)
-endif ()
-
-if (NOT abseil-cpp_POPULATED)
-   message (FATAL_ERROR "Could not build abseil-cpp binaries.")
-endif ()
-
-# Safeguarding against any potential link errors as mentioned in
-# https://github.com/abseil/abseil-cpp/issues/225
-set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
-add_subdirectory(${abseil-cpp_SOURCE_DIR} ${abseil-cpp_BINARY_DIR})

 find_or_build_gtest ()
 set (
