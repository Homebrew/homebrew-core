class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.70.0",
      revision: "266b63313799a63d3348c086b7a4b42cc3fc251c"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "047d92ff1a1fe325c38cbb7d6a2dfeaf349af418cd0f49658ce1d10865b39740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c02c4acc79bc960fb1111a1024a9d3b1449da9fe691dd501cc6e87068f7e6b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a54a7fa2bbf4fda62a844bd489c00bee62ad0644fd3b6938ba6abbfc7133a4b8"
    sha256 cellar: :any_skip_relocation, ventura:        "053b63d3de90eb42ef2d2d383c12a33c8f9f188dfc8ee2e802de1db2a10b1ce4"
    sha256 cellar: :any_skip_relocation, monterey:       "82cc2d2c20431445cfb13c91dd19b50d67f3a4b88b4dc4dc2ce2729b6b8ae1c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc9af5a246818a43f62f86f42b7ef0edbae00ae897a84a76c963b934256f8158"
    sha256 cellar: :any_skip_relocation, catalina:       "0cfcacbe717fbb53aa1dd0eb690b4abc57df150cb4028f1b15b168f265958b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3b2e74e895379ed7026eb671886c0c28f10f55578c9bab2fae89cda0528b3a1"
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
