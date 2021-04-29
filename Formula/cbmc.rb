class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.29.0",
      revision: "e00f267b8f9e5cd9cf2c915edfe936e5e8e7323d"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "1e85520c5bf0e87e7d24ae58916dc715921a52eeab702f1ba27a1e31a2e12fbf"
    sha256 cellar: :any_skip_relocation, catalina: "fbb1fdc9035e6f752f4663d5f8192b1987cc47024f80bb1ab4710adc890c5219"
    sha256 cellar: :any_skip_relocation, mojave:   "d3e922e9fe4d8b653bf4ece75d388f919908388ae55df8acb2923618c4caed05"
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
