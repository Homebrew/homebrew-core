class MipselLinuxGnuBinutils < Formula
  desc "GNU Binutils for mipsel-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "4f2876466d14051cf1cf6890da71148670f00c82610a5fe20592883ffa119444"
    sha256 arm64_sequoia: "2a920ce4962541fbcd5ae03208e48cd9a562b972faf85a76938012e26aa44a78"
    sha256 arm64_sonoma:  "b82236a26d9b2235a5f8de2d1d8788b2fbb64b92d56c1876bd588bc11267d744"
    sha256 sonoma:        "7f1439192d29370f05571db6e11567524b075949d267b3e6847006d6334bec51"
    sha256 arm64_linux:   "6947cc92890d2080de3d2cab0c717848b23e0a15585520d07ea77dbaae5f4866"
    sha256 x86_64_linux:  "6cd7b50a76625e3dc2be82a336c8be32825d79266a589688e1f8268b59634a5e"
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
