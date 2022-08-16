class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.53.tar.gz"
  sha256 "52572d89a79db3246717b73a1557998150e2db519a5fa469db7f956a57b993c8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2efe95268700b4e3bfe161c99f95776b41f35c83630505cbdf88869424608ef4"
    sha256 cellar: :any,                 arm64_big_sur:  "28bf7d0f4d50640b5a07c31bb5852a5c706cefaba5550fceb31084fe09f8905a"
    sha256 cellar: :any,                 monterey:       "8745f4e9fcff8326647a9bd84eae98144960f4ba40aa46de32abe230899ccf8d"
    sha256 cellar: :any,                 big_sur:        "0482afbc44d928d93ee5550c2d69002f9a0a73c6cf8306f5302329aff9eef2ce"
    sha256 cellar: :any,                 catalina:       "8ef6464b606c004dc67dc4955df937b9fc5bc2489fafa0b7dcd061538c0c007c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f75a457d9731389125631cfc86899fc3a6e9ba23d775ef8bfc265082b9425c3"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # For abseil and C++17

  def install
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
