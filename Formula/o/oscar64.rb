class Oscar64 < Formula
  desc "C/C++ cross-compiler, assembler, and runtime for Commodore 64 and 6502"
  homepage "https://github.com/drmortalwombat/oscar64"
  url "https://github.com/drmortalwombat/oscar64/archive/refs/tags/v1.32.273.tar.gz"
  sha256 "39eb90385a6beb6cb6e4e08ce53b36e70115dcca7c42941afbe3d4102ae98731"
  license "GPL-3.0-only"

  bottle do
    manifest_sha256 "248fc21c92d65344456d58f9f9bb523b396644aa43ffbd7147329b96ae325215"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "effaa36cb9a1fb43b805aab642750cd39d8ad57a3e8af2d3887e40692e50e634"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58a9616ca44ab74c0ac1a31f0666328193c92c2ed7580ee7bcacb992c36c3648"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55dcde508a9f5ef2f7774bace7d0192b536a14c1175dbabe4b8330b53f9500f5"
    sha256 cellar: :any,                 arm64_linux:       "2ba571b2c0863be89a5767595d164a793f30fb2c50dab0455f6a1f52e6ba1820"
    sha256 cellar: :any,                 x86_64_linux:      "7df3a884bc60c08a0b2cce1e5528996a1341fe26d59913308715bce3b8bcaa97"
  end

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
