class MipsLinuxGnuBinutils < Formula
  desc "GNU Binutils for mips-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "1dc95e92059f444c2bbdf0a2f423773c761cecd87fbe557c88349515745a4bde"
    sha256 arm64_sequoia: "f76ec09163bc47f161857ca701309c9cda6d739909799f6e9616428b479059ef"
    sha256 arm64_sonoma:  "22a44edc099d4f6165b2d172cb31e2b54e4cc65fa23ab8be8f9a80543b4d5baa"
    sha256 sonoma:        "601a50881c97f4c343dd351cbe2be60a680edf8f9c9715d8de2142ff100182b5"
    sha256 arm64_linux:   "fc6fa3570e8fd594394a1c92ea52cff6258976c7743a50f43f3d60177d9be8ca"
    sha256 x86_64_linux:  "dcf247249c8de84cddb3e3d3d3c68e7ff1e0fff8069251ff01245d8a5d9cd13e"
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
