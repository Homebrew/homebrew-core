class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.26.tar.gz"
  sha256 "f2ac2946d615df52da81f34780ee972fa80af63d1a09becc7b7bbe32ae01547c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1de27631d2abfaaf4c2b0c074fa54559b03e0bf0eb22745c32eef529c63f829a"
    sha256 cellar: :any,                 arm64_sequoia: "d337fe2591652af54a1383a539b5fd6c94d32a6385e0f91a7e6d706278f14b41"
    sha256 cellar: :any,                 arm64_sonoma:  "71a055aaab344772dc23ead030dcee2700330c801c515fc0c495a8e525e0be47"
    sha256 cellar: :any,                 sonoma:        "e221c9723b06fa2a17884cbcdef98b9bf2832030466d051093fbf96a502582ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a93ad96e9e80f1d8018a7cd2919309c2ebdc534d73b26a0d10d0f9e650abe35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dad18272c898b18cb85257e234f388e262838899a607aa74efb0343e958eade7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@78"
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
