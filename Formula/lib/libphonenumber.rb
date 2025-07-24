class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.10.tar.gz"
  sha256 "f8d1090f0b78b3756e9b3f81f474e62b3afd14f16faf2d5a82597375f1fce4f0"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "42bb646024008e8e75349337505071f599dc3d522650e456e56045b981bed86f"
    sha256 cellar: :any,                 arm64_sonoma:  "ec0af8ff807250c30ce26f7b65cd1ebd6733b91c7757936b8af6801fbd168d63"
    sha256 cellar: :any,                 arm64_ventura: "dedd4b6b42e04a7da9a78e8f42e574e3f7c227e4831ce5d54f615bf2e1f2e6ce"
    sha256 cellar: :any,                 sonoma:        "92027dfd70f20fe3d3bf65c1b09f6ab7018fef504be766f680d6427e63e27800"
    sha256 cellar: :any,                 ventura:       "6c9cb5e7ccb70a199a939ad4562fb34120de0c8528369f18ee2f62411fa3d308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e6de70fe3ab67d8c87517436edc8f33f71b0ff0957d2b8d30fbed928e7c86df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bdc4caa5c556dba793526ae463f03ea8d99f906a441de7705a94957a332c364"
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
