class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.75.0",
      revision: "db721b26a41348f22e9d79f363216054264e6d8d"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e0e9a102db7d413672452112cc069055355efb0043e74ae8de983a65feecafa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cb598afd4bf1028290c3f1fd3c5454bb2355fb33a9b190b67d0eee154f5b6c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e420735892d672bda7add8b5400ee83ed31352e3e0fbefa7afe2e5cb16fd689f"
    sha256 cellar: :any_skip_relocation, ventura:        "e8cf9e9830e1d6d209b9ffba62257a10e14ced593a40fab7625001bc0484e97f"
    sha256 cellar: :any_skip_relocation, monterey:       "7a3ac4570b1e0bbc6c77fff0c86296c20514985954da0e67c0f510ed8e6987f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc30260d84820b1c14589d7fe29404bf59c061b8d98ffd7117b573ab9f73d474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a44c0392bf0c6339cc13184891d48a066b5a8ae4c5fd05a17d73a2ea8af84c"
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
