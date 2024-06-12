class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.38.tar.gz"
  sha256 "be552c23c321857630b6abc35aab64d75a8de6bc7a72443863213706dad74891"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "19f2f74b6d7459bde781584860840e0a66da6d29ec1013d028042e1e1bded54e"
    sha256 cellar: :any,                 arm64_ventura:  "1a375a37a14949d999019db46f983364b2094e76417f2696a67341a4b437214f"
    sha256 cellar: :any,                 arm64_monterey: "170b96045364ec0ec801c64b617ba9bb614d2ce0870f3737ddfbd8fae02d5dd2"
    sha256 cellar: :any,                 sonoma:         "0f6eda84f16012148b79034e913c122caa3d8aa4b96d918fa1ca7216307389e7"
    sha256 cellar: :any,                 ventura:        "1ddc31d31c52fba0274907b9b451eda7817792c815ba13d12ec95d1fef3a72e2"
    sha256 cellar: :any,                 monterey:       "1a972e85b95ca05c5b71c33d8462ad2546963974a0c4bc3d7b22d4be07dbc29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe322ce24ec304679b0ca8975b130e95387a78a9676aef3425428c8920fab70"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@75"
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
