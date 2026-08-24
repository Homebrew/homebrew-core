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
    rebuild 1
    sha256 arm64_tahoe:   "980558e817525f937d255feeb3fe04334261f903a169e76a5cbdef4a5cdffd2b"
    sha256 arm64_sequoia: "1ec55ff7f1a0c691ab2566c2ef8b42fe48e0602bd3550da8b05329ca30d5a4f4"
    sha256 arm64_sonoma:  "bc26ae6f64cdfff6bcf45163be239e242087c949b21353a17148cfadbf3e30f0"
    sha256 sonoma:        "66d0f60b05eae9c0e256998fdee0f175be496dab0490d4d23e40d40220e71627"
    sha256 arm64_linux:   "efbf454b8d303176868e658774f40a00cf4ef60286d447722338368b2df0690f"
    sha256 x86_64_linux:  "663da8dfdfd845490e9fdf7fc76dc7a512f1062388a38c4cf3d69adbf4919491"
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
    target = "mips-linux-gnu"
    system "./configure", "--target=#{target}",
                          "--infodir=#{info/target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls",
                          *std_configure_args(libdir: lib/target)
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
