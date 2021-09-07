class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.14.tar.gz"
  sha256 "aaf7c615b306bb39ffb2ba80f961784818f3d69c7f4cbffbeb04fc1b91bb6000"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "86bb1162dc90aac0ffd65f5fc1c85e1d62ec004bf3a901bed33cc32b89d87454"
    sha256 big_sur:       "e58705a9c3723629fded1756a20bdcfe34a3d45db8880c0f03afbdd8a1958e14"
    sha256 catalina:      "4d1332c1aa866cd17ff2cb201047b201ff3f110509566cdbfd01ca634b4c41a6"
    sha256 mojave:        "98e61b99eb53f789d1b20f0ef02c249cbce5806b7eb803e28a7d71d2dca78c00"
    sha256 x86_64_linux:  "c04061eab576069e9e4cbf525d2b0c00d0ad58eed96023a7becd1206f81120ad"
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
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

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
