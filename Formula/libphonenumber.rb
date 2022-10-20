class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.57.tar.gz"
  sha256 "c7b47822d3c16c29ec96268bf1a8bb536a11e3b2c130f0ad92cfa671ac212b32"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "199eb5ac82bb20b4aa88bce683c7f80ffba00f0ae3a35a225b8840a197f73cc2"
    sha256 cellar: :any,                 arm64_big_sur:  "584bfa3cd6bd8e737bbb8d02bc8d11ffacc05f27ca4a6914c6b0fe6f382eaf43"
    sha256 cellar: :any,                 monterey:       "c7266ad973df804d4097516e0505a823c5889cfa26116107c001d9a126b9b91f"
    sha256 cellar: :any,                 big_sur:        "8ffdb95202a7e45f7ad5b790b2d4a49b124e76cf5614c62ab8c3ac56594a2857"
    sha256 cellar: :any,                 catalina:       "e293074892c7ac16158803ecc7cbfc2eb14267dfb4adf6c80b3c2bde98a7bef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bb359a5e4b9794d20908d7777eb5238384a113122770459a0650c3a10b24346"
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
