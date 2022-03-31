class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.54.0",
      revision: "397fcbd8af44903aca593e4dc8814132f6aab4de"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b477f39b39671e4a792bf23e264ea25f8b9081378987e4eb4b4e263f147b231d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52595bad02fbc4ea8fd291e5f9d651557e9ddd03b40081d502534bb806420ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "217128eb5d153a008da791643b6c79c7347de7a4d1433d2c85bfefb4e4cb991f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f32befaf8aaf1e11ff70c450e0c522d807ffc5c182e22467895b624518a2b1ca"
    sha256 cellar: :any_skip_relocation, catalina:       "d4d13cbb213524f94954932173e5fa95bb5f0c8289b1deaf323a8b3ec76c3b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d924e549af265ac82e2265ab7888ebbc28c9dfc4d17c3820cdba18f70ea8427"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

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
