class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.42.tar.bz2"
  sha256 "aa54850ebda5064c72cd4ec2d9b056c294252991486350d9a97ab2a6dfdfaf12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "804d849a27e5ee2b822f58b5877a6b2529bc9e1292106232e9e8efa2f2231621"
    sha256 arm64_ventura:  "4ba5070c9e8a3df848ad7e47b8e8451dab3b32394a25d92026386ee715b330b6"
    sha256 arm64_monterey: "af17c2346c5270ca02124d957e1e0f62e4c7a40669ecc37e12578649b3852352"
    sha256 sonoma:         "85defe4d17e25e359c03e408ec91ddd512579fe8d41c02c71221381adecfa510"
    sha256 ventura:        "a5e8ec4c681084eb9b931d87553655ce2673d17adb1846968a32ea17f1609e65"
    sha256 monterey:       "df47d8f2feef198edfca99bf9477fbe3d0d22019a8a620de050ef0b8f68984d0"
    sha256 x86_64_linux:   "a52dd1e22aece73ec60f665ee1748ae63b6cb408672646c6ad5268f0260179a4"
  end

  depends_on "pkg-config" => :build
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
    (testpath/"test-s.s").write <<~EOS
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS
    system "#{bin}/i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end
