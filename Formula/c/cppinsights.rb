class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_0.9.tar.gz"
  sha256 "cebb6a062677ee3975ff757e4300a17f42e3fab6da02ad01f3f141fb91f09301"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36e2fd7b9fb0284e398a64ac0c9f6d7ffc2e2617626d8f876fc4227852afa28f"
    sha256 cellar: :any,                 arm64_monterey: "2f250a6e21b88c228c715e63ae1de66196859fc5751fb29a9a2ce585b2c39738"
    sha256 cellar: :any,                 arm64_big_sur:  "333f575048c3bb485369a0a1aa09a063bc7af150acca21c38f0faccfabd3d3da"
    sha256 cellar: :any,                 ventura:        "0cb4815ffc527add05af26c1b88c4c9da8e5a2f6558c263dc877e8ef151b6d97"
    sha256 cellar: :any,                 monterey:       "f2bfdbca4a6fc6ef1c2268f4b9824312f97f5a5492b25be8913f1b5ac27bef52"
    sha256 cellar: :any,                 big_sur:        "2c80068af4fec4b7cb3c9a13c4665e3c6c6edf1ba328d35d333e0365af03fceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "930267fb74d358f9e7267975019bd186208e11556de1c5011363055646440018"
  end

  depends_on "cmake" => :build
  depends_on "llvm@15"

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
