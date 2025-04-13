class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "06af07de6ca093b334bd87f2de88a263448611f253d0d0c31bd557ec386bec36"
    sha256 arm64_sonoma:  "932c45d6ec8c2449242f9b32f4cc75ec90b295c1af2cdc02d3a2bfa1a79e7156"
    sha256 arm64_ventura: "2d2236dc183c21ce0adcfaf0abae65bc05edc5583c7c48b3fad228fd69202652"
    sha256 sonoma:        "cf3bfab0f48125c69f6c2166ac1bd69c2c045c163bda75115b1da0ca13d7750a"
    sha256 ventura:       "7862fb7e8858483cbbb8b11d5ba4e513f89e978ac595314ce2a70dfdbb15d1de"
    sha256 arm64_linux:   "7d5f1e23b43b2d56be4ecc2901ad686bcfc1cf71fdb40c8e0c9a43df2a896219"
    sha256 x86_64_linux:  "0eec589c7c132355e1a5c1ce1a033cad808510ff880d5be743e1d762a1fc77fd"
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
