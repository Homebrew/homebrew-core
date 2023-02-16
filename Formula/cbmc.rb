class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.77.0",
      revision: "e1e7dc7426168bca56ee92bf1513053c7db99317"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7940d6997491f1014be89520ff11bc1f27eedd80bad5da73e30f01913cb678df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0efc1b9f655897b47d14ed3bb3bdef6b5c802963bdde11053cdc77f5665af072"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7e7eeee02ca895303e8acb51146a10ad0289edf5a2f4eb1cbf1b59cfe20f8fd"
    sha256 cellar: :any_skip_relocation, ventura:        "4e5db92d087355ab06e7c21a88030ceb852b36b7fd7634f4ab19206636c890b3"
    sha256 cellar: :any_skip_relocation, monterey:       "689c3518f56c818d89782f9baa14c4d064777aeb5569e8847e19e647a436ab7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8a495bbe5ce51a3ceaad615c0c8e342c30d87f96a65792daa9dc16e818d4066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca8842103d2c4643d1a2560e54973ec5cedbc4dd3bd3c3e59fd73810b48c532"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # lib contains only `jar` files
    libexec.install lib
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
