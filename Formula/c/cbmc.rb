class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.10.0",
      revision: "7483d0de40b2f39850f4f5ba5dd9c6e38f959e31"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c46870eb393338edac511e09537c1cdc1e3e38f7f2d62e7813d85014f17eac41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "318ccd56ed94fe0ea6b1fed294f8af9b33f0dd454ab2365c2af2dd19f3e5b0f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae3729dcb4532c72c6ba4d9dde12c4e50ab4b9bb3bfa147c90019fdfd5fc44d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1072e75bc3eb04b819c23a4505e6f94f246b276c69f71225e020d3c1f5aecb8b"
    sha256 cellar: :any,                 arm64_linux:   "02783b8b988b3449a9c3cbf97f194b28e0cf40ae4d1ea9a2c6378ba220b20aa6"
    sha256 cellar: :any,                 x86_64_linux:  "29704fcc76812db7561e2b1df058e19c3ad0a2b8a6ca7eceab2ba17d2e4242f7"
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
