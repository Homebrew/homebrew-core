class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.39.tar.gz"
  sha256 "700eb7a7b9a4bbd1c8aa757aaa7b0cc8c5047d4c33c48518564eb3f0938e193f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "efb9ac2e331204232de333fd150856704480322af562060368a88e671851ba5f"
    sha256 cellar: :any,                 arm64_ventura:  "672bd3146b63b0f2724765dddff6e4986634768fc1d5efba5a8a8ddc46d086ef"
    sha256 cellar: :any,                 arm64_monterey: "2079af57503c03300f8341d449e9e076048adfd8e140fbdf581109993d9f5cc1"
    sha256 cellar: :any,                 sonoma:         "a4d840138316dcfcc6fa0f978ff0098bd87ed1b54a09085c25f95cc3d1585154"
    sha256 cellar: :any,                 ventura:        "274fbae28f40237d396add0e8d92da4144d03426f76339d6edfa24417e22e4bf"
    sha256 cellar: :any,                 monterey:       "a971e366ff1e55f07843d13110f243ea25d037bce87ceed1b52762db25caacef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c64d22993bcc6f1c980d8cfc4bbd8db690139980b8b17b910e02a9b841b9fda"
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
