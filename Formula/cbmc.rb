class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.59.0",
      revision: "ae93642e6a329882f7a7066b824cc0946c56b127"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c28cc32b66a2c5e827c73d3e9a327d5ff928301083130db564dc698dcadeeb4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b425c135cd7074bea35f076e831cd3431c56f4de285d4f10572e5119fe5c0709"
    sha256 cellar: :any_skip_relocation, monterey:       "64d75c8b12757c41fb61be6ccecab595c7be4ebdd4027ec193da67b78cf1adb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6c8201839d42c6b97ee406c43372d1df60273603b62aa367a21a0bfc08d8765"
    sha256 cellar: :any_skip_relocation, catalina:       "c3d6c6c988e1cfd37cdd4519139e30d5af3877ce2e7c385c20718a58ddd71c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00b8498d131fb0f33f5dc46cd93be4bda62a19268d7f5ebe1a718e0acc40919c"
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
