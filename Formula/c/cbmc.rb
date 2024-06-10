class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.95.1",
      revision: "731338d5d82ac86fc447015e0bd24cdf7a74c442"
  license "BSD-4-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "176b682268a962b7177ae2b19cffdbd17689d731a1f13f6762251ec9e1bda57c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4c24510b758c604c0fea80c400498f74ed606665c72614203a354deba1b8fab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0496f976a0002300be584cc24e4f6d873336719dddec34fd8cddb9d3b384b3c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "feecd518e6cff4086219c51cca9e1e5c2fdfb231d3da0ea5544c319aa472203b"
    sha256 cellar: :any_skip_relocation, ventura:        "8ecb77e007217f76396bc17440b965f4f69e5202ccb35851f46903e068afb58d"
    sha256 cellar: :any_skip_relocation, monterey:       "c6e0416b6abf6c9379e6902083ba475d4c698d6861a6b6555299916f8d8357fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb3dc3778bb81da39aa613e84278e9b33a798204d65c76a0eff91109dcb624a"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk@21" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    # Fixes: *** No rule to make target 'bin/goto-gcc',
    # needed by '/tmp/cbmc-20240525-215493-ru4krx/regression/goto-gcc/archives/libour_archive.a'.  Stop.
    ENV.deparallelize
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

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
