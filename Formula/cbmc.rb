class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.81.0",
      revision: "53b50bc5150e428dac0849ddac877738b80397c2"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dce28969b68c508bf8e5dfe11f004a3b6c4e7172f5d3c0dde7e5324cb3d42485"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a26d3516389e51f62dcc6054ae7c446f56717b9c727d9963709ae3a82934ecf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94ce2b1975a835afabde30c456cf7c792c3a38bb3a0a801779bb9674cac92029"
    sha256 cellar: :any_skip_relocation, ventura:        "7de943722c4c32437d6c8b8993038e4f41fc9578b163c66de0be4bd4bc707abe"
    sha256 cellar: :any_skip_relocation, monterey:       "2edf46de38d41e5e269e2c6c1648c4869966b2fd246f694caca9f713a9130e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "398f38054b67d80f7a352b4ccfc679e2f758cb8988929fb75b25c58914741219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa1286279a9f38cc11839fd3884efdca0603bb60e5227125b47a4cdb81e80db"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-Dsat_impl=minisat2;cadical", *std_cmake_args
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
