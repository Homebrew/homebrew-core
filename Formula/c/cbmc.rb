class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.8.0",
      revision: "cdee49cb1a32c6d6703cebf6ae67161977264ad4"
  license "BSD-4-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab18612102175e15adcc972b4dffe29aba91ef743c9a0921179d351f93289fdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b3a6ab8492da8f724b04326adaac8d2b48310cd616ebb4cab2d416f2d767a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08181f275b21c4f4f7fba64887be74838059178b589c461a2bac2b1a406e9bf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9121b3cf4e5167aa5f4db82dc79bd81564119e1395a94511626d1c93241f914c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4630714a17550f6e8fd957b7a1bf31ed2d976205688ae627e8bc70006aa50a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3cd7b5b7afd46887bf16333ad49bacd85f4e07d4eb9406577b3afdf22250e67"
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
