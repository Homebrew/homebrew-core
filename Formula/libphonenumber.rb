class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.5.tar.gz"
  sha256 "b7142d206f1d038108e4ba283a8d8ba4579a9616fee591ed85a0772ef18ee706"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fdefc34c538bf40c94f89d7fa6ca4f2f00c653240ae0a8d530231b5d34294dc5"
    sha256 cellar: :any,                 arm64_monterey: "7ca3efd08e77e9fccb715622573a752e0de26e8bd9ec6df04e443310208742c7"
    sha256 cellar: :any,                 arm64_big_sur:  "7d4e444e3c043accaa92cfc4c1afeaa94972eefcbdb5e2c9bd1abdff55cf339e"
    sha256 cellar: :any,                 ventura:        "635aef741d060525671a26b3a314f3efb67b43dab7b104beb74af62ff2be92c5"
    sha256 cellar: :any,                 monterey:       "c4632c600d62064beffbb286a542feb84534ff916b9c6e74584d3f181911d540"
    sha256 cellar: :any,                 big_sur:        "8842260c30bca94915ed8af86edda3e6f82ce2af30cfb83b93758050ed9b72e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bfe46cee11708ccd2d5ab241a40d5074e02a292286d495edb6fd20500865587"
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
