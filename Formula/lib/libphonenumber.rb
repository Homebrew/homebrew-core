class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.42.tar.gz"
  sha256 "7fac3a3c5f37607108ea2ca4c334000a6c29fe1cd6b30db31505cba73ab96c7d"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e82f8ac215538beef9c703b6e70b69cc93a1bf958a5d0fd4f93705e2c63b40c"
    sha256 cellar: :any,                 arm64_ventura:  "313604b02558641fc1b7b477a4e1d3eb3f7c5053e8f20e6f0bb2a2c8922bebb6"
    sha256 cellar: :any,                 arm64_monterey: "b26f3508a255ba6c03e626ef59d2e398b3e33de3133bf453981d1346c1702eea"
    sha256 cellar: :any,                 sonoma:         "28f01a0e45265e46bb524daaa3dc93ac5a821045631a01da57268c26944137d9"
    sha256 cellar: :any,                 ventura:        "95d468c72c096d5ad66ca7ce7d07ec839e0b6798b60e27c6d73b4faf3d349827"
    sha256 cellar: :any,                 monterey:       "92f19efdb0df1d6dff71a3fb50b7396379c4eb0522309f29942d9b8e0049ccea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543270c8fccaab81d8cacbcb909df55f88be11f624f50f4fcd0b230f0afd0676"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
