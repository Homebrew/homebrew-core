class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "d6a4cdaa26aa68676344a9b34f61753e340cc96e644c45c3546f36f367a3772a"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3bfd959ed8dbb6b4cb5dab93f05e7e1ce230d7cea4c849ef3f0f5418ade6f7e"
    sha256 cellar: :any,                 arm64_sonoma:  "3c7a653e68777a4402075733ac56846a33b76bc7e94e90f9b4c6be12066b565f"
    sha256 cellar: :any,                 arm64_ventura: "09b13e6a9726f09577c637107a664dcbea247196455c9a7abc59786a2d265798"
    sha256 cellar: :any,                 sonoma:        "7a9e67ca30a08abb510c83a099090a0910d1f7fa85ff3baf6213fd6b1b6a0663"
    sha256 cellar: :any,                 ventura:       "12149c67d6c887170efb3febd9716235ba87e307cfd1eb52d0537f1ee54d3669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0418cf21db9cab700409acdd5a11913f3c8c5c4d2ac77bd1a5418856db5b8adf"
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
