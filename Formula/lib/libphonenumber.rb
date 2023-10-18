class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.23.tar.gz"
  sha256 "fcfeece0ffc44b1047228b8a24be9240023f4c9105e4e88b4648978764dad9a9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcf1448aebebc26ab8ebc3156530609bc09ecfb4733eb4502cd7add4482cbdcd"
    sha256 cellar: :any,                 arm64_ventura:  "90503a59d0bdba84c9d9f5bab35b576437f5a7a5600be09f7c20378b42cd165c"
    sha256 cellar: :any,                 arm64_monterey: "470a5561f0f4a30d859c692263606ee098b160cfb077a6ecc9bd2e59480b10dd"
    sha256 cellar: :any,                 sonoma:         "270a19b8d9bc5b5bd13ecfc7adbd9ff0983811f30c8bcb7b5029413ecd0146d3"
    sha256 cellar: :any,                 ventura:        "2b2730b065530a3df053b47f76ab0fda7cf264a90d3bbf1a1a23b6dd4c797dd6"
    sha256 cellar: :any,                 monterey:       "479b131231d5476fffa50d94dfe34abaa995b8735c86b506b9f363e754134fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be31761e166be114153e795319a6a661592fce62153caae25d5f46d4c681cba"
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
