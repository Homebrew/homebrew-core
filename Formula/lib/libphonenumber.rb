class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.6.tar.gz"
  sha256 "0fc0f530f139de53b121a93b2b25cd96ab0d8bcfe95b4760be1f0213a75eadd2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72c4fcf04b7f88b131d9140ac8ad63e2e961cc0cc0fbcf747613c437df1d66c0"
    sha256 cellar: :any,                 arm64_sonoma:  "f00af52ab5f63ffb2496ed732c06b44b7aa24a7772025be91ccbc11fc57af3c3"
    sha256 cellar: :any,                 arm64_ventura: "57bbc535d91f8e61ddd5b315d08263db7fe8268a871ba4a7ef092b0031608de8"
    sha256 cellar: :any,                 sonoma:        "07211340020f52e35744605da8819c5b2eb09a90c7622ad67199403ecc592910"
    sha256 cellar: :any,                 ventura:       "7b70ec79c3f8402a72a4f7bc3b3134c7d546039dd4d14dae3c29f0efaf0b320c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d51cff3b7351c0abb4f58450ef38434c24348a010dd5b119aa18bc23fd0f5463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cf7313fc95a65a6ed9d072edc11ae155146ff8e282faf5fa54dfe27d8db7877"
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
