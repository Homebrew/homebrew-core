class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.95.1",
      revision: "731338d5d82ac86fc447015e0bd24cdf7a74c442"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a93a74b6ceacd62465a7c0c27a8451c775e8a69923a2b9388aaa0a51257b249"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c625b851133a25efc6d180cee609e29eaf85984f831f97034906487fa6c937ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "512b4480b1068442f73548499c5ba0f58c3db012dffda2a72a7f3a3ac57f83d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba108b3ea344f31e8a5b78080be1987f9bc19af1abaf1818d5ae5fa82f912e58"
    sha256 cellar: :any_skip_relocation, ventura:        "bc1e610ac17d864e3a400638bed661252ac2f027bb7b29e25950ee10571dcee0"
    sha256 cellar: :any_skip_relocation, monterey:       "2a2ca2db14350b20b4eaa012eda5cc147abc6f6253833bd030a202658ffea7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635f7f7b776288dbec70f66b3665393a5fe03e5ea8bf0ddeb372dfff25f1d6f2"
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
