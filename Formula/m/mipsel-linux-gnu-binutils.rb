class MipselLinuxGnuBinutils < Formula
  desc "GNU Binutils for mipsel-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "18ab937674e4c11dbe03c4df8950082440a724fd88952f4d25bc3890d06884f5"
    sha256 arm64_sequoia: "bea26e8c9806bcd5a1e477b767befb06b3618c080b849724ea617b959c2d0f13"
    sha256 arm64_sonoma:  "04cdfa8c9f290b0c63bf304a2d0c361b9e1dadc73ef58f3356942aa8a8f80480"
    sha256 sonoma:        "2b761cc78e9aa4ff08898c9bb2c292ea7ce0d676c4840d0bc927a5c0ecf9cc1f"
    sha256 arm64_linux:   "32e135ff90d4b11b839178cbdc83a15c7ae76dbf03193340956666fd84fad9bb"
    sha256 x86_64_linux:  "19d9cd2e7c008467ef3a090ca749804754046e665116b93ec5a201bb57a5ca04"
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
