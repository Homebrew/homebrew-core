class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.18.tar.gz"
  sha256 "ae94047c79b4f48462b66981f66a67b6a833d75d4c40e7afead491b1865f1142"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "ccf78dbb909d60946f3f338fe6f176245f0be99e13134dbdf2d92f95cde0fad0"
    sha256 arm64_big_sur:  "28107af41fe66bf9bcbde87b0023f5e0fdebe51801e16bf02ddd1d571b34e183"
    sha256 monterey:       "14b06f7e5caf574e89e802df1ae45566c6f21707e0d992bbeef358ab510ed17c"
    sha256 big_sur:        "9cb996e00e55ee16656371e4a39f94faae95474b014c6978ec479c8570657180"
    sha256 catalina:       "eac61d41c1cc6281de935600b2919dd08741db825727e31edfe440fb8f126975"
    sha256 x86_64_linux:   "fc611912c7068a7d53401ebdccdb6585a9dafb9f16ad3ec9cdf18855c1ed171f"
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
