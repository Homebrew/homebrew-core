class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.56.tar.gz"
  sha256 "51ec355a7e021e282b5b495ab6729dcef310598caba34c7bada41ae7c14ce919"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ec28d0e02c101eea3d24860f3b95e5dd4ecf20ac35eeea08a17a1e1888b739b"
    sha256 cellar: :any,                 arm64_big_sur:  "920b08e51932939428ef5ebe41ea1f635dc7e7b43b93e5b525ca601373c4d512"
    sha256 cellar: :any,                 monterey:       "d370dbb2719d548c358993e175cc53642a29923440a267d10b21d61cecf994af"
    sha256 cellar: :any,                 big_sur:        "c2a440ab3388a411df0951961a706f5be10a3f37850089bffd131828ff176b83"
    sha256 cellar: :any,                 catalina:       "ca7fa7998f18b85cb5da5b962b34d914a549ba29ed7b88003644b8fff64f61c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c4b976eb79920204b77f953c277ce04c9e4bd265c2393a0f599328d0704350"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
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
