class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.9.tar.gz"
  sha256 "069b4c0cec74aa5b9195a1ddf294c9fa7f3ea0eefacd416bbb5c7fc7847665f1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "353cde4a8b4e039c37362c237f297b8cf2687e85d681deea1126c9978a0ef5b7"
    sha256 cellar: :any,                 arm64_sonoma:  "9e6b9f87f43e6c53d839de0d3e5b782c76967051268f490d91c50edd95db2dc8"
    sha256 cellar: :any,                 arm64_ventura: "4ac46dba851fabbaaa5137f441c0bfba8de9bfda57317636fea7d88d01b487ba"
    sha256 cellar: :any,                 sonoma:        "cb514a62a2847673d9d828e957334591b3154f5dc6a8c2d7cf8e90d6d0cae029"
    sha256 cellar: :any,                 ventura:       "90cefa61a583ee452d9ee37652d1754d129f8e2f274984b07244a0f1d7879f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3050436444b6bbc9f09a562c668cc3a968596841764fda2f2826659fa911000f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c87f9d93861074297d83ec52c2f9ea0626bd5a14c18dfcd0e0f179ce8821c29"
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
