class I386ElfGcc < Formula
  desc "The GNU compiler collection for i386-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-9.1.0/gcc-9.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-9.1.0/gcc-9.1.0.tar.xz"
  sha256 "79a66834e96a6050d8fe78db2c3b32fb285b230b855d0a66288235bc04b327a0"

  bottle do
    sha256 "a5fc827397725b13fcf0b4c455b68021b2285c80fb0c047030db9602d3e98623" => :mojave
    sha256 "913cafca1eb2ec4493d09eda85f16c64561835c35882eb4bad13c81692bcb468" => :high_sierra
    sha256 "e63d8a51cce665fbd05aa7cbc75082181caeaf38b8c77210e5c3846cdc49e1e5" => :sierra
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
