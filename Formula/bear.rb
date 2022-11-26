class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.20.tar.gz"
  sha256 "45cfcdab07f824f6c06c9776701156f7a04b23eadd25ecbc88c188789a447cc7"
  license "GPL-3.0-or-later"
  revision 6
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "0746483d865b83e8811b9ea5706beb14872d6da3ecbb4153ce8cb26482ef167c"
    sha256 arm64_monterey: "e89cc7e6a7a4cde8fef8d2f83fa6788682a43a702f87d4b4399bb8df78f36ad7"
    sha256 arm64_big_sur:  "8d6efb13da7a86918cd50c84a7392c4cd6ef07a89f7fe309583cfa1c52d417aa"
    sha256 monterey:       "87a438616fd6e9b00fa1da8551d53e4fc5d468d67de6ccdc4bfcddb9d8d0d43f"
    sha256 big_sur:        "3715d37014fad3eedf55c6b80161014b3122483d3ba17d748e24a6377facff1e"
    sha256 catalina:       "c3e77c5a0e394d30a6b0f06b2dffc9d16e0ddc8b8a871ca8aa55f4b3f6a9242a"
    sha256 x86_64_linux:   "deec6e622fe1b8f0d52783db5f7163f2a1b5155b7104cb889966ab35ab595ce3"
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
