class Cbmc < Formula
  desc "CBMC: The C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      :using    => :git,
      :tag      => "cbmc-5.12",
      :revision => "d51243d346350127ecb269f1e546cbd850ef6955"
  sha256 "1b9d003e1baffc714b36a38087e4ed42b47c04da5ebdb02bbce03262ea3acafd"

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    system "git", "submodule", "update", "--init"

    # Build CBMC
    system "cmake", std_cmake_args, "-S.", "-Bbuild"
    system "cmake", "--build", "build"

    # Install CBMC
    #  CBMC 5.12 does not come with an install target
    #  Pull request submitted to add install target to CBMC 5.13:
    #    https://github.com/diffblue/cbmc/pull/5320
    bin.install "build/bin/cbmc"
    bin.install "build/bin/goto-analyzer"
    bin.install "build/bin/goto-cc"
    bin.install "build/bin/goto-diff"
    bin.install "build/bin/goto-gcc"
    bin.install "build/bin/goto-harness"
    bin.install "build/bin/goto-instrument"
    bin.install "build/bin/janalyzer"
    bin.install "build/bin/java-unit"
    bin.install "build/bin/jbmc"
    bin.install "build/bin/jdiff"
    man1.install "doc/man/cbmc.1"
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
