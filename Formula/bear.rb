class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.19.tar.gz"
  sha256 "2fcfe2c6e029182cfc54ed26b3505c0ef12b0f43df03fb587f335afdc2ca9431"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "49e7ef8728cbcf56029eccd40d779a2dec5b2b3a761156395206eef8e000329a"
    sha256 arm64_big_sur:  "093dadc469fda4609d00bcab619e2795c59d144c334e751a7e551b9f7e7464e2"
    sha256 monterey:       "6c76a1a1dfc3005709aa291e675c42565e7ac0ec98223de877a058dc0582e058"
    sha256 big_sur:        "6e2c1bf921808ea9bbb4291b9545b5a4a1a6fd888bb8fb622540055dcb24bfb1"
    sha256 catalina:       "e4f97abc509ea93158e59fcdd507db5142b6fd699a5d2071302c83904fb3444b"
    sha256 x86_64_linux:   "561f5c6110e42442b06b6af92ed6c7d50c77e74cfbd5f8e83248224a4ab8e763"
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
