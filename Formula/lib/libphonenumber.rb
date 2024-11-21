class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.50.tar.gz"
  sha256 "a46b2b5195b85197212ca9d9c0d8dc37af57d2f38b38b8c15dd56a0ec3a2cdc0"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d8beabc380c2b656a47375d28c090bef3890ca841a3cc49c7eeba76bcf72e09"
    sha256 cellar: :any,                 arm64_sonoma:  "ce771636e0e3f83db9ea18386b20bdbdead9bbea118bba20cc2727fb7f516601"
    sha256 cellar: :any,                 arm64_ventura: "86f6557390ee7f8099834f353fb5b98b57a2f02bd096d1d00eb0d84fa0e01a77"
    sha256 cellar: :any,                 sonoma:        "e6c8020b56218a0685ab9b3dde8153b985656ad5639c83e1b7cd5ee0603092ca"
    sha256 cellar: :any,                 ventura:       "f959c41fc5a98a0adae5ab7212f9af1a4797238d734383d857cf74ea2e6c387a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372a38d5ddb6a5977b2affc2cf8a2c953256bb23562c58bde8f2779c358c49f9"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@76"
  depends_on "protobuf"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        std::string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp",
                                "-I#{Formula["protobuf"].opt_include}",
                                "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
