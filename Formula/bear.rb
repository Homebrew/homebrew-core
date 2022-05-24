class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.19.tar.gz"
  sha256 "2fcfe2c6e029182cfc54ed26b3505c0ef12b0f43df03fb587f335afdc2ca9431"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "266042902f03ce27b36921ff9b558b3b894b32cee3e6cabe3d7c3f2d5c867add"
    sha256 arm64_big_sur:  "fb43e08998008413b01a5326ef4cd918a3e3afcf23a28c50c41dda74f07a0c1f"
    sha256 monterey:       "557d16d8427721118fb594fce2abda828ad97bcb4223108b4f4202a8eb397a39"
    sha256 big_sur:        "14d47bff99c2319cac532f38e141e82c998deea0746965f18cdf0ada09bae6e5"
    sha256 catalina:       "adc831813186d909afb02bc28f273692c3aec99354689f500c26df795970b787"
    sha256 x86_64_linux:   "795b15c351033fab20a279c1903fe5e1b7a31fbc215a1d52fc3c63732a7c3d6b"
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
