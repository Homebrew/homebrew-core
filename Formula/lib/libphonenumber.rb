class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.51.tar.gz"
  sha256 "c96da523824546a91b4bd6753a54f2ab7f4979d87729407170b58066e245f5bc"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cda75fa77306270c3223a0aecde1b766b5a3c13141ada8c3a7e131f25efb7568"
    sha256 cellar: :any,                 arm64_sonoma:  "beee36ccf90fbf9b1345b552608880e70a0c60c6e1d95e43330ee205dfef9d8f"
    sha256 cellar: :any,                 arm64_ventura: "995c215dc79064ba72a43c7c81ed3a471de01b0a3ffe20c58ca05ff79708b2a0"
    sha256 cellar: :any,                 sonoma:        "edb57a60b883a8f7b4f97e1d1e84ad16f94c73f64e2b087d709e20046ec5664f"
    sha256 cellar: :any,                 ventura:       "46c31499beb238f209c27ae770f86c254ec9f67a46f51c2c8a3af322a0d8c8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acacdff6c93816907bfb03b1f7edec0b9ae7ce731ae3c26fe81a00d5f8377e9c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@76"
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

    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "./test"
  end
end
