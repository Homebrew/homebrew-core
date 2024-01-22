class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.28.tar.gz"
  sha256 "1e51a88caf7524d045ed415b6d3a27385efa13d0cb84df935100b51658fc76fd"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ead1c21f0468cb3d772e9e56ab76f777821460c5324ef2d9973af8468e7b3fd4"
    sha256 cellar: :any,                 arm64_ventura:  "206f25d0125bd85a19a577c031898b4d84932c085e511c9a6d7b6a6fe3edc4d3"
    sha256 cellar: :any,                 arm64_monterey: "6b5536275e5e737fac04152515ac828675a87fe17419a21f9516937de164439b"
    sha256 cellar: :any,                 sonoma:         "131d72c13c55016c26316bda8bdec482f4ea192a36ca537b38c8a95acf2c4cca"
    sha256 cellar: :any,                 ventura:        "e1dd98251b9d7db9e9c9fd7fbbd64600d50e2eeae7b2c01af50a88143cfd4a71"
    sha256 cellar: :any,                 monterey:       "af98f4325f466f7b38157011026126da4967ca96dd7a55035d7e3466684e6773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2588266523b8a6c64db26a5e5c83bbfb11dacac0ac56b3a321952196883ae4f9"
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
