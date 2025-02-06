class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.54.tar.gz"
  sha256 "95a2f6b522aad6834920ec53d94dd7ef676358ecbf2c95ee58918a5cce6d7044"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "06903692b080c80052b9aab9a22c7d55341c00d5703ed31d1cc52ce47ce056f9"
    sha256 cellar: :any,                 arm64_sonoma:  "bd5fc712388b8635b687e0ca7503e5a768c2dc03d5b76a43ab30f5250a61c7cb"
    sha256 cellar: :any,                 arm64_ventura: "2aef679f10b3a14912f59d843b39952c602aaff3dd2ee7e55d1f9f41e2d236ac"
    sha256 cellar: :any,                 sonoma:        "d9a5452cbed48b566abb54bd418388f2cb02acf465595ab4752f7a20d887070c"
    sha256 cellar: :any,                 ventura:       "a2f0643cc717b783155c891c318a92a0b10c698b7a0738d06ae99786efbc0d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "448e954495ebfecfb00beee849ea1b615e25c34fb8ef3db5ecd58ee529bdc2a7"
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
