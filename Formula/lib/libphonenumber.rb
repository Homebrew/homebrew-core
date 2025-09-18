class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.14.tar.gz"
  sha256 "76e9f41fbe812fc12af2531f3128dfee33fb777c3d8ce599af16c88df2861326"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6307636bf3b1e7c93628c4bc5b71349b5e372cffba62b86f65df6f11a87969c4"
    sha256 cellar: :any,                 arm64_sequoia: "c05672320b71e8834ec945a9ee23dcdd25dac495252a9ad0f658f1195bf8a006"
    sha256 cellar: :any,                 arm64_sonoma:  "55fc947aae00562b49a4bc463ef0e69e60f020809789adf2348656114dfb054e"
    sha256 cellar: :any,                 sonoma:        "868ffbae197ddb785477d69aa46b371eb3b43def1594f9748caee2e8046e99d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28cea8e25108247a12092f0b6a3af33b807a5085b0fa6a6f8ed8daa7236f82b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6c6496b539a6f57814f340f00dae6b11eb5f50078876dcf30cb903e32ef1da7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@77"
  depends_on "protobuf"

  # Fix build with Boost 1.89.0, pr ref: https://github.com/google/libphonenumber/pull/3903
  patch do
    url "https://github.com/google/libphonenumber/commit/72c1023fbf00fc48866acab05f6ccebcae7f3213.patch?full_index=1"
    sha256 "6bce9d77b45f35a84ef39831bf2cca793b11aa7b92bd6d71000397d3176f0345"
  end

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
