class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.42.tar.gz"
  sha256 "56e8ecffa47e48233cb582344f7d796eb73d2606c21572ecae7bcbb6456a832b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ebc737f3cbac2486316e70c25e232ce0f524873d0e684af7f72f7a7dffd2d973"
    sha256 cellar: :any,                 arm64_big_sur:  "82b3418487ac1e44776c083eb45b53bc34f6474411ca4b0e8b2a9914ddf4bfec"
    sha256 cellar: :any,                 monterey:       "ce073644a95648ed27f3b4a56e414199b7936fc4bbde37a1e0a953d3abf5f559"
    sha256 cellar: :any,                 big_sur:        "a8ff3bed1a48581c8c39a8564fa7a89b5298bf730fa66974060eda875069341f"
    sha256 cellar: :any,                 catalina:       "97a088b0f356b4b23529ed1a90ab717d2507f23889e3c0e18c3d28682fcdc723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9722ef0f73d7273d9af6b3fe4875d92263cb055e1ed1b34ed91ff4cda0ea6e1"
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
