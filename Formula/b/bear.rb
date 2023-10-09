class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "a140643871fdebf31b268d285cb33851d8a9e8bb6f3b9605d677f9e16a0e84cd"
    sha256 arm64_ventura:  "49a99af4fc03dda32285dad3c5fc94a812cfe21323f48509324dec79abc02b4b"
    sha256 arm64_monterey: "9b88a8da3a41f567e87aaf70dec3a4743328751cd8ce8bd0beb7876206a1334d"
    sha256 sonoma:         "f11f80c329be78596f4bdea807adeca58748d3e99250280795ff42be9df1f85b"
    sha256 ventura:        "1d679cab53f2261f4d9ada0fd34801252b1bf08a7e9607a4fe937a76908bfb15"
    sha256 monterey:       "d68b9cd9998a16d55176b91ee7ec7d8e07e0965f11d73266639956d737681040"
    sha256 x86_64_linux:   "efbba9ad0af114e2ba0726b8565e7bcf3d71690b7c3c0cd641a5a1cdf44bdba1"
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
