class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.52.0",
      revision: "bd992a25e7643f7990389f6893764e177c41aa3d"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec58188390134b8c27e5c6d024a9dab0fbd19258b64ee70fc36c49b697e55ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9d18e99e474e3eb5eb167be6700026692b6e8e76cb691153dd6aa84fda16c29"
    sha256 cellar: :any_skip_relocation, monterey:       "f66c8009a0d7a58ec0bfe3deec916c2a007025eab79e3949b4128ba1a93bdb75"
    sha256 cellar: :any_skip_relocation, big_sur:        "4295a787932e5401e1c43617f729e0e8bf87773f774774d6cbe7991f0d4060b1"
    sha256 cellar: :any_skip_relocation, catalina:       "776ee5af39afe443ce8d559f4908a49190d1d8bb780bbcb32170094f095471c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db03fffbd36a1445160bf840d2f19703f99145ecc7467e0f1d91790adb0e0866"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

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
