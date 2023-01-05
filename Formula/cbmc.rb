class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.74.0",
      revision: "2601e72f2dad8460676d94c45c11a8a3e0824729"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6dda63babc638d57f42c918b651bed3f0b93cbe10d524c020237475d074ad2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f4c8bf06c348d68da7a29135ea4380a68382e2d4ae82302cfd68c0b00249409"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8042887378b0855e1452daef423542f58aff6dd4ca271c5a876818c1a791e1a6"
    sha256 cellar: :any_skip_relocation, ventura:        "2e0951f135758b3a7fdbf303df4e43d3509c3aa3838971d134ab79fa625fb911"
    sha256 cellar: :any_skip_relocation, monterey:       "f9020e3f5a2578accf4edc04ef64b906ab06997b9d6ba8669c8127319879aede"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa4d150adedd5f7dc8ce77a47d56343b6d818604b25ae0bf5f1d75dd62d5cfee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e961c36641de597b8ee5cdadb4db60c88d61980ee45e6ed43fc65b72efd264"
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
