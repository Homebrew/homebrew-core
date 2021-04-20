class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.28.1",
      revision: "48893287099cb5780302fe9dc415eb6888354fd6"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "50cdd2771d318d583b45a98c3caa5d6f8d84cb595fd672b34a08bfa484297f9a"
    sha256 cellar: :any_skip_relocation, catalina: "7444effee8578c697765457fad4f4a42dcfb279d192a0e8c46252614a4f508ae"
    sha256 cellar: :any_skip_relocation, mojave:   "8e1027a672f0daf00156dc53d725277a6cc580de0c3f522b23b9609d3d2fbd6d"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    args = std_cmake_args + %w[
      -DCMAKE_C_COMPILER=/usr/bin/clang
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "make", "install"
    end

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
