class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.75.0",
      revision: "db721b26a41348f22e9d79f363216054264e6d8d"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9f9de6b5cc8d2a63b28230d266a4d7620c047e187384a1b678be8f90ccc2721"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "451663e8c3411c96d4ccc95d2b19123add50892471ccf0b56a20586299367706"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c386b22b376e991cc3458a322f364a007078eaabe0b155c0323aea5ed01382b7"
    sha256 cellar: :any_skip_relocation, ventura:        "107bb33a12f3a14b4630ef3f2db131a54a77116c70f37186ce7eb8b5fa164c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5278af1e48ca3fc5fb619bc3b4bd8ace7551748f81456ea4d56396b28cc813"
    sha256 cellar: :any_skip_relocation, big_sur:        "b04839df5d72825b432962ab1c44f334cbe3c36b0c5cd0b953e303fe355ff49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fc26b4281745cac4fda6bd0817f1a12bf7bcd4fe185866fdd693e49f70a98a"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build
  depends_on "rust" => :build

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
