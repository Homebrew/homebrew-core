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
    rebuild 1
    sha256 arm64_tahoe:   "94b594f3b82445d2508a7bbbf23c82b7a0de3d61cf9e657a2e9d23913ae2e533"
    sha256 arm64_sequoia: "8819ec12a0d970f550d30c2689257c63f0eaf47f53d83a428ecb979df4bf4dea"
    sha256 arm64_sonoma:  "5fc7b613f8aae5059f398bd8f1edf251980eeec047ee8ae0d8355a3f21c34526"
    sha256 sonoma:        "0b0c8bc1a2c99e12580ae8ac700074383321d163d8558109994c86bcbe6640d4"
    sha256 arm64_linux:   "3c9dc197b2c8ee65be7102f723e1e5b40f38f5bee7301a5be2fb775868ca7311"
    sha256 x86_64_linux:  "26d2ae87384660ae92caf7e29292d517452108e0d1f27ec76c0f5d9358ac77da"
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
    target = "mipsel-linux-gnu"
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

    system bin/"mipsel-linux-gnu-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-tradlittlemips",
                 shell_output("#{bin}/mipsel-linux-gnu-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/mipsel-linux-gnu-c++filt _Z1fv")
  end
end
