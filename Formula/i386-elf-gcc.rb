class I386ElfGcc < Formula
  desc "The GNU compiler collection for i386-elf"
  homepage "https://gcc.gnu.org"
  url "https://mirrors.nju.edu.cn/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz"
  sha256 "196c3c04ba2613f893283977e6011b2345d1cd1af9abeac58e916b1aab3e0080"

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
