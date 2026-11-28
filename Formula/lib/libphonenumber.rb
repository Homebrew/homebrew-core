class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.44.tar.gz"
  sha256 "ed3f2dd91e95d9c865772b62e51133eb5c8ca20f5a15e5f4064b4cc67d199185"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "666d6bfd167cdd27cc04267d93952dee18f0a8e00ec65a9f7a240b5005ecba47"
    sha256 cellar: :any, arm64_golden_gate: "f6d96ee184dc33baf1dd734fbaafd8d93c9832161ccffa57cef67d27ba2fd736"
    sha256 cellar: :any, arm64_tahoe:       "11db1bc2083b4c66d7da8007e4e9cbd600fd618b03d53e86a8265b5844e8bba9"
    sha256 cellar: :any, arm64_sequoia:     "0c8375676ec1acc2a877d8290a2396d00b274a43655d77bde17d52904d8d31e9"
    sha256 cellar: :any, arm64_linux:       "60f8f529cc0a2aba04ffc8a525a034bad209ed96e1a9da60c66ba1f84ce7715e"
    sha256 cellar: :any, x86_64_linux:      "ab53b6e3776157bb81e7a8a122cd519b7ec9a8bf3731c022f88ebc8a08357ab4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@79"
  depends_on "protobuf"

  deny_network_access!

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
