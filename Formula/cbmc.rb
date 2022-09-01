class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.65.0",
      revision: "4e907dd68fc11b189b916e2736a5b3ded54d4c86"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa45b1b6fd967470203e4ad48d5e0376b03dc8919a40cb64f973be0cf2a8637f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16da0411930482eb1f7708f5416c880fd4d21a3e3661c1e158366e190b7965b3"
    sha256 cellar: :any_skip_relocation, monterey:       "d9a7d588bfe48b9b40db1b33f758f4b338bc91745debb86d78b24a4faeeec783"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5b868cfb23abd88011f8cc27a7aaa6ef9ba4a680846bf75dda279ed81304af8"
    sha256 cellar: :any_skip_relocation, catalina:       "5d889ce46cfe561a94242a952818eec32b3781fe196ec49b24a4d100dc40ad9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb0a0f21274196c40177da3b44a9518646c6f388dec8b84cf4da26239b7d04c"
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
