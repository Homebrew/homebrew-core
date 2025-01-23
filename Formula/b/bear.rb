class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.5.tar.gz"
  sha256 "4ac7b041222dcfc7231c6570d5bd76c39eaeda7a075ee2385b84256e7d659733"
  license "GPL-3.0-or-later"
  revision 10
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "cb55b87fd4e6d1fb70ea33bd455b06c09c5360159051835fe913cb0eb80e67db"
    sha256 arm64_sonoma:  "860839939eb8953b4ece08866ef314be73e436c0f78e64a669a2e96d92af237b"
    sha256 arm64_ventura: "8be57ac03661f21b73a5dffd0d753587db7dc4f6702d9c22cd2a8876afe13edc"
    sha256 sonoma:        "265bdf22736195a409267f93f0b5d40e795c168e568f8f6dcdc9e6e139b70818"
    sha256 ventura:       "d85fbb07c3bead3bc7b253a9aa7141f7d536b34802c872fd1a07b391e4e0c570"
    sha256 x86_64_linux:  "16b1b67073ce34ada52f244081e2376086109ff2df3dfa36f10ea97ba547ceae"
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
