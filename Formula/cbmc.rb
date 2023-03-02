class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.78.0",
      revision: "a8abbf157233e33347dee68e6e3bfee1e385d208"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5856f0d1a988e24cc9488d9af95ec8c113ff0d019a2bd5b0894ef125ae80568c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78050a2e1ce013904cc57c17f7e5b0c4f97f63f2f6593ee518ab7ec3f9a92a4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "428a6d4d810362a72d180a48b5827f686b9ce565e2f6dbf38a2d51805833b78d"
    sha256 cellar: :any_skip_relocation, ventura:        "4928d721ac8f020c3496ba0d383f65dd12adcc080178eea20a463251564b3317"
    sha256 cellar: :any_skip_relocation, monterey:       "cb97d824db619b34d37d66f9fbcfc9749135f40242c32c9d2bb54d656246ec10"
    sha256 cellar: :any_skip_relocation, big_sur:        "51cb85a094737c7ca700b5e694727fe1e9bcd9e69c822f52cc7bd82fee7b0f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc1076d8691093b009c6717874e0035b7e4df8c684a4bff2f53d7271fe2e8a0d"
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
