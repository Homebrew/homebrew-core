class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.20.tar.gz"
  sha256 "45cfcdab07f824f6c06c9776701156f7a04b23eadd25ecbc88c188789a447cc7"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "46fda09b07595c10b4f1bae2cbd9f5c173e141cfb74ad0aa29c774ae209d4210"
    sha256 arm64_big_sur:  "1840d46bfb570e651bbbfaca709a9872cf5a674125b3694213ac43b9bb756687"
    sha256 monterey:       "52596f07897a556ef2e7ed8fe1410d472be84b1fb0824776bddf672854ea3a3e"
    sha256 big_sur:        "5846258cbacc252bfd87a6d49b250e78e5408b513d7da02364e0c76596082115"
    sha256 catalina:       "ff0993843631f66dc67851e65638331d7d038b2e8c12229485ac3e060000652f"
    sha256 x86_64_linux:   "3c3fb34c3ea1936602996325f211f4c58d46d7660e0e3bf523a3498574150191"
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
