class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.2.tar.gz"
  sha256 "ccc54c3ff073f6f9be3260d0e93a17ab6e98be6906a15625a614b41de0d1693b"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5499d250c99f5b2d90dc24707b1654fcc0d1ce8430a4dafcb27242fdf9a6ebe5"
    sha256 cellar: :any,                 arm64_sonoma:  "a401dc993264402ca0482b65ca5394d943f0ff5fd3b39b4f8adc829661cd972c"
    sha256 cellar: :any,                 arm64_ventura: "83378e2c3f64f168f169e18696b344c9e54416e278f6dbede05dceb3dc10995a"
    sha256 cellar: :any,                 sonoma:        "cdfdb213e403283f9065f71ecddfa9146104bbf5c75315262f5c3a92e1a6773e"
    sha256 cellar: :any,                 ventura:       "51ffc65ae944d628fe6d74ec694325671670dbfb7de18c0ab8ad247bbe0f1630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4242403ecf45594389c1093b6433802c31e848e3d27696c3afa7fad5921ae706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272754c2974ba6053596da84d59abff3c894a357a3c1ef8cb750800359522c6d"
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
