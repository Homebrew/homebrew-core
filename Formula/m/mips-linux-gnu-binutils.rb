class MipsLinuxGnuBinutils < Formula
  desc "GNU Binutils for mips-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "7a65b4a937d9ee9ee6d45ebb99cc14944991aeab9439a7b8e113c2c7be361226"
    sha256 arm64_sequoia: "bb6a19f7cdb53158f722543d640154f7790e0e390197e7fe824bc4387b2835f6"
    sha256 arm64_sonoma:  "d79c33763ebd7a87302cd3369363e9134b7649907f52c015befdac212ffa8c2d"
    sha256 sonoma:        "810cd203ed457db043664104041a357895f768153e984de84ffcab0f87d5ecef"
    sha256 arm64_linux:   "370a193c60ef4570baaf561af1c1985496759c74786eb36b76e0f534edc4049d"
    sha256 x86_64_linux:  "0f286dbf7f079e445f5fd23b254aadb3043e1a85e2b0afc2099db83e25178051"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "mipsel-linux-gnu-binutils", because: "both install `libdep.so` library"

  def install
    target = "mips-linux-gnu"
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

    system bin/"mips-linux-gnu-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-tradbigmips",
                 shell_output("#{bin}/mips-linux-gnu-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/mips-linux-gnu-c++filt _Z1fv")
  end
end
