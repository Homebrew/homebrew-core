class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.6.0",
      revision: "3c915ebe35448a20555c1ef55d51540b52c5c34a"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "619e622f250caa0d40ca68371a7d7316275b705a823f43e3cabc89863bf8e34b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81fd93129dad62a45ee0816001956f822358ca8b80af50ef8265c78563e953d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "990dbaefff6e71286ed2409705c511aa0dbc2ba51aebbd064ca7720140014d8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fb5b4876132ce6980a2801faf5d5b6e7a32071ea539feedb9840179856053c"
    sha256 cellar: :any_skip_relocation, ventura:       "b27e1306aa88d98c38077a6457fa5debaaaeaa0de0747b93a3fa24d3173e5a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26d417c3c3b654e02ccbe0a272b45c48f4195befaa37367b64b16c7a743e7907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0a38ee6db636d7f1867eb0b26f2a475b936767c63d425311698d837cda9369"
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
