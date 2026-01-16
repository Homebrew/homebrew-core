class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "dbf3911e6559a1921813037bfb643eca2ee21db1108c6ce1e599bc29208dbd6d"
    sha256 arm64_sequoia: "623c017a8c86ad5f893575a368261e6df814a79c3a7b8c1af6814dc857261c91"
    sha256 arm64_sonoma:  "6360b0f6259e3dab4862bdbc8fd6d6420ee6de1277e8674b7055548b43f2a19d"
    sha256 sonoma:        "e1a8ced292868c76b13dd0ee5421861a4a27f030d0812136d207e39d81c02536"
    sha256 arm64_linux:   "a6090f1a3af2ed3c8d1c089ef087ef1bf968b66ae232232858deac3168374da4"
    sha256 x86_64_linux:  "36e8f15db48ce2fe341317b88f1dbc864140f81419aa4eb3d13097db21bd1a9d"
  end

  depends_on "pkgconf" => :build
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
