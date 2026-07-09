class M68kElfBinutils < Formula
  desc "GNU Binutils for m68k-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "b5a051b818ad83261d1a369f4715039a706a7a159f805ce4f4d4887281848e25"
    sha256 arm64_sequoia: "91c010abf5dc4cfcc936324265bfc3367bcc9c13bb8cee00965d5260f1845519"
    sha256 arm64_sonoma:  "ceb4a797d11cd6d0ab2b25f9f6053fd68f402c66b9c5d08580ae8867bb9ab689"
    sha256 sonoma:        "01f9a6d02df8becc3322a920da7518cc717660c56e3da1aafb924a5e75eef3d2"
    sha256 arm64_linux:   "9153e003b976a394855e51f237325e236e2b2016fcb3bac15285ed4f6ff8400c"
    sha256 x86_64_linux:  "fa7e787dfe2244461f5a3790b1695235091ee4bc154e9c587183aff8a9dab6c2"
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
    target = "m68k-elf"
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
    (testpath/"test-s.s").write <<~M68K
      .section .text
      .globl _start
      _start:
          move.b #42, d0
          move.b #42, d1
    M68K

    system bin/"m68k-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-m68k",
                 shell_output("#{bin}/m68k-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/m68k-elf-c++filt _Z1fv")
  end
end
