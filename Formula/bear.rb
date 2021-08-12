class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.13.tar.gz"
  sha256 "b57d9b139acbbad6439f5b1133266fa5afc5eb095a61cfa07cd9e8941943ae22"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "7278648a98c987fb2ce8ee02b462249f85ece5c9ef3ef7384734e48b393d7e0e"
    sha256 big_sur:       "c53ddfaa09f58d4790b99bc667a47834d036739a53b7649615593992491e85b5"
    sha256 catalina:      "6ee1fc96055be042b50ac15488c73788850491b19488721d9bf050f0f1140711"
    sha256 mojave:        "825035cc614cf0dc110144d4854d98b30875acc99944ec8c8d99cba377f70e1d"
    sha256 x86_64_linux:  "259ebc26699a118f3caf37e6f42c9b0bfa2038b00e1f4c9b3537d2e69dbd4758"
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
