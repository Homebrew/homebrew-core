class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_16.0.tar.gz"
  sha256 "5cb850ed35f33edb322ec5ddd7ddca9caec6eefb7550632226630e70f6ab4e0e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "293ecb3c46a19a801a37ddfa6ea895fa089797ef162e0e9fd1e77f612051a564"
    sha256 cellar: :any,                 arm64_ventura:  "5ab1d9de4049a99e9a8088dd6974d8a45a907a74f3ff68d020561ed63bf8e720"
    sha256 cellar: :any,                 arm64_monterey: "647f8bd4d0017abc35fe1823809803ede2b992a69d05ec563faccf0ec2ba3b87"
    sha256 cellar: :any,                 sonoma:         "63cc9e027a29042a96e8c83e431d9995dfc5ee077c96fed3f74b910abf7eb918"
    sha256 cellar: :any,                 ventura:        "82273e5e3485622be08eee1a91f343b43ea120ed3249f3f79ffd72407e8f75bf"
    sha256 cellar: :any,                 monterey:       "3ca4650fdc61a89df1a2a1decff56f967a064d642a1dd931123c4207b545d16c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d1a660e983e603a38d3614dd283d26a2b569864b8fa59626190e0f8ac33de09"
  end

  depends_on "cmake" => :build
  depends_on "llvm@16"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if ENV.compiler == :clang && DevelopmentTools.clang_build_version <= 1300
    ENV.remove "HOMEBREW_INCLUDE_PATHS", Formula["llvm"].opt_include
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        int arr[5]{2,3,4};
      }
    EOS
    assert_match "{2, 3, 4, 0, 0}", shell_output("#{bin}/insights ./test.cpp")
  end
end
