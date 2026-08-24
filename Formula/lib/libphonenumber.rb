class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.37.tar.gz"
  sha256 "4bd34bc3aec5a89dc9035d15aaf2256c5e8f7e0524e6eb3e7bac1e811987c230"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "faa238a41f7868c60ae3a648b3949cdf4270cb1ece6fa75008bc96e2d75f7854"
    sha256 cellar: :any, arm64_sequoia: "a5837c17360d9eaa00b07a0b12eef5ee362ddaea4129e895068b9cc94181a92c"
    sha256 cellar: :any, arm64_sonoma:  "0976464dcdb1fc5655cdaed6b17fc4c79d7d7a03e1f14e164ce95b0156e1cad4"
    sha256 cellar: :any, sonoma:        "e0be4d0def19beb28c0ff0e44577782732340b1279f144540206a282c63ad009"
    sha256 cellar: :any, arm64_linux:   "60bd268547e5e6b424c0fafd1fff9b4e4ef18e7ca0ed53f703d1eba54d1af7d1"
    sha256 cellar: :any, x86_64_linux:  "bac7ccd7d76c70873b0b2ef0faeaf5164aa23bc4cc7792ac2a7f5efcd5a180a5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "protobuf"

  # Fix build with Boost 1.89.0
  patch do
    url "https://github.com/google/libphonenumber/commit/72c1023fbf00fc48866acab05f6ccebcae7f3213.patch?full_index=1"
    sha256 "6bce9d77b45f35a84ef39831bf2cca793b11aa7b92bd6d71000397d3176f0345"
    type :unofficial
    resolves "https://github.com/google/libphonenumber/pull/3903"
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
