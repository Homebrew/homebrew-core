class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.44.0",
      revision: "e27dba61975a3afc10c8ae133f2227d96f891def"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98624305c23083625717fa4631fa66d553e34cd8aec12f2ae82a99fefeccf75f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a49fe5cbf25d26bb4ea1ea0944cc13611fa59161b3a6457a735de2336b22348"
    sha256 cellar: :any_skip_relocation, monterey:       "df285311e17e1b776eb902ce93345f9e5cc3fb24278261b77861e886bcaa5868"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbfbc0bea8b9042aa2150fca5d3d54d6835372c43f66d33ddfb57e3068339068"
    sha256 cellar: :any_skip_relocation, catalina:       "4cb5bf7625a700bd29d01be29fb95fcac73b59ebaa526e8c1d71329d5138790e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7438e60abcf91f51915277015f542dfd65178fe5a1db7c4c0bf987e8e53cd4d"
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
