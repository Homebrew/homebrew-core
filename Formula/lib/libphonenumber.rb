class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.5.tar.gz"
  sha256 "60095f6dc67d0359ec5008c5ad37f17003012c3de149b545d5a07b18d89acf90"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4a71cae21d8c87897d07b99ee06be539f82197acf1d5b5e726901257885e282"
    sha256 cellar: :any,                 arm64_sonoma:  "ce59d445f338e6d66ddccfdf21b0be3f123dbc3cb3d651f46f8b2df33d39c0d0"
    sha256 cellar: :any,                 arm64_ventura: "028ecf1b6a4f2336e8b87a0d8af8c021357e502584defae2356213be6a63b6f0"
    sha256 cellar: :any,                 sonoma:        "b112e32e8f6e8dde93bab8daf8494bd9d9578537ea5bb7e4f4322be24272ab24"
    sha256 cellar: :any,                 ventura:       "53a62a1eb87f63fdc18ee0cbae79bd95f1bfc2e9fb301e3ba40df33b019121c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c71c4b92782ebcb6fe003cd1a02de6701ee6ade97e66f6f87c4c5f360483b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3cbccc4112d2b7c365bafc27d34a680a6fbe88b2fdc8980c0907ea6528db622"
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
