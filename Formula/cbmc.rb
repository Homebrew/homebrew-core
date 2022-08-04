class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.63.0",
      revision: "3edffedf0781d58eecd33d161084c0f532de6e4b"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a786a1eaefab7a9b0331a27a58287dd0fdcc04249738dc578e9cc547151db41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e8056ffd13c5919664209058ad2507783ff36d179f5b89aa7f3f0672604a654"
    sha256 cellar: :any_skip_relocation, monterey:       "044e86d04e53ce090d3d9c9142b1cb5bfe6891f6f2294690416a169b2da22aa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "28107ea839525f15986c3c69cfe8fbeb481f93298d6d25e9825458370d38924e"
    sha256 cellar: :any_skip_relocation, catalina:       "098319a8cbb6a295d8a6db00e2ac3f4957828dedb4bdb737025c72055eea865e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd6ac1f0e18386248a6a2621fafb7bf6bceb26492f1c9586a258b565e3ff20b7"
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
