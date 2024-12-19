class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.52.tar.gz"
  sha256 "672758f48fdffcf0be48894824c72c729c07b914a04626e24fa01945bb09ca53"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "241f50679ee3fc652ae58fbb02444ce4839ff21d90cc61e68429093212d3b192"
    sha256 cellar: :any,                 arm64_sonoma:  "10edbc97629f5b723eff435b2723b01b5e17b1c85feb6f4a014218a72a44a6fc"
    sha256 cellar: :any,                 arm64_ventura: "0383ef256f26183094e3262907784e700fa0096a7bafb10ab541cc4ba660d428"
    sha256 cellar: :any,                 sonoma:        "b3ffeeefe2484be42d21f4bb4466047e1c143d543f1d300387507ed64dd4095b"
    sha256 cellar: :any,                 ventura:       "25dac322de47ce55e8cf1fe08a09bc03953d3a309617fbeb9e58065435dff483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dae0de2ffe088bd519722bd4ecf2ea3ae07ce2442ca8b3971b84cc72a313c0c"
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

    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "./test"
  end
end
