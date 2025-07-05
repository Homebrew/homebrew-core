class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.8.tar.gz"
  sha256 "06c7b1744fd74418bde502b00dcab73b8475e9a30764fc73b1deb30a3d452154"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ccf1910e340cd7a20c4662fbcf9157a2d5e1318b13489572b7788e95a978bcc2"
    sha256 cellar: :any,                 arm64_sonoma:  "1c2678f579b28692665357bcef94a4d3f622c0367f0f5ab501eff24cfc1017a2"
    sha256 cellar: :any,                 arm64_ventura: "88b0b1ff49a56ef7f8c0ec5a34f150a91beb13cab364761979bbfcbc2d8e5122"
    sha256 cellar: :any,                 sonoma:        "f49ab6b3f7e54018c959d872f41b2477b925eb77bce7465defb33bfbfb2348ce"
    sha256 cellar: :any,                 ventura:       "df7fdb1c95cdc1d042cc03557da05a844bc4fbf661e111b9cb6ae414ef9b3f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edec309c1dc907f8eb87cf7f46ed3380230c89803231905416c9d0fce36e7c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a137c6eb80cbe1450f1c4fe0da8f5c97ed82e2a2e050ab8cc8b9bc600c33ee71"
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
