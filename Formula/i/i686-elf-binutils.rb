class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "3b5572694f797642f3e5821a8f731cbc4a89c3648236905478da2c13fb3adb2c"
    sha256 arm64_sequoia: "6e515db53aace13e2ffe1144d2b59536792c67dadad41ec653c81ae7cc4df645"
    sha256 arm64_sonoma:  "8bc03676ebcacb88487c56eb88d93198f08918d5d0229dfe4a6501ef444818b5"
    sha256 sonoma:        "0ef5df0fe25948c9fe2e7e14c14e25c6ffd98e5143968a67f1a628bd13f167c7"
    sha256 arm64_linux:   "e21b73fab4aa7bf7bea22ed3ef8a8d7594476ed66d89b99cb66794a886fe8f0c"
    sha256 x86_64_linux:  "b2f1ff4ef14e5201981baf7480b0dd931f9c1651ba5fd07045b08422d9018855"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
