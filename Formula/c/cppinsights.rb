class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_20.1.tar.gz"
  sha256 "672ecc237bc0231510025c9662c0f4880feebb076af46d16840adfb16e8fc4e8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a633e7409562a57dcb44c9d1dbc216b3aa44ad3cb2a9424ddd3c00380ed06570"
    sha256 cellar: :any,                 arm64_sonoma:  "4fa5e74d7a8ded4618e8c6ddae47c77404891162e7b1fa38faad2cb9da5e1247"
    sha256 cellar: :any,                 arm64_ventura: "c79eb403f5dcf43df867b2c2816c44527ee0bdea3c309161555a9f17a8d69762"
    sha256 cellar: :any,                 sonoma:        "949ca974b680ae7f24ea630bf94c668f69a846047e965aee01a8cb76950e6ca9"
    sha256 cellar: :any,                 ventura:       "1a8d128dffa08e8846e4d40c6272c094cbca13cf74b097690c3e2ad75762f76b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2fb8f4a46069faa95fd11d1572e5885b085a030db0d81441d674e5443b2ecba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e8bd9b586a8a317b8eefbc6f6024a54f05ca22c47e7d016fa6100d18649abf"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with :clang do
    build 1500
    cause "Requires Clang > 15.0"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    args = %W[
      -DINSIGHTS_LLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config
      -DINSIGHTS_USE_SYSTEM_INCLUDES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        int arr[5]{2,3,4};
      }
    CPP
    assert_match "{2, 3, 4, 0, 0}", shell_output("#{bin}/insights ./test.cpp")
  end
end
