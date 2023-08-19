class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.90.0",
      revision: "6f1454272b7dffc4e37dc969d65653e69c14f904"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56232586f21d1eea2d6c002ee0efbecd9a278214087f3abff94b915d64c5d5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05c06fceb950c59a64631cb313642ab37e61a1ac9c762795fa6c0470dbb20f8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "307adfdf3a02b8154ca5b92cb059882f76d42d54f15e641fd45e8caf2906b703"
    sha256 cellar: :any_skip_relocation, ventura:        "17d85966bf67c2073a056a62ed212c5cc61f23bf063c6c4b26884b84ae410a75"
    sha256 cellar: :any_skip_relocation, monterey:       "c35f871bbb78f650ea957f97cfb2479a2f254daf4c41f5bfb8b4c5273e7f9220"
    sha256 cellar: :any_skip_relocation, big_sur:        "6906d209f86d7cd936bc6939f8eff67926043a19275938660a018a4cf37d721e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62ccaa3d9dad37d0f55583f775b205d12f2a30706b3c21106d5be0b4d3ddb563"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
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
