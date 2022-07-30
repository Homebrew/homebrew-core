class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.20.tar.gz"
  sha256 "45cfcdab07f824f6c06c9776701156f7a04b23eadd25ecbc88c188789a447cc7"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 arm64_monterey: "0771405df1deec6b060a4f3c99439cd49c40a8749d8a7c192b045232e285165f"
    sha256 arm64_big_sur:  "e7c5589671130966af58a5040bc85e58a03e7bf1e58cf24b88a00960a40ce40d"
    sha256 monterey:       "24fa77c3b3d432bd5dafb11cfe17c54ba12140fe187e70050ad9281f438e84d9"
    sha256 big_sur:        "16074e6c469f2ef05ab4cec5806b77fbf3433ec4d81f80c25c7f4188ccf6b3dc"
    sha256 catalina:       "3ca416dc7635e808b58b0e94216d4037bc0c1f2338b6cfaa5f4e39ad527374be"
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
