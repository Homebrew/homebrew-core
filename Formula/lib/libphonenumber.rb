class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v8.13.32.tar.gz"
  sha256 "88ba4be45cb95bd01b87952d37416145bd135e203c1f6893a610983463c0cacd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00497659fd1d85416684ee54c63477bcd039a19b2795f00b03af8e3c8024b291"
    sha256 cellar: :any,                 arm64_ventura:  "5f43d8aaf563db8e499747a17a8b48d75d4aef31e289b49b87b758217c9d3af8"
    sha256 cellar: :any,                 arm64_monterey: "d8812f3c6a16e58a2b70400a9c990bbf33fe2051df9c3f10208e098806601f06"
    sha256 cellar: :any,                 sonoma:         "a8f60412f9dadce7913cf44fad0c5eb75e2347274a0084dd82039523d807cb5c"
    sha256 cellar: :any,                 ventura:        "312255252b6bcb0cff0caaed54a433889604d1ba6b67031868ade9546ad72d6e"
    sha256 cellar: :any,                 monterey:       "9a88c93d0abfc725c738918c62cc3998645a825bbd78b47a6a57839684de7bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01dea4fdc52871b015acc1bc8fded602b61126212433aaa23517113f415cea4f"
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
