class M68kElfBinutils < Formula
  desc "GNU Binutils for m68k-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "4f67e5ae4116b1b751ef5e974e3f04c49bfa571e05935143e554e769adbbf030"
    sha256 arm64_sequoia: "702e9bdbaa65af1f31c6d5d9384c8e50f181d165f381ce5e062f8de221c05d0d"
    sha256 arm64_sonoma:  "2bf0fc104f74734000b6541d6174336e95881e1ba1dbad868abdb355a8d7ddb2"
    sha256 sonoma:        "e9a96fb3344fac2d00b680a946631ff710b60c377e760a13dd4c97876505b61d"
    sha256 arm64_linux:   "a9cbe78ea4c431ba0824b0e6f34d3df385a738ee694769786d24c05f5e981e99"
    sha256 x86_64_linux:  "0bd59b4380d297a47a3a66eddafebe87001219b58103e081003a565bda3c3e27"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "m68k-elf"
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
    (testpath/"test-s.s").write <<~M68K
      .section .text
      .globl _start
      _start:
          move.b #42, d0
          move.b #42, d1
    M68K

    system bin/"m68k-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-m68k",
                 shell_output("#{bin}/m68k-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/m68k-elf-c++filt _Z1fv")
  end
end
