class Cbmc < Formula
  desc "CBMC: The C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      :using    => :git,
      :tag      => "cbmc-5.12.2",
      :revision => "7405bfb6d6971ab53e430e553910b940522213ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd44770d72509e90122d012d175fa7c0d4a96c306c2ce83da16b4289c628a1fb" => :catalina
    sha256 "076ff439d06a93e350aa5cc1c9e18d34af12ba2caa5df716e68103328b509346" => :mojave
    sha256 "0cc700306db145c37019af3b178285751c9af4450e55d22cc78ed2506e7390ab" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    system "git", "submodule", "update", "--init"

    # Build CBMC
    system "cmake", "-S.", "-Bbuild", *std_cmake_args
    system "cmake", "--build", "build"
    cd "build" do
      system "make", "install"
    end
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
