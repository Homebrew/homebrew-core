class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.34.tar.gz"
  sha256 "2e133ca9f1ab5f54de23b2c17b59d7b47114ce5af1b83762238d769a2864a46d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1a43d959dfc3ed1aceb7f17054a386a28f5b1dda6046f1d9be43face609e46ff"
    sha256 cellar: :any,                 big_sur:       "8676ec78d3a387bce108dc2552c8b8c398ebb96987349c84846862e8e6d84ff4"
    sha256 cellar: :any,                 catalina:      "3cc0ff1c358a5896735f55336184eb721e4977b9c5311fed91523524f9decd31"
    sha256 cellar: :any,                 mojave:        "593cc1b4dce21e6310ca775e4ea6057557e13dc73dacef89a46b417bc5143a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46fff018025a5619553fe1caf202b9234401b8fa72d00d29fb6dc171d9162963"
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
