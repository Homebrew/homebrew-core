class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.44.0",
      revision: "e27dba61975a3afc10c8ae133f2227d96f891def"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e65a5ebf867b22bed10a3469077ff276e332ae8e15b28a8ff7ec3463c8f3977c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0023077c3883f89b150e60b05cfecd19b85fc049c0999f88ddaf3268a1877c4"
    sha256 cellar: :any_skip_relocation, monterey:       "0e7ef1c8963f255194eb20cbf669dac490f36388ce7102a5cda2b4456c9b9929"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1ed27da688ad2053c172c67108637b776d5e15dee47a98e5347779a4150dbed"
    sha256 cellar: :any_skip_relocation, catalina:       "db823299fad84c3f4ea3da97126965bc14bf9e8747f267823d6034dd91330f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b92fd86cc2b8cb7e6f23d56e3c2728f9766a108f4e88c4342c12422fa43e81d"
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
