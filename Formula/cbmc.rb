class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.39.3",
      revision: "98bbe743d42d7a890647cb563abb66c5e9b7a3b1"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9dc4a17a664f98a9edb4049a95bb5a3f83c192730641d83bab45bfe1abb66892"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b99034e11d1c03a48e841c4b588e3c566f2e3d77791e141bb4978ed50abe0bf"
    sha256 cellar: :any_skip_relocation, catalina:      "2a292ac1faef8a7960a9e900e74a998e236f822af829f40c5ce7863460badf17"
    sha256 cellar: :any_skip_relocation, mojave:        "1eaaeb27c0c1f3fc4557c5e93eeaae2b3315bf2daa83e850e9a553e6d585499f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0e288cd3e9eb8aba940663b22283f224a814bb21b8ca81e569f5a15a07a66fd"
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
