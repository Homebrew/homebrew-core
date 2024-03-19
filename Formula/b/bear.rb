class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 15
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "80bba10fe74387d0fd7ae4c815d12088c0a3a122e973175a59a7a44203aae16a"
    sha256 arm64_ventura:  "9da46155efff8d49dc37272d7d03e423010b841165bfc8d575661922ba8aca42"
    sha256 arm64_monterey: "7a6a9a545a8bbd621370130b86adbf3eeb49cb2dc2e52b4330d8e937cf9fbbf7"
    sha256 sonoma:         "b13a6fcd2eb5c929b761521313d4315d483196ec5fac0421fc6e1b664f2dbf35"
    sha256 ventura:        "2ac8ec0d459360667c56f448500acfaa83f05a7b096237625853838dc49ee17f"
    sha256 monterey:       "46cdc42372f0afc5470c385c2a5b1860fd609144818302cd04bbc7f86baa6239"
    sha256 x86_64_linux:   "0ad2a4061ca6fd7cfb99d63ea1eba9a17abd32155eb69d7931c3d5be3f0ac9ab"
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
