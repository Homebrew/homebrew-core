class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.4.1",
      revision: "c902db34beb113815f151c4d1f635e745ac79c0c"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e05561fe7d5ebef7193131e715a51ba3333f7a7049053c0515197b266ed0f44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfdce5719d48d31342be5de4ffbc058c75379cd6761b482c35f6580de9caaa7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c585f645ff7ddb8ba111fb6bb767232e3326eb980786e56c3c4d7141e19b9dac"
    sha256 cellar: :any_skip_relocation, sonoma:        "268f4fc857d8162123a86ce5a21f88425dbc65b27612708864db748078fc09ce"
    sha256 cellar: :any_skip_relocation, ventura:       "8babc8404f37fb21553dcbee759dd94f029a53764bd85ac9db8b1cd63b2ce763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f500a38f6ccd2e0b9c321e6cd09b522ed2885b46691e06bdc04cc1c16785a04"
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
