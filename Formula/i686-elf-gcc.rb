class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  sha256 "62fd634889f31c02b64af2c468f064b47ad1ca78411c45abe6ac4b5f8dd19c7b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_monterey: "1cab4ffbf89904279fc85aa6f42a6c06f43907116fc6a3d7a9d4461e7dc7b358"
    sha256 arm64_big_sur:  "6cc4e8f9c771466cb4c65ff41ebea41f8951579c9a1d51b07d18b8bd6136f2e9"
    sha256 monterey:       "48d6944ef5842de0ac224bdce9fb521bb9763b335f0a1bbcce2ad3ca4fefc50e"
    sha256 big_sur:        "51c5d795d33fdc4ec01e509387d9d79d7966d1cec0e66236d6f2776ebc94374c"
    sha256 catalina:       "51504a2f517815c84192f35f8a9ad68650897ab5c906f431f13318f1338f520e"
    sha256 x86_64_linux:   "89f6af92c0aeda416f5a237940940312f09326081e9486ec51a680d5721ff94e"
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
