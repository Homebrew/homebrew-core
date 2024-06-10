class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.4.tar.gz"
  sha256 "a1105023795b3e1b9abc29c088cdec5464cc9f3b640b5078dc90a505498da5ff"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "110519baf1c726740b4748cd39bcb66867f2938daa5d71ad08a015d8292ccf8a"
    sha256 arm64_ventura:  "9438db1aef2f98052cc7244674c175d70832e30428f3a5aeda6859a74393389b"
    sha256 arm64_monterey: "ad9ebe8735ac6e3ad0782840148643a978b8f650db46b5e8fed8b2ecddda74d3"
    sha256 sonoma:         "ca17049b8bf9d94669f80055020a4a97e7b9e8d7acef2d49389b5921fa0ed50d"
    sha256 ventura:        "85da93df94f5ce40e8934288c399d662a03b43b1b0b929c6fb0e2c539e9868a6"
    sha256 monterey:       "2d2d1b00f0f987c543dc8591372a3027fe412b9f87de9a8fb41922d2a9584ec1"
    sha256 x86_64_linux:   "17cb565d09e40f30403b0b6dc7cd55cd618b1dcdc790fb9fd3d675138587a5cc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
