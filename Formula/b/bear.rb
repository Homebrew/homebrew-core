class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.4.tar.gz"
  sha256 "a1105023795b3e1b9abc29c088cdec5464cc9f3b640b5078dc90a505498da5ff"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "bb4befd4df6dc4ad4d819f69cc85bb6a96706843e39cb7dc4147355d912bcf88"
    sha256 arm64_ventura:  "9ffad55aa43465cba0dac9a568920d0120070168f46e348044edb5a896aac231"
    sha256 arm64_monterey: "f00813d3480fb5521570a3197936b4890656be015792e28558d11cc62dc67110"
    sha256 sonoma:         "0e14c26a251ec340ab8b4bc38f4311d0408640f09a281b3262ad75f1cdec3e13"
    sha256 ventura:        "8a55ced3f5ec87cbc23dfd769077db8eb4b78d5c5bcbabbe71de6e9966995a9f"
    sha256 monterey:       "94da31ef2bb39d347f181d86385032b7168d80a4c33afe5844729541e9a7439d"
    sha256 x86_64_linux:   "77e181d744a4f6f0714747a8ef174cf4be09b2df001eb8fbf0278f0cfa18824c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
