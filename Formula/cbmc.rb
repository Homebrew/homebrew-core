class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.35.0",
      revision: "7e291a5232bf0dcae9feba0281d371b83491d832"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3561b076e1f702e79a2c2343ac6db25ae4e5d8e83248d825127afb9ae327df4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a15c21cc088d7c24ef82bfc21f7dfe6d623970eab6adf15d47af9ea9b01b682f"
    sha256 cellar: :any_skip_relocation, catalina:      "7da20351c1e2581bc09ea723a99339d9d4a40f24e73476f2c187ba7bf92c7166"
    sha256 cellar: :any_skip_relocation, mojave:        "73f956a3042c0e78c7c3049a55264325655e6c11c43e6dddc338c6bb1089e44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "707f3faca6daddcfd9d7eeee89647e214ebf856d6c05d1cec62a590e00bf701a"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    args = []

    # Workaround borrowed from https://github.com/diffblue/cbmc/issues/4956
    on_macos { args << "-DCMAKE_C_COMPILER=/usr/bin/clang" }
    # Java front-end fails to build on ARM
    args << "-DWITH_JBMC=OFF" if Hardware::CPU.arm?

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "cmake", "--build", "."
      system "make", "install"
    end

    # lib contains only `jar` files
    libexec.install lib unless Hardware::CPU.arm?
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
