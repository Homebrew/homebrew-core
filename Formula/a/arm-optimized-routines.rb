class ArmOptimizedRoutines < Formula
  desc "Optimized implementations of various library functions for Arm processors"
  homepage "https://github.com/ARM-software/optimized-routines"
  url "https://github.com/ARM-software/optimized-routines/archive/refs/tags/v26.07.tar.gz"
  sha256 "0db974d39531e1e922cd1b31da2c3118881c4ce86b3323daf2c13830ef2b229c"
  license any_of: [
    "MIT",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]
  head "https://github.com/ARM-software/optimized-routines.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "062827cb07403531361eefd5f29d9df800b58cff8ab9e437bf217339968ddd3d"
    sha256 cellar: :any, arm64_tahoe:       "be47a663a9c8951e7d4e54d643dc1eef0f0b20342820527a90d06b839aa52739"
    sha256 cellar: :any, arm64_sequoia:     "057c2a821a6bafa9706aa3654c81a6fe81fa1f17031f4e2d1c7cec5b29579ea2"
    sha256 cellar: :any, arm64_linux:       "70aac5f44c9cff2548caad514a3e447fa1d68a74a6f02e6f4419bbef80b7df88"
    sha256 cellar: :any, x86_64_linux:      "222b546b909b3f7e016c67b0a3fa52a29ccb089eecfcc0686506be3bb56a0cc5"
  end

  on_macos do
    depends_on "gmp"
    depends_on "mpfr"
  end

  deny_network_access!

  def install
    ENV.O3 # this is forced by the Makefile anyway, so let's be consistent
    cp "config.mk.dist", "config.mk"
    inreplace "config.mk", "ARCH = aarch64", "ARCH = x86_64" if Hardware::CPU.intel?
    inreplace "Makefile", "prefix = /usr", "prefix = #{prefix}"

    system "make", "all", "install"
    bin.install "build/bin/mathbench",
                "build/bin/mathbench_libc",
                "build/bin/ulp"
  end

  test do
    (testpath/"test.c").write <<~CC
      #include <networking.h>
      int main() {
        const unsigned char trivial[1] = {0};
        // Should return a sum of 0.
        return __chksum(trivial, 1);
      }
    CC
    system ENV.cc, "test.c", "-L#{lib}", "-lnetworking", "-o", "test"
    system "./test"

    system bin/"mathbench", "all"
  end
end
