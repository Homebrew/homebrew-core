class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.58.1",
      revision: "0de701ced2586caf9984583d4ba9381711d45201"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d39e22937031c1c1fd8ba2e1b7a70c4d48372dfa89091f726b3a032ed5e34eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a49be8fcf10dfb90eb2a68cf0bd033849671f4857141cb5a86860210ec9be78"
    sha256 cellar: :any_skip_relocation, monterey:       "ac0b7a7b3d91eb0bd346a62d0979b5262bdff28e4a5d0228eabc9716eaaa2b03"
    sha256 cellar: :any_skip_relocation, big_sur:        "e39a8acc28fea60c577b9b23f564f72008cd35434c2900aca2a58272310cd38e"
    sha256 cellar: :any_skip_relocation, catalina:       "cba643fed513f5f12437c71ba0f2a610e59156394c6f77b60fe08575140bcaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d13925563fcec5269f86b47b6eca969fc4ba95ce6b98e95fac55d81cd15f94"
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
