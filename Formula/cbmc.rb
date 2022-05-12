class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.57.0",
      revision: "58d64d853a236a3f9eca46c1b60ed0cf9324fbfd"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85619ee760a4ab965abc0e47fc95ac45ce4b1295aedb0af4c417b37911937b2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51ac275382706629596c1baae97b3d4b72c94936ad05ae395b9dc52c3bf62c41"
    sha256 cellar: :any_skip_relocation, monterey:       "ccea3e2d18345638e55b55001e0d0a2137767e162f5a95be10ff7c0e671b4be2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b487ee987585d20bd84094792813da20fa40fff1961aece0ce08f2f7bded5468"
    sha256 cellar: :any_skip_relocation, catalina:       "fbcd8d72bda066b86f3839bd6bb82394f99fb1aff7bc05aeb5b1aaa1a9ba7663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730cef671dfb7fd549a86cf7266d075b66fc2417f702c553f5fe7c8a60a5b8eb"
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
