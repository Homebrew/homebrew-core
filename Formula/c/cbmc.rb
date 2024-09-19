class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.3.0",
      revision: "5bd494a1a961762a038ba8e055bc1e4a12dbba3b"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "547be02ac0f433c32c3891ae903a0fd636b5f969f0d48f979fb2bb297120b997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2498148a8885ca9dc4bf43b74223fbb6133c751cda63fb4696c77a289c05077e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf25cd38405568e00ae636911f9d99d9e11bd3af412347e35493b546f89e19e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc6541c50375420b8039db909c479357f4b6ea08c42b662c848116c545244235"
    sha256 cellar: :any_skip_relocation, ventura:       "98ca34ae1079827e7db598a4548dd53f736c28ba675fa2ec8f071bcd9f8d6ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5f6935072f1af26fc5559e16e5c92b06bb6da0d2a7f80e6f1c2c155215bf1e"
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
