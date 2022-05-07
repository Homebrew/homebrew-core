class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.19.tar.gz"
  sha256 "2fcfe2c6e029182cfc54ed26b3505c0ef12b0f43df03fb587f335afdc2ca9431"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "dc55ea7db43214016b5c13343bfa50b545aad5bbecf744e7a6580f469353c22e"
    sha256 arm64_big_sur:  "3e5dbf0711e76839bb439d5d36e34b88d13ea1432975713e636e838d97433444"
    sha256 monterey:       "d38d1a2909c2ef87a0ccf3f48daca1d598ed4f3eab19e796221d934da7551786"
    sha256 big_sur:        "a79da3015aab95be863c3ed9f956ce94037ba753111e25477caf81f9024bc714"
    sha256 catalina:       "6c4c569f1da20bd28ac186b76ae5e770d0c64c32f1a6990f619c129bdae0f3cf"
    sha256 x86_64_linux:   "02e69db113863596fcc59484b180cec53173220abebc5921d9a2f471ce3d5838"
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
