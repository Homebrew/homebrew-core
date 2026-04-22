class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.9.0",
      revision: "0656298e0d023347862ada3da078c0447943f761"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c96469270fa1ee0452d1eec6cfb8dfbf94dd9eab03b4dfa417dbec8d1159df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740bcdbfc1e87a78cbd4673e6dc9dfb87faeb8401686d11943d09e86843a9402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311dc85117244dc3fc2bb567d6bdd8d36dbd8dff1bd2f3959546b85224c9e422"
    sha256 cellar: :any_skip_relocation, sonoma:        "93bda8326f842d975726f847d510d41c16987b666987545e8ac0d3989cfbfc1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41345904385da8b00248054e5e23e442ef5d058e8cae0f2a3f54c457efb00444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "effa07c230cbecdaa6108bb10a6667312c6432b93511f2e5e792d3f7d5903c71"
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
