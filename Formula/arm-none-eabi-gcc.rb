class ArmNoneEabiGcc < Formula
  desc "GNU compiler collection for arm-none-eabi"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  depends_on "arm-none-eabi-binutils"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"

  def install
    target = "arm-none-eabi"
    mkdir "arm-none-eabi-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-as",
                             "--with-ld=#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      (share/"man/man7").rmtree
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
    system "#{bin}/arm-none-eabi-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-littlearm",
                 shell_output("#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-objdump -a test-c.o")
  end
end
