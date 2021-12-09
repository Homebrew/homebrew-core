class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.17.tar.gz"
  sha256 "107f94e045d930e88f5f5b4b484c8df1bf4834722943525765c271e0b5b34b78"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "785496b8cab60394408103af6756710bbb343dc28b32445cc135b28d619902d4"
    sha256 arm64_big_sur:  "fd4e3b9051f5aa604266902d875ff7797ac9cd88663a571264fbfa41ecc72033"
    sha256 monterey:       "3ac669791f381790a92cec62cffd2a7ceebed6a8f435f65ae649305fc491486f"
    sha256 big_sur:        "aeab1fc4206a7112b4ebecc3cb9de4eb64a8fec3e448b3693cf5442e9b484a7f"
    sha256 catalina:       "8c069138e3bd6a641f0aa669084b4d7f7edf0ae6ca6ce93f6a0bb0cdc518874f"
    sha256 x86_64_linux:   "b666bb64cf3ef5dae4929a7c3b434a72ead10a9f421f133f2f79dda05d8819cb"
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
