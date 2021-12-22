class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.17.tar.gz"
  sha256 "107f94e045d930e88f5f5b4b484c8df1bf4834722943525765c271e0b5b34b78"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "3f366feb81ed3dae4afe765bc5c272a11daf4bdd7559afda6d7b460576d8e37d"
    sha256 arm64_big_sur:  "6341a70bdba3fa717bbbe2c259fc4aef466eb2cef33de97531a1fa4d8b296e18"
    sha256 monterey:       "c2c2da98b2ff033adba675065f6696c651d6153c796438cfd20e233ea81c3238"
    sha256 big_sur:        "37bee2c41f08c2f2c347ff2aa146121105f5263d2f81b02b0de98117ce91947b"
    sha256 catalina:       "65788b46e3d91ea320b50020d11c0a78ce3c39a49825d3881ef18a2e9d862eee"
    sha256 x86_64_linux:   "db19e329bedf1d6466bdd07feaf51c7b5de7eb162015dedb1ccd81546ee18ee1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "all"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
