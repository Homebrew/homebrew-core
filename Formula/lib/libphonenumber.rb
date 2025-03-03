class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.55.tar.gz"
  sha256 "0a4af8d319bde54565ebefd6ec9c2708fd9e145f6ee0469345b3bf07d2e4c8b6"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e584b78baad509bf1692eed2cf6c7154386c450231d26f67f465610e1ffe120"
    sha256 cellar: :any,                 arm64_sonoma:  "78f884086fb1fafda46dd9eecd83bd1edd1f2d98dfc6efd7c56400835a290331"
    sha256 cellar: :any,                 arm64_ventura: "6202d40f88a74330f8c394e73da772e93ffc20059ed92f5c3905541ebb075427"
    sha256 cellar: :any,                 sonoma:        "ba219e3b3c17de35aa0d30d75e3b6d3b00220b1d6183fa971470c08b17e4385a"
    sha256 cellar: :any,                 ventura:       "6d8de6288cd5d0c0284f260f7e7aa81490161be6b3267ae0be063d693a13ed8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "439c5e2a0a77cabf9a1df954d075b28640fd09b30caf844df46bdc13ef965ad8"
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
