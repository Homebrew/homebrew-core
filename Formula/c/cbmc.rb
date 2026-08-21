class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.11.0",
      revision: "820ff0f555b43fb78e0cd9332e498461bd14244b"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fb094c69d4a877d89c3471c0c0adff0526220261e593f7ffb6f13d4224129f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e988a02557886e4e11dee46c3726a2f3d4ba709a58cbf363cca5ee700d5afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4717be1732386e1b7958ce6f83e0d8043a77e30feab747cf8179230c4696dd82"
    sha256 cellar: :any_skip_relocation, sonoma:        "24f77ab6ee97f3b4685a1538c2264f2c7b887f1315ba8b96f4a7f8a3a45f73c2"
    sha256 cellar: :any,                 arm64_linux:   "2aa5c8b901344d36371aa94a80ec0bd31b0387424f4e7e12a85773ac20b6c184"
    sha256 cellar: :any,                 x86_64_linux:  "a188dfd31e82ab5dc7ae792f08bbdbb99317e7dd22102fb286c10e886489a256"
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
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@21")

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
