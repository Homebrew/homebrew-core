class Cbmc < Formula
  desc "CBMC: The C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      :using    => :git,
      :tag      => "cbmc-5.12.4",
      :revision => "b0b322501b29b30d8767e756ae641dc338d95caa"
  license "BSD-4-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "255236150a3002399fe095c55a5df9ae60dede5f28c0dc4be17c473cbf56becb" => :catalina
    sha256 "c40fa97d0b4ddeb8d28fa8e962fbd74a5d2f6b6bfd9fe7bbbec617c80c1b7e77" => :mojave
    sha256 "68c680e2456620a0ee7bd331cb7cf77ec26ac37ab2b93a0f47bcd382a17450d5" => :high_sierra
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
