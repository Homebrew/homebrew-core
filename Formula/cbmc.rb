class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.48.0",
      revision: "b79bd515ca20259287602abd68d5a32c276dbdd9"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36a82b0194248cb80fcf5b02cdf45f12260c56d6f0033c9dd69b5bba085a669a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b56a555b8cefd0c7ba7a6a3b1fbf39b18e917bda162e37c86b9c3a1c941f7676"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd7f43043a85616315e99a08a9757302e86c42c15a86f6e595e49d8942eacf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "24a9a03647249e2993350a3db1a341dbc51e73e358b7dca63d4ea26015a9d3e6"
    sha256 cellar: :any_skip_relocation, catalina:       "a27d32c32bc796df285807c131950557a57cf6ba21c97870e49fe6c5bc151ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ed2013496a8cbc41673174fca037a56585e86cefb14c3289e32c7c1e25da24"
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
