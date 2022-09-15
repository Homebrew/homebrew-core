class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.65.1",
      revision: "f680e0fa669b248db6e103dbafed67a2d3f72807"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4358c25a54fde74368dd53dcc14606e56fc67f89b8bb0fb1187bf09d8299c269"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6237be33433dc9561bd63d09ee5577d4c00ca012addf7244484f8d21c1f8030"
    sha256 cellar: :any_skip_relocation, monterey:       "538a512d8a0d10181b7957a20a31e1f5ad937c9902378d1b6d1f4f4a94420ec1"
    sha256 cellar: :any_skip_relocation, big_sur:        "778a75fe578a0201c1b67a70d700839a6b0d2f13c0671b392719cc8a26cae075"
    sha256 cellar: :any_skip_relocation, catalina:       "e3ad350619e7cdd6b878452dc71de8d685562fc1b7b670efb7d03e2c02ab5665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d95e77a6c166238e9f4e27f87a68b9739dc259a12f42368bba4d07429ccde4"
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
