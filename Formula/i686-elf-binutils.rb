class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "544e3b442d215df6062f4309e3bdfc4ec4e9ec18853dc86b8f2bb2126083998b"
    sha256 arm64_big_sur:  "5a1e42c4f7deaff68b779e342e844aaea0591577931be516ae58138121385061"
    sha256 monterey:       "10962de855a9beee6abc8dd56d06194380133438cced597a8fe8c8711d8d03a8"
    sha256 big_sur:        "30e6f1dc367905d6cc5199203d68339b05cef66e7a709236d5729026df6ac531"
    sha256 catalina:       "39e98e8b3753e036c1a20c3b5e4d897902f961e5dbbfb035d6315dd7b5174350"
    sha256 x86_64_linux:   "bbf9154fc1e03c82229bbc98ca1e913268f511d7e1f61d60453002a7cd6bc264"
  end

  uses_from_macos "texinfo"

  def install
    target = "i686-elf"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
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
