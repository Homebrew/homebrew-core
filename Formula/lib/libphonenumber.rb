class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.3.tar.gz"
  sha256 "496c0fa9f046d3750d747e929f21e95ca153a0266c57e0d92edf523adf2a35c9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c1678e8b053454c95f6d8532e0d590161486ebac4aaad8a38b3eacbe1301f2b"
    sha256 cellar: :any,                 arm64_sonoma:  "a2a8a7372463e5ae85bf0b61cacd20ae7f978df49336f2366c75ec2c054df727"
    sha256 cellar: :any,                 arm64_ventura: "b2cc6b390b3a35a93a2240c5b4232b74ae11d12c7f881d0f4e1503386f96fc5e"
    sha256 cellar: :any,                 sonoma:        "c685019cb203bc2d8fcd07b0265f9334a45a38fe1b80b93daadb69cc2519bd78"
    sha256 cellar: :any,                 ventura:       "56976c30873dc98fd88d65b67bbfa82fb4e011f3f7b6db1647a5ccbb39e71679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d5050c4e7a993371181a483970a33ba7154fce84d6f978ddee5b0c133ced8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1d752c0e33de8a3e18472f635fab9da61aea9f8a968747651a2644caaee5835"
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
