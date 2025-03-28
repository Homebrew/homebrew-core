class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "853f980ac2aa549e8a5bc12e0edcd7124a44ac2160d0b8611f35cbf613793fd7"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2801a4d5467c469b5853bc984e4e16a31fed65984a03ca24a20ce0af610fdce"
    sha256 cellar: :any,                 arm64_sonoma:  "b3479f804dd561b3c4afe62142aa42c762cca8ac0fc8886cf7061bfd596a0c41"
    sha256 cellar: :any,                 arm64_ventura: "4eb0cfe2197dda2104a6f52c17233d0a1331bd30bf0c45db89ace3c7c45c669b"
    sha256 cellar: :any,                 sonoma:        "136d70d15b6395e826f5dbf7ebb227ffb9204ec09395750b4e71c63767f7809a"
    sha256 cellar: :any,                 ventura:       "af2cc2c37e3579551ca4cc2d6f92c2807e6ebb160bf8b3832d48ed37036f573a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dd006e4320bcae3a057e20bf958075ab35fa08ec0dc647dc45e4d92e1278971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23d5e67dba454d441d28a4ac8fa7b2e673356f560f393f5d2fa7fb1c562ca255"
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
