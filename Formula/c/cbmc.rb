class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.1.1",
      revision: "b3359791bcc1a6651646920c3936ce167465db92"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48a856a3945a22ade6131b4073faed0252e3992de835712b8144199a2b1e10c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "129279a698dbd5282e001d638d3d6a6a97561e56898faf68e2ead8ce8809952d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2b448cd489913fae0be75cafd97bcbe41c957800fdb4feefd304f4a92d01b38"
    sha256 cellar: :any_skip_relocation, sonoma:         "714a151f4e5b61157ca1e83f7b59ad145c09a8da2b94e04e667ef9305a4dcf88"
    sha256 cellar: :any_skip_relocation, ventura:        "d0bf9d9d4501d39c1cd53aab2971058f5f826cee20711a27784eeaf14472b4dd"
    sha256 cellar: :any_skip_relocation, monterey:       "d3655a6f2381a806d7f6250f67a43c234b4c5c7ab7028e07b9aac450c6c27c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a0d46330bb1eb42845215cd701359603fb06d881e936b70df190c1d70e5f15"
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
