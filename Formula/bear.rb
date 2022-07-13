class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.19.tar.gz"
  sha256 "2fcfe2c6e029182cfc54ed26b3505c0ef12b0f43df03fb587f335afdc2ca9431"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "250481294463503dc2fbc9594bfc5d93b4f6bc3a58661e77b41bfd2fa4843f08"
    sha256 arm64_big_sur:  "f20ac1cb9818bbb141162b3bc4af6ffdc42855805be48b51f46f646cb6218dae"
    sha256 monterey:       "8331f1c657ecf1a8e8c6325bea7a6737e57f5c165fab4d5b9aa4688a0c87f886"
    sha256 big_sur:        "954e98dec61b42f5478b98429f93308449d07a64dcf483736b23142f8422cf24"
    sha256 catalina:       "188a0986aaaaf9a474a09ced1583843fef08ecfd906e8f8504ad7f0825d3702d"
    sha256 x86_64_linux:   "b91c9ba37be9a1228c8ee374313f1215a4b14c1b71661aa77edf183a2f4ae495"
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
