class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "b0a006a8cb8b4b032c38c07349f0287d0cfb719ca75845cccb13415908b4938c"
    sha256 arm64_sonoma:  "9afba9508ee359df64f8f4aa6b8281a9b10955e3931466018f055191b3fdc955"
    sha256 arm64_ventura: "23dc4080e2539e76c030d156545e70b8e4884d382c960edc8f2d5380d4a96a14"
    sha256 sonoma:        "3396bc05cca54e0beed9815a264d62409606b9c769b735961d6b6cf8f09f73bc"
    sha256 ventura:       "c8aa9c42376c639a42c169b739428ce2686bf580c387830b13972ee33ee4742c"
    sha256 arm64_linux:   "cda3cb982ee056cbc462a2da05b83a3cc3bd9f27989e56b569778badfb273b31"
    sha256 x86_64_linux:  "958ff43e0bc720c34882ec39f853810e651989dfed66fc2af63c88361a96ab74"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i686-elf"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    ASM

    system bin/"i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end
