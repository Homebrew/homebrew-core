class ArmNoneEabiGcc < Formula
  desc "GNU compiler collection for arm-none-eabi"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  sha256 "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia: "950ae88a2bb16979dfa0139e7476eb2fc80bc692ad880bbf092d0d6bcf0cc3a9"
    sha256 arm64_sonoma:  "47b7f8ed2c0cd6acc7ee8d1366a52a607a632e80a477cd6da44b10e7cf5a8fcd"
    sha256 arm64_ventura: "05bc9cc7feae5565e586d4325c7bc6ca13dee9b19c1bcf4f5ba4f8a818156154"
    sha256 sonoma:        "8102ba85c7ceb1e6f605148f68669bd81236a82b08606a6da7dd2d69ec931295"
    sha256 ventura:       "b8e540b02d053d17c6e1352e51fb8aa5e54b11d0058ae8a6ef7a8806a1e09614"
    sha256 arm64_linux:   "cb6c669ab813b488687953d87444b9058865ab06104bf8414a6ad5658058618d"
    sha256 x86_64_linux:  "d3de23e3829393072a929e402287b15ad48bf56962ebbdf57a933d288781e6da"
  end

  depends_on "arm-none-eabi-binutils"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

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
