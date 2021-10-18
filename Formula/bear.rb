class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.16.tar.gz"
  sha256 "877ee5e89e8445f74df95f2f3896597f04b86a4e5d0dbbca07ac71027dcb362d"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "57d6a6be38019618cc1c2bb9c98c52f51189762b909b8c278db2d931db0c953b"
    sha256 big_sur:       "f8a981aee65594df2e6d8b9790845ac3a389e444478213ef5ab544f87dfab90f"
    sha256 catalina:      "9808e026ffcf1729453daa60d9322743519e46441a3e70f2bf87aebe48543af4"
    sha256 mojave:        "012e2135ba1762533feb1c8711a6fc1894a1a4842e87ba3266810c389e8965b3"
    sha256 x86_64_linux:  "12140ab2033de889a67a90bfa1a6a284a1f7973f1a55223c135c6c237f42cb0f"
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
