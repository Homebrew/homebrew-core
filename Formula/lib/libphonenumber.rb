class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.53.tar.gz"
  sha256 "2168fdba69e09825992a9a714d02cf5de19da60d6e3760b9e55da3882675e734"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb15f489238de1b5d5f506b308fe5238fe0945b4d9b5d3038414f528aced54b4"
    sha256 cellar: :any,                 arm64_sonoma:  "0a359cdb5b72cba767b8a3dc39bec2f843c77e43457cebc01b7f0048d721113f"
    sha256 cellar: :any,                 arm64_ventura: "cebc6bf24e18a35dc7d97ec8ba96c18558b632020f03b45dff8b2b3607ff454c"
    sha256 cellar: :any,                 sonoma:        "130e27c9da40501ecd96f0941f39846aec733a8488005028a19a655b054b6493"
    sha256 cellar: :any,                 ventura:       "48b6bb63e874ad2daaf48cf924063936364904fa2d2f87534dc8da8038dfa960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b91eb31f642cb2419d0b8099e7d3e99cf8f300f741a786bb5a2ae8ed7d50dc"
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
