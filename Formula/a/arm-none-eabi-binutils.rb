class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "841cb7bf35ee7a2d0524894b6b53ca03450f28e1eff25f3edf814f3b2bc7a13e"
    sha256 arm64_sequoia: "137fdfc34bd2b4d607b71d2f7ab1fb5fae7d436d938741b8ea90eac125508dde"
    sha256 arm64_sonoma:  "82d4dcbb3f06dc7ee573e75fef4d328078fcf41090a271d4c7b6bc98fb11e46d"
    sha256 sonoma:        "51d78f210dc5f300f779f0c85001a2d88c90df0db8a8798b8703cf56a1fc23c4"
    sha256 arm64_linux:   "4bc46cf1db28bef8fcc91f35325aedc44aeca8625d7bf1b397bfb1f3c47e2d69"
    sha256 x86_64_linux:  "a2f7f00f8c87688c9a6cd81fe8f3b71dfd93f67b78a8425c49c1af8ff4dd6a84"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--enable-multilib",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .text
      .globl _start
      _start:
          mov r1, #0
          mov r2, #1
          svc #0x80
    ASM

    system bin/"arm-none-eabi-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-littlearm",
                 shell_output("#{bin}/arm-none-eabi-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/arm-none-eabi-c++filt _Z1fv")
  end
end
