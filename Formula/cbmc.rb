class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.39.3",
      revision: "98bbe743d42d7a890647cb563abb66c5e9b7a3b1"
  license "BSD-4-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3dd5130b8dbf40fbfba8bf0329d18b34a3f433bd3b077f19cff632b413940223"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c2ae3538e581dd485366aafbf438ab1880b2a6d323bcbe1828521b84448d2e4"
    sha256 cellar: :any_skip_relocation, catalina:      "8a4ce4a0fee9044b205e5638aced6075040c76f5c2171b49ef48b920ba6ada00"
    sha256 cellar: :any_skip_relocation, mojave:        "1df55507dbc13827095561b8d9f489de57e462aa80fb24403c9fe487ab8edac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b71e46849be8b0fa0628a5bc8a2251321792cb94d7c9abecd4daf2a6a3a8cf"
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
    args = []
    # Workaround borrowed from https://github.com/diffblue/cbmc/issues/4956
    args << "-DCMAKE_C_COMPILER=/usr/bin/clang" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
