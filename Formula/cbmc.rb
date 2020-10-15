class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.16.0",
      revision: "4451960f8b8172bc91bc8f1cc84ad78e05b12536"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "522eca83aab9f5be593aee42c560fcbd00a0c08d414ef4b934b0eb13e46d924b" => :catalina
    sha256 "a8d71aac43d2777c6f4b09abf24f8bddefa39aeb0fe00fe6e10eace1830e7b19" => :mojave
    sha256 "9f37e32f681c707b041e7fdedb3aaf6d2fdf33101beade0080f8872f2d263f53" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      system "make", "install"
    end
  end

  test do
    # Find a pointer out of bounds error
    (testpath/"main.c").write <<~EOS
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    EOS
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}/cbmc --pointer-check main.c", 10)
  end
end
