class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.44.tar.gz"
  sha256 "02337c60e3a055e0a4bc4e0a60e8ae31aa567adce59f266cfd37961fceea74c2"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "7d47af52af45f1c25ff084856c4e90ec88e0455c22dd99b98299e2fc82d748af"
    sha256 cellar: :any,                 arm64_big_sur:  "3f51c7fbba94d401ef879e9007e2a7bde3f577a873f0b6bfa3c6697e2379a51a"
    sha256 cellar: :any,                 monterey:       "aa515aefb1f557b9af8805db45802772e520a8dab36ce0ab323db4b8f1629eb3"
    sha256 cellar: :any,                 big_sur:        "69184d476adc12aef817b857210c8981a40ccb4cb30adf32c9a0ccc7f71ec084"
    sha256 cellar: :any,                 catalina:       "900f1c713a071075fd22375121fbc2486d73f35dae55ddedf04d6e4397949018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8ed30e4951d8b70de8cd96d85cfcf4f540ddb6495e2e5400186a0306e0634b"
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

  # Use Homebrew abseil. Patch from Arch. Debian uses a similar patch.
  # A version is being upstreamed at:
  #   https://github.com/google/libphonenumber/pull/2772
  #
  # We're not using the upstream patch because it doesn't work yet.
  # https://github.com/google/libphonenumber/pull/2772#issuecomment-1184289820
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-packages/864f0cf5874088d76e9e7309fb3da1eeed8b701d/trunk/absl.diff"
    sha256 "f6bceb2409ff7cba1e6947e6fdce3fe82b511b04fefcd1f597eceb13af67a8a4"
  end

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
