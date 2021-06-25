class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.26.tar.gz"
  sha256 "b8b37fe1825863a964660415cacf687c711eff88c64904cce8a8030234c0a334"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a2d8a40e4c429466ec1fdfca7e9c54003307700717204aec3f25b51af83e291f"
    sha256 cellar: :any, big_sur:       "df60832f1d90d7847f730bf582c4327ec67f570c9924f8ee26cbd44123a29a1b"
    sha256 cellar: :any, catalina:      "9b2bf5bd17466fd2224eee8ca8287efde50083fc3de96249cc65c22f6d1daab0"
    sha256 cellar: :any, mojave:        "e2b128f2dae4c92d7f0f8bb64122f8f2cc7b7251eb341cc03268cf9e860aa7b2"
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
