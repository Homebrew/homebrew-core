class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.36.tar.xz"
  sha256 "5788292cc5bbcca0848545af05986f6b17058b105be59e99ba7d0f9eb5336fb8"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "7ff73624acb4bc0671e9ae35f661f5118c8ed198e0a3db132f21be96e569d1ee" => :big_sur
    sha256 "e5b3899557c9de0e40411d07977a45f12aca0cfd5ddb11f24621c336bf1b5a34" => :arm64_big_sur
    sha256 "f364786230b8fad53479825413cbaa1a3a763ab6d5db878eecb4f5905649ea7b" => :catalina
    sha256 "4d026755aba1104a8af8ddde405521acb74103ab1a8a7df2a4eeb4f00f0863ce" => :mojave
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
