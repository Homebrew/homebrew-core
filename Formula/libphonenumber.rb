class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.52.tar.gz"
  sha256 "c5d4220df55da697d63914505cc4d54cfc03dfdc08118ba736c7b92a1b5eb730"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a66f4f0fffe1810212f3c00eb9721009a2695cc22e30bba364a28fa34f410e1f"
    sha256 cellar: :any,                 arm64_big_sur:  "f7ab04466413d8ca79c6e868d7fcb461eb7f7ab4466050f65006a9cf9a30c4a1"
    sha256 cellar: :any,                 monterey:       "82815db8d551be9cab45ff919e5e708408af761eaccc441f3428ec6126462037"
    sha256 cellar: :any,                 big_sur:        "9078e621fe58164227616468dd9395c1536834262963fefd96c6b17c8728a557"
    sha256 cellar: :any,                 catalina:       "294eb4c3c22f0500ef945000a1a9258e0c8307cf7b70f519a2872e3b7629efc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01e497545ae0bd84a3be87bacdc1c2542499d473bc69c93dd16ac36e48765c24"
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
