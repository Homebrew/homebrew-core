class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "b551ada8f9a18ae28a308346a364b02015fc9e8da71fed07ca1007be3f9f9033"
    sha256 arm64_sequoia: "dc662682d7410d10798269944b4fabf07cf19e6e1c59026b07ad5f719a024bcd"
    sha256 arm64_sonoma:  "9f0216d763ea8e35bba5ed3910893460d378542139b1801c88f506480527c9dc"
    sha256 sonoma:        "259070e96a7e549ace586ebe32a067ec2219079fa12b6c2b1880dc308f7607fa"
    sha256 arm64_linux:   "7a18b15ccbc99b5ecde7ceb9fa36770fbe88c386944be122076ce1d235e4974c"
    sha256 x86_64_linux:  "090651a9a079134a2f23919531e9aa2a57286d04a9ff78755e846b6e0bc8fc68"
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
