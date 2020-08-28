class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.35.tar.gz"
  sha256 "a3ac62bae4f339855b5449cfa9b49df90c635adbd67ecb8a0e7f3ae86a058da6"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "bd767e1db00546bce96d34152ec795c22c2806b85d38a35ead97ff891a61df34" => :catalina
    sha256 "cb33e5097284b273a810efd58d3acfafb95a50de6237ba0fdc97b270e6395ac0" => :mojave
    sha256 "183a5bbcad9e513964112ee9b35095dabe0987e65a0252598a15974eb8ab9f74" => :high_sierra
  end

  def install
    system "./configure", "--target=i686-elf",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}/i686-elf-binutils",
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
