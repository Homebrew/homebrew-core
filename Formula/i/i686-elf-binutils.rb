class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "a05bf2500ff229a7b7de5da928922c206b9b111647153589ce402c956db1f606"
    sha256 arm64_sequoia: "93c04510cf54af4eb50a627a535e0e457a7194789a825b2d81b1968668a1600c"
    sha256 arm64_sonoma:  "40ba85e8b4d0651bc5247c8cb78f0625d84227cbece7dbe9dae7cdefe0dc571b"
    sha256 sonoma:        "dd99379373c7bf35677047594fe399b30eba9163329a22b94642e95138b95ec9"
    sha256 arm64_linux:   "7bb04e31ce0f9d20011c2c5884625d24aafce22b0c8c8dd93d2e6f99077a31cb"
    sha256 x86_64_linux:  "b010c33a7e7b88da4a31fb1fc46ea4079c3281c71d084f662d0f765f118858ae"
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
