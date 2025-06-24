class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.7.tar.gz"
  sha256 "15b929c24e9071847893cc2bbeb29631eab819ec6561baaf51250852773348b0"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c49b653c849e8feee536a4edf9db1312d19119ff9c1ebaf118919f53e3496bd"
    sha256 cellar: :any,                 arm64_sonoma:  "3aa14d308d08fc353a95ac8148c4d14fc2b8a052a054deaeb5f4a553a7326edc"
    sha256 cellar: :any,                 arm64_ventura: "5fdf9e0c1e645cea7276b890ece0c62eba446c35a16a335e939038fbe6f9845c"
    sha256 cellar: :any,                 sonoma:        "698b5b23b22139c8dfd7149c93c0a6a748ec1ed89bc847787ebca8968f0edce1"
    sha256 cellar: :any,                 ventura:       "e7a5ffc45484bf4621cd45b75cae3efd78843bd4074b38ffe30366e134051801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca6d004ed21c200d75a12b285f3ce60b16901dc34053468ea9055fa922c37920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed1a418bb9c01fb1c74176627854f8d730917fa81fedc47e52b18484c2af5d8a"
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
