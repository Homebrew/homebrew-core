class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "2e823b0f14aa44305a376f40e5919ec3b5144c75349d1709b6fabf68c3b69089"
    sha256 arm64_sequoia: "8d2f44f98eb0541a68d1f6c52eea4d1b778a0a4573b47bb5dafa63951273c36f"
    sha256 arm64_sonoma:  "5a53611a6e54e663dd131ccb6e1d6458bf606cb2b3f1088f0c1a34b6a3efa053"
    sha256 sonoma:        "f2231160b9a88a05923e7572c0e0b55b8adfd78e8c99fab55275d0e3834a898e"
    sha256 arm64_linux:   "50eb1dbfc6857f103223635d165bcc7268e9355759ee81bc34bd0047905070e4"
    sha256 x86_64_linux:  "7d0d5570eeb220f79f3ad532afef758f28cd7a0a505ac12820069fe4818364e3"
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
