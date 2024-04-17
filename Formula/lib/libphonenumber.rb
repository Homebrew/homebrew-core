class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.34.tar.gz"
  sha256 "812a36cd5c9349c01eb7f6daea836fe8f9829a6a4baa8299fae82140290f632b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00b37f3e10b86ebb751c60c99bf000a59071a296564fd98dc19fa606cb64c8fa"
    sha256 cellar: :any,                 arm64_ventura:  "d2946dcc9f459f15256e6af6e038468906288a9a0accce9923a50881f9bce848"
    sha256 cellar: :any,                 arm64_monterey: "45cfaf45dcdc0f3345d070b667aceba99a03ad5a8a60e9a00a6ae102934b9e88"
    sha256 cellar: :any,                 sonoma:         "597989cb3d53768e2b7343b337abccf1ef3e9fc258ac3ca34a6b639c4377651f"
    sha256 cellar: :any,                 ventura:        "5efd73a48152d34be6df35da5d5645e172df1774056199ab311f4c177a664f77"
    sha256 cellar: :any,                 monterey:       "0aab3e379214649987a0555874f233424a368e7f4bec9ca4990ff6ff6bdc3c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4b4372e5d019c2706d02d17895cfcacf2d7a53ba58f9bc97f0b627e3217958"
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
