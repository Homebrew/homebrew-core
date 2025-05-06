class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_19.1.tar.gz"
  sha256 "88853a67b9eaf6917c531071436a275c62f1dcfe6f2e02e521c39ce81b05e6a7"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d18cd5ec355ee5837de270d8d9e344fa1b51c6f05d3564e0d83feda98eabbf4a"
    sha256 cellar: :any,                 arm64_sonoma:  "c341a589e89f5d8f6b6709ac1707aa8c964b6bc02fe70310f341916a4ff62286"
    sha256 cellar: :any,                 arm64_ventura: "bad909888167aa7f7604a28857051bbcbfdc1d0aae3c9df2be799f312b0609b1"
    sha256 cellar: :any,                 sonoma:        "9b0e9c60ce28117102ffeafcb367ebe44c378d11d8b2a6818c59d09295156159"
    sha256 cellar: :any,                 ventura:       "ab1c19c457f35f607c4afe660d31c8458a500c7faf04cd7b5560f5bdf97690d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9f09af7a75a146f5bbb5ab2b518e7d421680cb1be41f1c2da0ad8b388ad2aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b45f335bbd304b2d97110b337586a98aa87d750786942f8d1bd2505df144de"
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
