class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.6.tar.gz"
  sha256 "99cd891eec6e89b734d7cafe0e623dd8c2f27d8cbf3ee9bc4807e69e5c8fb55c"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "644aa1963bd89f2f3a689f7c5e1ceea8add6ac5fb2869f342136a3e0bd6fd23b"
    sha256 arm64_sonoma:  "7e6e4d75c2cb2cf539412eedd19323dc620dce18629f3dfc51b7176ea51dc527"
    sha256 arm64_ventura: "7492b5c1ddd390ce27436da379949ad36fcb3bca63b00e6e03218b06f78b2e64"
    sha256 sonoma:        "fe5ae0f4ae90f7e246d77afb0bb42c838db6c3aef8588e0c74a75cc142d35ad9"
    sha256 ventura:       "ffcffed6e5f0fba9d0726badbdbaf8f4c5d16cc1a85fcd08561fba053a1ea807"
    sha256 arm64_linux:   "deba5bc3b42e241fe16a5bb5edfbb7fecc11339d2914e401d479c8b69187b322"
    sha256 x86_64_linux:  "99cc7ce998a2bf3839c672c92da5c1caf9725a137829d7cadca3ea4af34f0458"
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
