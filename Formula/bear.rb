class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.1.1.tar.gz"
  sha256 "52f8ee68ee490e5f2714eebad9e1288e89c82b9fd7bf756f600cff03de63a119"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "8d32403c7ec2bfaff23cdfac9c4b34b36e5c5baff89f20fc562ae1b173d92b99"
    sha256 arm64_monterey: "c3a1714c349d9a097e462bd8db737dfeba6a9ad18136cffc33230ca644c95cf2"
    sha256 arm64_big_sur:  "270fd544f932e45fa55c48060a26df5daf28a7cd0a15ce0833de6ec0e7ea326c"
    sha256 ventura:        "a283132496c20cb71c1a932a1ce800092877b5a7ec6297558d28cae59efee363"
    sha256 monterey:       "f9e2052c70cb8dadd1655f776ee7e2dc0d76420605619f1bc270ef3b8e6ab657"
    sha256 big_sur:        "0e9dcfa3d21f35afbed8947cab18ac42f7c39fe12d82fe1250e8906e56759ff0"
    sha256 x86_64_linux:   "ebbe0f5d7fdebf05122945bece2351766a2031a16444e02422e01526c4281a28"
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
