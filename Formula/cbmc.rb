class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.36.0",
      revision: "25ed175d8d40fb3bfb82426028d05718fb204499"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b01f49cc87b0ece5746cfc0b9c0630ccb70f4df4bdab04c95116b63984d00a61"
    sha256 cellar: :any_skip_relocation, big_sur:       "c00f9db66a19055bd0e3ae8b8cbf226a361289f022cb1318ce34d961a292fbb3"
    sha256 cellar: :any_skip_relocation, catalina:      "0c744188eac8733038a7df384a4a1481f8d8ad4daaa28f24c66e224da1d158da"
    sha256 cellar: :any_skip_relocation, mojave:        "c14b80955d52fe3692f56a336595b2e10022983c9f88896ab4d50e328b519534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "462936c1f44b5a0e13d3e094ad45fb01a3f349054a95a44c20fcbd69630f0be7"
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
