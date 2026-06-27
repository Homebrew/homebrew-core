class MipselLinuxGnuBinutils < Formula
  desc "GNU Binutils for mipsel-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "e52c96985840f427b635170bb3c976ac5169b8b28dc774fe2179935947a83667"
    sha256 arm64_sequoia: "d8e6026c4c23c42d7afbc29ba338ad4042ea7002bada21443481f349d6d17eee"
    sha256 arm64_sonoma:  "7579ca155484d41d5c0de51c202d9a860a1976533613e7e0318592f4f4fe2211"
    sha256 sonoma:        "443cab5cd377cb271ae37312acad62d793e261252d134ecfd1f3ab75121c4491"
    sha256 arm64_linux:   "02c12881114ec2f65f5313f02d3a3583c6adae66d313098abbd86cadb853e333"
    sha256 x86_64_linux:  "1c91713474b21ffaa919d4edc42393d3ddbe7dafe2ac8d3924808b82c7c9efbd"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "mips-linux-gnu-binutils", because: "both install `libdep.so` library"

  def install
    target = "mipsel-linux-gnu"
    system "./configure", "--target=#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls",
                          *std_configure_args(libdir: lib/"target")
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .text, "ax"
      .set noat
      .globl _start
      _start:
          addiu $v0, $zero, 0
          j $ra
    ASM

    system bin/"mipsel-linux-gnu-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-tradlittlemips",
                 shell_output("#{bin}/mipsel-linux-gnu-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/mipsel-linux-gnu-c++filt _Z1fv")
  end
end
