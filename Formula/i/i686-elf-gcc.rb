class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "9b1973c78b379a53dcef17ccb6bfde0eedfe4804642f49809566d41672a78a80"
    sha256 arm64_sequoia: "9ebc28afe2308055d5c3734a6a1312e2976f12566058a818731152fe796c895b"
    sha256 arm64_sonoma:  "a7471aa25a2e17e5e793346e7113b9c56ea5af1afde81cb776e352c11ed84b6a"
    sha256 arm64_ventura: "84dc4edbe13331ffd0044ee60070d4a5e9a6cc02a119fe3afd80cb5f34b70cbc"
    sha256 sonoma:        "20a35b16e55805bcfecce53cf2e65bf396496fe59b76e3ec9149c8c1ec2bcb00"
    sha256 ventura:       "343996e94ffed850bb21ff7674a54109af7ed51b9ea93fc7855049f30f9d6735"
    sha256 arm64_linux:   "79dfcd591eee5344728dc16b19642b353dd129449e7f9e5eca6f7f202fdcf77a"
    sha256 x86_64_linux:  "60dac0fa2b727b1eef993102653635ddf28e6aa183e6aca96de94f9d2b0068f8"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

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
                             "--with-system-zlib",
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
    (testpath/"test-c.c").write <<~C
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    C

    system bin/"i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    output = shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
    assert_match "file format elf32-i386", output
  end
end
