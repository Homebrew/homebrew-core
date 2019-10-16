class I386ElfGcc < Formula
  desc "The GNU compiler collection for i386-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-9.2.0/gcc-9.2.0.tar.xz"
  sha256 "ea6ef08f121239da5695f76c9b33637a118dcf63e24164422231917fa61fb206"

  bottle do
    sha256 "e7b2581357b72f1f6467d5c023540f5d7bfa4b6a0dd66738f10b150ca2d9a90e" => :catalina
    sha256 "9c07c54353f96455a4c2a9c5c3468a2b39770917f6555f56e9cd3c953df5bdb8" => :mojave
    sha256 "5ee8e21a5a3490d19c0c5dc947144786862d3e182fb51f89be66fd1cc1eb0427" => :high_sierra
    sha256 "601dbae559327522ea705c0c7b92fc3dcf5280873d350b9e29913563261a73a1" => :sierra
  end

  depends_on "gmp"
  depends_on "i386-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"

  def install
    mkdir "i386-elf-gcc-build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--without-isl",
                             "--disable-multilib",
                             "--disable-nls",
                             "--disable-werror",
                             "--without-headers",
                             "--with-as=#{Formula["i386-elf-binutils"].bin}/i386-elf-as",
                             "--with-ld=#{Formula["i386-elf-binutils"].bin}/i386-elf-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"
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
    system "#{bin}/i386-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-i386", shell_output("#{Formula["i386-elf-binutils"].bin}/i386-elf-objdump -a test-c.o")
  end
end
