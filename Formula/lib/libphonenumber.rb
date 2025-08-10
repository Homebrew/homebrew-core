class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.12.tar.gz"
  sha256 "2557b16b42da4d0c2e59d0cd17ccd5a134a5f983f56412ab8213969d886cd836"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f4aff2566b460d0fbe587c3e25c54856b9377d8a836a4abb31ca68f8946716b"
    sha256 cellar: :any,                 arm64_sonoma:  "e71084ef78ed88f6b673d303574dbff9725a9ffbb06566fde1979d3b77a00bbf"
    sha256 cellar: :any,                 arm64_ventura: "7df8e5ded511847faf1fa73c89933d493d18aaa2fcc3780b5f02f72b50377db4"
    sha256 cellar: :any,                 sonoma:        "7d51013c44e6f91424ad901015b319fc45a5cf8d71f6ac3773c1ee3cfbd72462"
    sha256 cellar: :any,                 ventura:       "041f1d29a376ee17e8a43101625dd6127531af53ebdd03646d6ef990adcfda90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4586404c0f4c2b44902ad0bd0f2391a85c867124c9d21d20acf85844b3bbbc68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b4cd8ca3ac1478df7e0c20caf0c839aa49bb67f4d684446257a76988a023175"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@77"
  depends_on "protobuf"

  # Fix build with Boost 1.89.0, pr ref: https://github.com/google/libphonenumber/pull/3903
  patch do
    url "https://github.com/google/libphonenumber/commit/72c1023fbf00fc48866acab05f6ccebcae7f3213.patch?full_index=1"
    sha256 "6bce9d77b45f35a84ef39831bf2cca793b11aa7b92bd6d71000397d3176f0345"
  end

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        std::string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      set(CMAKE_CXX_STANDARD 17)
      project(test LANGUAGES CXX)
      find_package(Boost COMPONENTS date_time system thread)
      find_package(libphonenumber CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test libphonenumber::phonenumber-shared)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
