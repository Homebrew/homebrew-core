class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.77.0",
      revision: "e1e7dc7426168bca56ee92bf1513053c7db99317"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "453919f71d38db4f44c3974ac70659af3300c8eacca7bc322dbbf395b88f73c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de82c8d75c966a84fc3b42eed83b7a2f20a997d7b084c4a5ce6f5651ab9531d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53ec42a725291b232fc60048c406889b81fa6e9a3802fb4ccc664cd5333aff30"
    sha256 cellar: :any_skip_relocation, ventura:        "eaab1f626bcaddff3ecf54b06dd59e359baf8409b497f7a9b17001a9f2bb5525"
    sha256 cellar: :any_skip_relocation, monterey:       "714c16a692750666f5248c3aa5d149b6a9629e6374ab892e1dc76244f782f4e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "30740c86337d468bb57dd10af2fb05bdd8c6e1e315766571b217ee8f957e8e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ca64c974ca35935ca175799276a5e2dd21ea09ae77da8b8df25b664bc6fef1"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-Dsat_impl=minisat2;cadical", "-B", "build", *std_cmake_args
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
