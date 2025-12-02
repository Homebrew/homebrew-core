class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 14
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "0d235eaebf9cc6e4719a86058b60f209f63771e786699c5734e8fba33e82ddb4"
    sha256 arm64_sequoia: "1f6eb8990475c3bc4872984b7fd70e3a7f5d5e1c64ab96e45dc98ba0b3b573e2"
    sha256 arm64_sonoma:  "16a9b941646031b42b41be0db65d9e593553e6b1d4b043236f4de2c2e713395d"
    sha256 sonoma:        "1847db3aa97264ed862afd71e72b8229f8446a6ff7e6c2d2e78dc90957d7d196"
    sha256 arm64_linux:   "2db2662e1f095c29d5815c97abd972bdba964a2f0b16bb9060c7f4b7c7b273ea"
    sha256 x86_64_linux:  "28f6edd747b0b093f320afa3c8a5dc00aa6f2a9eba40bbda01a3efa87510585e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "protobuf"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
