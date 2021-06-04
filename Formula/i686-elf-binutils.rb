class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.36.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.36.1.tar.xz"
  sha256 "e81d9edf373f193af428a0f256674aea62a9d74dfe93f65192d4eae030b0f3b0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "1250e2e488a22f422b981a5b38602b1269568020c167c491894a7d984a3fbea8"
    sha256 big_sur:       "3531f2d1d0ca60c8f6adc3b01f1eefb06013772753a5d897d25ff519e6e3a46f"
    sha256 catalina:      "70089cd3999c348b635336714145c516ae12d11d6ff8cfb600143f6828fe0f97"
    sha256 mojave:        "158c9edec23673109178a80eb05faa007e7230e94ee489e4d427211c11263e96"
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
