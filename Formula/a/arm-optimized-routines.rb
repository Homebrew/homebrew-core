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
