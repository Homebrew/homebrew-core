class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.51.tar.gz"
  sha256 "a375c51a2eefb041fb1135bcbd6ddf6ff2c9a031d098393630665f5ec7b10257"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "37add3e833ad416898373a5441bc92ec1ac06cc3f450f5799b15d00d840f2150"
    sha256 cellar: :any,                 arm64_big_sur:  "548e642d6313938a4cc03d69c84c6b6d5277e5aa8159921427060a47862c404b"
    sha256 cellar: :any,                 monterey:       "628d7d7d57159c60de920620b50643a52deb594646d783371a7e18523db25638"
    sha256 cellar: :any,                 big_sur:        "a7126493d9dc4f193ea98c2139139d72cd5c084d3d1898ffb39bab48cf2e3335"
    sha256 cellar: :any,                 catalina:       "e964aca9584b38b828120d984e3e99e72250d0ab88d4b25c6107c2542a490001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cab5e2590b5d96d486f59e91f9da0ea3c5131537161c7ab941c9c7c08b12f76a"
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
