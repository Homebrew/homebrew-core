class ArmNoneEabiGcc < Formula
  desc "GNU compiler collection for arm-none-eabi"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  sha256 "50efb4d94c3397aff3b0d61a5abd748b4dd31d9d3f2ab7be05b171d36a510f79"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "7573fd4e0b21843b4784eb729cda4895f36c25e89b963a4390cd0e2314f6d6eb"
    sha256 arm64_sequoia: "2b405ada76d998c8e154d282e3e5a29e43cfe0e31bd12469142015b377f465e0"
    sha256 arm64_sonoma:  "c8fcc7b952187622aafe9e60e4c64391c741c8b028adc2c3c580101aade8ddaf"
    sha256 sonoma:        "7541d239f02d871caf18a692cc79afc58076fadc70925775ebb892be066e8556"
    sha256 arm64_linux:   "914d9ff78aa719866ac62d90b9cff345c378e84a8d08ab5cfdd75737ee9850c1"
    sha256 x86_64_linux:  "9a394fb45248bdc5359c8bb0a6aed1fc5041298cbdcf5481fff7a7b0a4ddbc7a"
  end

  depends_on "arm-none-eabi-binutils"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "arm-none-eabi"
    mkdir "arm-none-eabi-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-headers",
                             "--with-as=#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-as",
                             "--with-ld=#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-ld",
                             "--enable-languages=c,c++,objc,lto",
                             "--enable-lto",
                             "--enable-multilib",
                             "--with-multilib-list=aprofile,rmprofile",
                             "--with-system-zlib",
                             "--with-zstd",
                             *std_configure_args
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      rm_r(share/"man/man7")
    end
  end

  test do
    (testpath/"test-c.c").write <<~C
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    C
    system bin/"arm-none-eabi-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-littlearm",
                 shell_output("#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-objdump -a test-c.o")
  end
end
