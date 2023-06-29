class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.86.0",
      revision: "892c792b43025feac551a95223b30f06b2c6a6dc"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a2331ef72053d7f4839840950f8d97b5af6307dc089a54423f55abcf0f5023"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b2b4bad4e1202c40c027ed30439dfa2f7c15afc93482d32a81f1da07df52b40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9edef4377c648720eb14db576714861260115d8413c5521ce9bd1abf9c4bad93"
    sha256 cellar: :any_skip_relocation, ventura:        "934cbe91c17ed3131167783635995c958b0ffc1829ec68a78e82ec0d0e710f44"
    sha256 cellar: :any_skip_relocation, monterey:       "7b5e30e91c763fd78b85dba4149d1a0f2f623d22b39da32d6048ffba18caa4bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "f65ed6024c31a5970da2698886bb73a489310a27fff41578b7d613f4dc38654c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53021f8631817872af898ed84b9e43a512197e02120cd0f3a5dc204a5b203966"
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
