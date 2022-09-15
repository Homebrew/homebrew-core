class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.20.tar.gz"
  sha256 "45cfcdab07f824f6c06c9776701156f7a04b23eadd25ecbc88c188789a447cc7"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "fd7cebdc653cf89784ccb7ac0d63a66eaad730f8b8a65dc1d021b5d3707273e6"
    sha256 arm64_big_sur:  "8a97aeee7a913e1a588fe09f2b25379dd910ab75884beef74fcdeb1540837428"
    sha256 monterey:       "2383e160d2d48400d5b6b8ae219280bafd33aee576333abc5a4d3114b5d5f134"
    sha256 big_sur:        "f2ddf39c0032e194ab275abcfa6b7b8da3ee4dd9476a05775284f8839f840051"
    sha256 catalina:       "e6970ad002595c6c55ac8efc49a50f24ced66471888dfc7c18059648f89e5442"
    sha256 x86_64_linux:   "48046a4591aa44a377c4ee78f100a9baaa78efd402e99f59b60c2b807fe35253"
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
