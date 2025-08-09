class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.11.tar.gz"
  sha256 "80a53c5da67c6240e15ca9cbb2cf263e9875fd37415464892b5cd1a00b1e2dba"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66904de89bc1e5680bc7b610a360ae59030d0d321e6596d3644a6ad1980bf6c8"
    sha256 cellar: :any,                 arm64_sonoma:  "2dced28ebcc46e47534db87347ad567dbdd5ad2feb1a12125e2910e6882e1264"
    sha256 cellar: :any,                 arm64_ventura: "1d3e59accf1fcb7e20afb7db11a12aff53d93ce6ab05ba83029fbd7d7a08823a"
    sha256 cellar: :any,                 sonoma:        "0ca384e6215e156b942bded7c8c71092c26b599ecb728cfefdbb0d802dc9a616"
    sha256 cellar: :any,                 ventura:       "af82d762978db55911083aea53a75a54c2da4c884a2908692ca4888638d75b72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29498ab732e17e0b3f0d26cad6bfced0e1c41e3362e33f825da317ccdb22b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0deb61431c49e5eaac179bd14b42b7e022775bdaf9e8ac6f2c51b6a48b33ac77"
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
