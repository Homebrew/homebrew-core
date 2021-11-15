class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.17.tar.gz"
  sha256 "107f94e045d930e88f5f5b4b484c8df1bf4834722943525765c271e0b5b34b78"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a7ded40583edfd8ea52d61bd821359776a8de125d826d33e9e83d32a10db8f09"
    sha256 arm64_big_sur:  "720582c6ee523fc17f690db866659829128ebc24d20717801991390b56e8f993"
    sha256 monterey:       "b745a7b686b0b75190cf43c40016c633fd5d18344354a112697136f682858035"
    sha256 big_sur:        "a4e4715478a6cc09a680009fceb401a0e6686ffb864aee6aebfc3f51140a233e"
    sha256 catalina:       "267487257cbd591eedabf247f1953e447959f7f42b3ded0d5b5d596e6eb26772"
    sha256 x86_64_linux:   "f0f4c2fa516db884046ac36061f4f894c6a099f973b93109f657045b4dd16492"
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
