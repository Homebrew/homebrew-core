class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.20.tar.gz"
  sha256 "45cfcdab07f824f6c06c9776701156f7a04b23eadd25ecbc88c188789a447cc7"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "9f98780db6162f85c462e098b21c12a08068bdb2601c4849d97296ff53a8315c"
    sha256 arm64_big_sur:  "d4d8dbbe286622b7a96024946c4cab5b0fd79f7b53337c9206233e974af2abb0"
    sha256 monterey:       "f9c433ce04ef8887f50141ff297d3fb3ab822bf391f2bd1147528f3d343ae94a"
    sha256 big_sur:        "5e8a660a46ba66d2867ce4d572371337be8a62179f0bd98b126cc7b55b00fd18"
    sha256 catalina:       "eb20a1e952fbe967b7a5d9901039dadf7dda48182a5850ce19b42cd1450fda79"
    sha256 x86_64_linux:   "5e533a4a8b72144dd716fd7d0d23598bd4ab78f7693ae19aecf77a13e19f3bc7"
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
