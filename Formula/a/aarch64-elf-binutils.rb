class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "ff613c2c092e98c1ed1fab397d4f31c02d4d011bf45fdddad77f42f40ea8aa17"
    sha256 arm64_sonoma:  "04d64d11771d85fc9b94fe1b998f7093f80ef073a80b60a49459db90ab5ef727"
    sha256 arm64_ventura: "f07ba9c20e29cbdd0265f5d2e42a2c3b1b34b89a3e72b8fd216ffc10cb058db2"
    sha256 sonoma:        "dc0f415bbc8f9616257585e972cc38f9a1ae073501365c302003d804a3b0a71e"
    sha256 ventura:       "e42b87f4f25e29420ed63aebfd7044bfbfab0ee39a19c11eea6ad2b62679a7ae"
    sha256 arm64_linux:   "efc69b3597a1dc09bb39e029a41d0f90994cfb068d13a5367e323f89f1057423"
    sha256 x86_64_linux:  "8215c2ae409305a49eef2577a37c49b78a7db9f0b66d113c4f74b5cf4ae2ce63"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
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
      .section .text
      .globl _start
      _start:
          mov x0, #0
          mov x16, #1
          svc #0x80
    ASM
    system bin/"aarch64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{bin}/aarch64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/aarch64-elf-c++filt _Z1fv")
  end
end
