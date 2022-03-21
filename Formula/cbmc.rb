class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.53.1",
      revision: "4987df3c306b6ea9e26933aa240fbc8a62fbbc7a"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "534bfb10b070e7db77cf4c97479a290266aea6b83f78dd12833dd41769467fd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc8c5bfd4d16407b27ae76bbe04d6f106be3b0a219871979899be4b2f23485ec"
    sha256 cellar: :any_skip_relocation, monterey:       "33019d6f6af1e6a88f4f851482190ea99d3b77493fdc30b3f6a94e64e1aca705"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1cba7a64d932bf91443a43af6ddacac9e7682cda7aba92bcbcff74ceaab209a"
    sha256 cellar: :any_skip_relocation, catalina:       "f5e8da50a8250e1d7c8976f5073691e9e174dcff2dc1e28aa433d100f7cf7ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "854c68d21ac094cd577a4f7d0995721c55c94c9e1cdbfeed2046cb6478c3a711"
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
