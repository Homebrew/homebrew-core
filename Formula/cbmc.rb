class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.39.2",
      revision: "8e4b5c6b4f13ca62fa8674eb006d16c8e4ba72c4"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32646f8dfef5ee84202fe954b61d0853669291e6d16c641b81dac7db48754221"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b12174446198f981eb02341e8965d4a887fb5e7454b4fd9d5332fff0b83c248"
    sha256 cellar: :any_skip_relocation, catalina:      "ec08e3408a045179db573579a4461a75a5ccfce00ec03d995a65acfe7bac44dd"
    sha256 cellar: :any_skip_relocation, mojave:        "02426b3c2597e66701a5a45bab0414b171940d218b2685d271375f608a06d58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733cebd4483de66a342f34a50d3f7a6efe7e80dcc7132317533c8a752b33619e"
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
