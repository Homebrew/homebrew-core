class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.38.0",
      revision: "667858fb799e82df7f6cafca53b13ed996824b64"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ae0c663a340ee634c711112bf3ef842e2aa7673c3a4d8e41b5a3128206eb9b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "0783827cb05a349c4af6ac4da4a2684f7c663c05f7e4d5370372b5647bdbff40"
    sha256 cellar: :any_skip_relocation, catalina:      "ae28dfaf328d6563bf49b631deae3dcea5d85ff9b76973e71c238c7450fc4584"
    sha256 cellar: :any_skip_relocation, mojave:        "319b650757af4b99cc976236c2158e011d6b0226e6134f3a341329d9fbf983a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566db205fae9f0b2b6e5cd9114e5569654ad5fad7e3344a8cfa4163bafea376a"
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
