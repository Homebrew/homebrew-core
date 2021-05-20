class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.11.tar.gz"
  sha256 "3f426b5b22cab1ed6146aaba1dd612cd387b7298915ca58a72386bc8c1c9d9da"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "c48f1cf92b8b1be6c433469d6de1fa27612cf4add52595835b90f2a45c490abc"
    sha256 big_sur:       "b43ce5dbd5fe126b521766d28ca3a3c94a73cb6dcd7e431abcbd34306dbbba32"
    sha256 catalina:      "d9e0aa335c566017d373d89d77c4d627c042245e21c9a751d2eeb9eb376eb735"
    sha256 mojave:        "b18f99eac9cf32923b286ce4d0b8ba4011f4fa1edcf6924c8d767f42e7f0af94"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "python@3.9"
  depends_on "spdlog"
  depends_on "sqlite"

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
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end

    args = std_cmake_args + %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "all"
      system "make", "install"
    end

    rewrite_shebang detected_python_shebang, bin/"bear"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system "#{bin}/bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
