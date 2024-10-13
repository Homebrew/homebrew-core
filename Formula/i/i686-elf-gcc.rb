class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia:  "ed4f24ab8d5ddfb3ac152bcea2770091f971371e6f12e4d0c52bada32029a886"
    sha256 arm64_sonoma:   "0a57ba083890cd5c545c7c4a64c951204a9f7fc129125fa12b2849c1f6560f14"
    sha256 arm64_ventura:  "519150001d183b5cbd146e898583f39bff796dbd6ea573932181c2e7e52f8b87"
    sha256 arm64_monterey: "afec4b766ffdca1f197b9765d39d1833db026b5dab624b9a0248a185959f4e39"
    sha256 sonoma:         "f36ee7f782db7f66e6f11206ef5373f3703523fbf26cab16cce574bbc8c241e9"
    sha256 ventura:        "5119fac4b4c065b990c8dd8319202f7265c3896f0deeeb47c2adc1fb86290295"
    sha256 monterey:       "36ecef923608bbd2c7bee2956da81eb2b7dc22e96b6966c23d85458b7e77a510"
    sha256 x86_64_linux:   "a03e1a866a1d4dc0204011be8ad2466bf34ec96e8e0113201173d57fc4c5b016"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  def install
    target = "i686-elf"
    mkdir "i686-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["i686-elf-binutils"].bin}/i686-elf-as",
                             "--with-ld=#{Formula["i686-elf-binutils"].bin}/i686-elf-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      rm_r(share/"man/man7")
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS

    system bin/"i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    output = shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
    assert_match "file format elf32-i386", output
  end
end
