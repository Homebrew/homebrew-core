class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  sha256 "61d684f0aa5e76ac6585ad8898a2427aade8979ed5e7f85492286c4dfc13ee86"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "55791f05a697919ba656f3ff91bebdb41d0e8a1069ec622daef1cd43c474b330"
    sha256 arm64_monterey: "4d3044279634a7ab235f99fcfbc847ed97fd05d4e3e45e641b151ec98a61af9c"
    sha256 arm64_big_sur:  "a308257af007b89d263451344280c5f98600bdeecc0b3f963b921c7324321b56"
    sha256 ventura:        "7ae074f3ab262122ed094ebf2f0c5a33a2a5a74d8ec6d70102dd3b014f0e8be8"
    sha256 monterey:       "2a7b3c9381c943d5c74f4868ec580b4de8e7ff1c6f85c189b38f7ab1e4bd28d4"
    sha256 big_sur:        "df23e6b02c3cbb6e8343029bc894d40f8766bed56e240af84fcc2e802773252d"
    sha256 x86_64_linux:   "6946dd54377ac2df075cb46814bca2a27337c1e9fc9a1829c83586ceb966b1c9"
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
