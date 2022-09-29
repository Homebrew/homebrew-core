class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.67.0",
      revision: "e73fcbbabe46c7fa9c23f56fd527049c6356b8f1"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5aba8c8e8bc82b556cc3456c07f761808caa2b356ae4ad14e6c5e03c8aa02ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "551479bc988b89bf9b0de68b7ec9a0f7d1b13c5d238d357e787d06b1e5085e1c"
    sha256 cellar: :any_skip_relocation, monterey:       "1878512a2eda0421992fec6ef20c20fabf24d12111a10e5c133355508add2bc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c9de6d8f95e9c3e2a5df9025a6aba33b0c2dc9d78a17dfe7eace203613e68dd"
    sha256 cellar: :any_skip_relocation, catalina:       "a85ce39c82532da682825b8e6a92f4ec18b8957361c2c642c4df915f2a95b42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9081d9bac9f3dcdf63efab17f6fd035759ac22aa9d69cde81ad697be232c9a44"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

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
