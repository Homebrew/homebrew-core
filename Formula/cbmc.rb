class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.41.0",
      revision: "a76195a1437e83bdfec3df46aa738ddde4d86ad2"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b198cba5908c488ade5ff9195b98200f9503e2e61715c89249bdd92da1418f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7b34251c299ba2db41817799a5ac29766e293daf658125ec32665eedf7f602e"
    sha256 cellar: :any_skip_relocation, catalina:      "fbfcc180174949e997431a30433c9a33f54fa77ddb5d906f7e91ddf0a588a018"
    sha256 cellar: :any_skip_relocation, mojave:        "1ea108121e19368873427775046d07aabbf4128c255e68f887d025c8ec6e77aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca29fb32732cf22225ae7aec43378da978149a459b33af976fb7b9d847d816c8"
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
