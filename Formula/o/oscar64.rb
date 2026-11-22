class Oscar64 < Formula
  desc "C/C++ cross-compiler, assembler, and runtime for Commodore 64 and 6502"
  homepage "https://github.com/drmortalwombat/oscar64"
  url "https://github.com/drmortalwombat/oscar64/archive/refs/tags/v1.32.273.tar.gz"
  sha256 "39eb90385a6beb6cb6e4e08ce53b36e70115dcca7c42941afbe3d4102ae98731"
  license "GPL-3.0-only"

  depends_on "cmake" => :build

  on_linux do
    depends_on "libx11"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (include/"oscar64").install "include/new"
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main(void) {
        printf("HELLO C64\\n");
        return 0;
      }
    C

    system bin/"oscar64", "hello.c", "-o=hello.prg"
    assert_path_exists testpath/"hello.prg"
    refute_predicate (testpath/"hello.prg").size, :zero?
  end
end
