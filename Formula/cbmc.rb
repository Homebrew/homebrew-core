class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.60.0",
      revision: "026931f0c5892bb5037299fb1afda38632f2e050"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa97c3b0a47b72e6b1aed10858b54dfb0d6c8da69567983274d1297be3ca9c5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a1edaa9be6e2a83dedc21b353bd5d57c94b9b9423bdb611a6242daedac6da61"
    sha256 cellar: :any_skip_relocation, monterey:       "9b02b928593adc2880495e1af6d824a2fb8a6990f9b2ba4ccd0eb3ddbb5abdc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c91c44d7dd0e88dbb0a74a8822cedc23134b7d9daf44d70fd926bf55459f473"
    sha256 cellar: :any_skip_relocation, catalina:       "f675a78cbff8002827f89c7dbcd1a91824e37475711d4a859eac2ce5494b99e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "071533f88778c5c961d29def5b19bc1438c2a26773fe56bdf8ba0b2d67711cae"
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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
