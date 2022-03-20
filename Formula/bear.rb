class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.19.tar.gz"
  sha256 "2fcfe2c6e029182cfc54ed26b3505c0ef12b0f43df03fb587f335afdc2ca9431"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "77e608020eb342f5a53a268cb90fe8c957937da64ff4e9b792a3925c5945f730"
    sha256 arm64_big_sur:  "3b6549dcc5b7003ccf097b576cfd08c6f7b03ca72e6f0d143e2819961e1ec5fb"
    sha256 monterey:       "5ed0d27f619a2e5bd3bc92349d232e30a21c09832fdc16235d57fe1ccaf55dd3"
    sha256 big_sur:        "4bc969951fb96b6b2deacd51145a5f9a471a2e8d54907b4496534c9dcfad9271"
    sha256 catalina:       "485e6502bad2d8eb11b580d24dd1fc3d3fad51310573547bb8fdb1ea77a8b853"
    sha256 x86_64_linux:   "8dedda456716ff819414d86fc6e1c46aee9689303ad84f0ed94cdbd762d43c8c"
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
