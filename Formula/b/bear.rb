class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "e088048dbff80e8e6902602d782173907a8d9b38194e46578831fb25c82ac61a"
    sha256 arm64_ventura:  "1ffbca354254be3710fddd12ff57d102fba1dc5208fa8e68cfc86b097f00b076"
    sha256 arm64_monterey: "7390f006f2c6fc1c4b17d2ac23f212bf2834aaa5642db1507bbe1c7b594358de"
    sha256 arm64_big_sur:  "7be33d01dbc1aca16fd042f0ba27c4341942c04dcb5c86b63540fd8d675dbd48"
    sha256 sonoma:         "229bb404da48b90392ae331c4f1926182ad9f5642f29ae28479e55fbac316cf2"
    sha256 ventura:        "4e193c0be393d197912217c5f9a878c41bef079cec077bd4230f4cbfdbb2b160"
    sha256 monterey:       "dda9575d8fd606f4dba4343c77ee6a24b94534e98e83cd87e4d5d7582d36c6cf"
    sha256 big_sur:        "ccc4f07e1cf35dd2089f2134eaa41f21a07871bebae5ae2da8855ea8c20fa937"
    sha256 x86_64_linux:   "eb41bd2b354bfb32f48cbddb4d7fa0467e935788d4806e7b5158e90f48325e26"
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
