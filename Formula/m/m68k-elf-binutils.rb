class M68kElfBinutils < Formula
  desc "GNU Binutils for m68k-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "c59c5187633bc50256f7b30aa4ef814bcbb77f19705cfba6bc8bd42d2a9be4ce"
    sha256 arm64_sequoia: "45d06039752e7204d08d93f032e98bf500714c055ceeda5093d924b71358d965"
    sha256 arm64_sonoma:  "a1485c13b8bc61a6ee1ce3cb36f8538088cd78195a9bb910b911594675de648e"
    sha256 sonoma:        "28cff540bde5977f2b064c7e7b0869c5a59e83e7ad7b1b16122c5de0a8c4662f"
    sha256 arm64_linux:   "49c1147a21893bd232487965d3030e9f6beaa11bb6d37ab0aa5240435a8741e2"
    sha256 x86_64_linux:  "bfcab026b472c9e6a2ed6f7ad1eed8fbb1b2f6e35019eaed1500b8c4b040a0b4"
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
