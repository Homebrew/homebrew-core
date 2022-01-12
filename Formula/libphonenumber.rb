class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.41.tar.gz"
  sha256 "5960f19594f4cbca4a5ff172e12d2bc6e8a7e7399522ba82cd4f58cb0d7270c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0156e3c0377566bf8ba4b9faf0765e1f26d703bf6ec3cdedbc54cd2366edf7eb"
    sha256 cellar: :any,                 arm64_big_sur:  "88ccadf83370dbd83bfe19e164ecd1c724cc78e45f3b48b0425aa0b80df25f69"
    sha256 cellar: :any,                 monterey:       "cff413c0eacb0b5ec2e85b88da8100de889ad0e27effd787a1fcfc697991b3d8"
    sha256 cellar: :any,                 big_sur:        "c8610093094b35e936782fe6754684dd3d77c39930c05d6bcafa90424a80c6ad"
    sha256 cellar: :any,                 catalina:       "2bab5129d8081bf9ecd74a4137d689f229d33a40515df31b5d244a7454383fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5af80ea009a3fd44fbfef7a6423011bed8c729987166ae022a8f6f3db04643e5"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  def install
    ENV.cxx11
    system "cmake", "cpp", "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].include}",
                           *std_cmake_args
    system "make", "install"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
