class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.69.1",
      revision: "74b23a3812eaf57799ba910cd1bdc65d41185e34"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be6c2e89c736a9ea4191bc4bb020fa89f4e27e440add2f5b27172b1a8ee5cd06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1988033324b0df307f9710a48aadf6d8f2e05ee1030e67851d329075d8ea6922"
    sha256 cellar: :any_skip_relocation, monterey:       "0071c79035188c52edb772557b009938bc1c1d3af5681e7c5652d1084708da59"
    sha256 cellar: :any_skip_relocation, big_sur:        "f58f1bb3b7693720add692dd28339edb775b9bac976053712789497138f8a25d"
    sha256 cellar: :any_skip_relocation, catalina:       "675f1aa576e701b6e5cdf1cbc33a842c29d1ea9cad98e206209d040082a2ea34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe47f520e48c68c9b28cfcc883af42a1148c318c4cd622570f207e91ffc40bf"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

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
