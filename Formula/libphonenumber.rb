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
    sha256 cellar: :any,                 arm64_monterey: "1ce4141e66cdcbbc3e97675b5e32653e204384a17d9118850a69be6ef538c90b"
    sha256 cellar: :any,                 arm64_big_sur:  "857b2413748a9676476e7a6fe69abe0930094cd1ef3e05296a10b23ffb9a0e64"
    sha256 cellar: :any,                 monterey:       "0c256d3e8c26c3afd44cab11f9b0935ef9512a647d0a78670df90af6ba740cd4"
    sha256 cellar: :any,                 big_sur:        "0db7d2cddce579173da90574e35f819b2a7a0c29432472e745508a66e10b906a"
    sha256 cellar: :any,                 catalina:       "aa3d3c42f8379280a62c29947e053070b367ccb16cf9eef94dd278b0e7d523b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722eabd8a331f17a54e4ee03ec7a398f76a01b43007a96ef238685293614d05f"
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
