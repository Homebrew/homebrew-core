class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "b68aa754ca6fdcc0a5561636da86b73de85bcc877275a7b009f11e442e266fd3"
    sha256 arm64_ventura:  "209a3a9d152fdbc0b26ed7926cd000ab537e90c672f5958c9dbd6a2ac2bc9b3e"
    sha256 arm64_monterey: "34fea4cc6c033f2cfeacd7ed850ef4b79bb4fa409bae6b3103b5b536aeaef59c"
    sha256 sonoma:         "fbaec4c72cb15463b4be71256284621856a39bcd29a265e700e5a7d0e1929a97"
    sha256 ventura:        "1c68e536f0226dc59da88e099786b17a47be98fcce18f5ea68b0fdf1342126aa"
    sha256 monterey:       "9946c225f36f7d2d25a84226e6ac15ca3cdcd4b1eae534cb45b9bc38b827a81c"
    sha256 x86_64_linux:   "e54c42aab45e4772fc3b20068021b5a9e3a35fe4114158765ad417e8ed5c43cc"
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
