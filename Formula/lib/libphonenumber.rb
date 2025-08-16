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
    sha256 cellar: :any,                 arm64_sequoia: "f68cd96e8d7c56cf1038e4a25652094f1f32ba8f850668900f6239250912c3fc"
    sha256 cellar: :any,                 arm64_sonoma:  "e759c7d05fa8f43a54667bc80ae520bf63c62b40730afdc180611a06e69077c4"
    sha256 cellar: :any,                 arm64_ventura: "1438891ce3395c8db4d1a7c86cf45528309eabd4d88e7e3ed12fe68949aaeed6"
    sha256 cellar: :any,                 sonoma:        "9162200262da2a91f3bcf5dcbf37ad924233e406c3e3ff82afd8350fbbce93dc"
    sha256 cellar: :any,                 ventura:       "64cdad1f5d963887d8c637870646e52951fdfa118e121946a5206ca9ce4f6670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d55749a5907d83ecce76b26126cbc937a592ba257ce0e17ce73a8d63f23acde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9a0022aa935bd67d142612ebc0da2c8bcd9fa3a27df22b33a54d9620bc51cb"
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
