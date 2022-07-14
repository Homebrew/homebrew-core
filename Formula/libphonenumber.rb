class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.44.tar.gz"
  sha256 "02337c60e3a055e0a4bc4e0a60e8ae31aa567adce59f266cfd37961fceea74c2"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d4692fe8006747aa16e131381097922fbfc9826398220db6068069c9514add5"
    sha256 cellar: :any,                 arm64_big_sur:  "7cec0906b938f505103de77281a5730b193c70485b86c96f86ba511c0bd4e93c"
    sha256 cellar: :any,                 monterey:       "8109872f17d94846255cc92ef880d7fa958ac45403fee997845a96384ab310d1"
    sha256 cellar: :any,                 big_sur:        "f5e92a6627d36e0f8c91d33ced2efad3f1944431b76dad0d0cc6628bf52b98a9"
    sha256 cellar: :any,                 catalina:       "216f7a2a964ceededb7e10e564032addb93c56c0557ae6970240691dfb426734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8aba9188bcaf8dfb08ed20aa014e8ba7a465c70575d263317beeb19f9ac174"
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
