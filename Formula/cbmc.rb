class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.68.0",
      revision: "52e004c30dfc8a07bb6154dac182911b573748d7"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36aa8a852ef5bf4f224279fccae580fa6630804f42820ff57c8dca2a3da821fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39c86a4c4dd2314f78f968b927baf0b2902482026f90bba516d43013e0b381b1"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a3cc5071d242713a16b46705d2883aa793f4abc0d7a35a3b7eec6d356411f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fadaa605a64d1395e1711d41dd97fc1b49e628d710ffb95bfea32353d3bd6b9c"
    sha256 cellar: :any_skip_relocation, catalina:       "14d7a244fd456d1c378c481eaf87f13b9efe28498ea8ef4c67d79c70fc385369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc93a3b4adcb04c78d6a3d68fb0a4bf251840f199b5bb63647aa4d001bc6da3a"
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
