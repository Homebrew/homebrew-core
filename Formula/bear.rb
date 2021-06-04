class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.12.tar.gz"
  sha256 "a057b8b7795ff32d4f68241ad734d4c6e1327b70a105b93a838dd442a1582c1d"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "7696bcb190b151eb15331bd405508917a7df1f5ebea32eb5dfd50ba545a4e3fc"
    sha256 big_sur:       "31105f0895a316ef201af65656c0031caf2ddd27de35b262809a0e77d0095e41"
    sha256 catalina:      "f7e7bac55d31364ce2dcf73c08d116569d7967c4dfdd4c32f488c69779bd1193"
    sha256 mojave:        "59295fb4890c4fd8eecf54533cac791b5277c39d1b20f7cac3a154f36d64e3a8"
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
