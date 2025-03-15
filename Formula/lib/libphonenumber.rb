class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "853f980ac2aa549e8a5bc12e0edcd7124a44ac2160d0b8611f35cbf613793fd7"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3ea10289f9fee100c0706c97921829a35fd751bc0743eb7f57e9eff34678a49c"
    sha256 cellar: :any,                 arm64_sonoma:  "95dee821c89ef1aa6b419f39f2ef49f8739b46f7470433c6528486dbadaa6293"
    sha256 cellar: :any,                 arm64_ventura: "fca93d49438738a556e991f711f1c2f71870800098e2abd921049ed280cf017c"
    sha256 cellar: :any,                 sonoma:        "da2c5476918245138cba888df162398db5ffad75e9b4c1de874adf3743dcf67f"
    sha256 cellar: :any,                 ventura:       "1e84d9fddfd3fee928a9cc3f1da71c78e893e8a250ed44761af200200b51f836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d14bf208b582fd278ee92af2bb579844d5e81125325ab36ca51da6a46b5d2ee"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@77"
  depends_on "protobuf"

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
