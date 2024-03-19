class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sonoma:   "d6e7b06f63ddcb29358e2d3b9fdbd5716a7b80739d59cbb155e5ee499e2944ee"
    sha256 arm64_ventura:  "4bbf916ac386c3450e185fe37f7a4f70edccc1a80d2d066523b1289c055a1d3f"
    sha256 arm64_monterey: "11668469ed40d8e3693b8ec245e03fc4968bab9cc8fac2ebb6e233d637172a77"
    sha256 arm64_big_sur:  "3850f90bef8fdfbe512cc7800cd3623042159a76d8488a5cf4f2e53a35a1c2ff"
    sha256 sonoma:         "86db1b855150af3cc0a6d72bf6bc9efeb56b99e65c66ab625a3b37b278a68f0f"
    sha256 ventura:        "36ca2b0651e911cf5bca160a29bbe1cec825e628d3b10a46e541f0d64a683881"
    sha256 monterey:       "f0d01e3a663217ce9f6be197b7bc28d1f32cd272996df7c25f351532095e5386"
    sha256 big_sur:        "1ed85802e51a2cd2cf776dc92022b720cc01215efab59885f78e67c952eebaef"
    sha256 x86_64_linux:   "6b185249ca7ab5ca18d024d47de938a02fb81b2626a5d554bdfe9805edbde55a"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"

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
    system "#{bin}/i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-i386",
      shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
  end
end
