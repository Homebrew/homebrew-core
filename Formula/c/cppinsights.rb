class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_0.10.tar.gz"
  sha256 "996d6f219600d03f2be1e2e34adb23ae57a591b6ef7bf4582cb74042fce430f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a3c034593d27d5c39efbedd5e4e40704bdff1d3039d5deabe615276531125e6"
    sha256 cellar: :any,                 arm64_ventura:  "406ea9f2f6f4c61d5a945f12fafc9c7f9ec4592267e7d30fbac15d3a72837b4d"
    sha256 cellar: :any,                 arm64_monterey: "eec90bbbc11c4bdf18e09eb4ccef7926edc437d9a47abe348cbc9bf503286826"
    sha256 cellar: :any,                 sonoma:         "13de2da8490520bad71dfb1d2f5f4b0b5253ab413feae58de64d72133b388647"
    sha256 cellar: :any,                 ventura:        "e3b6a90e8004cb402fcbbbba58831d3efa0b50e671619c7aa0e4edec42503aea"
    sha256 cellar: :any,                 monterey:       "59aa5557589e57e98f48d028b6262c8add3e060d542d117c48912c5f12048d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f213e23e4c4ed8408427ccdd9bd9c172be39ffd9b19eacda32d6a0d0f1019f"
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
