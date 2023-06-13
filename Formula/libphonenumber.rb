class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/google/libphonenumber/archive/v8.13.14.tar.gz"
  sha256 "65aa0c7d6da4b070794fb1d7d34f7322e613708c3f10ddd90fe3725e049f1fb0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7c0b8f693d69b7678017abeed947f6625d34f690f22cc7f49771c903fb59e56c"
    sha256 cellar: :any,                 arm64_monterey: "dd107252d059d6a9d76122354596e1dbbdc49edf8b233a303060aec6106d9ba3"
    sha256 cellar: :any,                 arm64_big_sur:  "157ad87da9a616e7e3deb1c4a423a30b4fe438efb26d5452612afad1c6459d58"
    sha256 cellar: :any,                 ventura:        "87f2a81987f5a63a4f074f80db42edc73cc278d878f2f6913e6008e6c4dcf711"
    sha256 cellar: :any,                 monterey:       "f88524b034bbeda2202ab49cb17c9dd7959cb4fa59179c0d0dc539d4d8e4112e"
    sha256 cellar: :any,                 big_sur:        "6243915d7671e1f511b93b2e05ff07ccc365d6f04d800acd3a7a71ae6cf94122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c008edd4d0b040f9c71dae7901575ded54acc71c1e3891a811c6903f21dc81"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf@21"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  patch :DATA

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
    system ENV.cxx, "-std=c++17", "-I#{Formula["protobuf@21"].opt_include}", "test.cpp",
                    "-L#{lib}", "-lphonenumber", "-o", "test"
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
