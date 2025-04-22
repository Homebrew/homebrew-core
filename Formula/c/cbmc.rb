class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.5.0",
      revision: "32143ddf8ae93e6bd0f52189de509662348c2373"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e1eefabafa781371095d8d78ed92702d26857e2e1675272fbbb5d83629518c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd02ef83fa3cfafca939cac520a4ba06175146efdbed6d60b5633f88c8f4b12e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05670fc3a4c5c1caefa6ecb4be19906892af3ca991fca6a1fac802440499fc7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee54b24f56dca3a3bbca4b358948ac8df910a170b5cd40c076ca9bc34f7e5b27"
    sha256 cellar: :any_skip_relocation, ventura:       "812ce22c462a6aa53241dc798ddfe456cb8d4586db4be63959cd7d451b3e0968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548d27755c45f823798a7fac8cd089bd245040f88377edafc3e0a6954dcd0b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71e79f13a3cea1c404b29d27e5ac7715ab7480e141b3d58ee96e32bd70a01f6"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk@21" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
    (testpath/"main.c").write <<~C
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    C
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}/cbmc --pointer-check main.c", 10)
  end
end
