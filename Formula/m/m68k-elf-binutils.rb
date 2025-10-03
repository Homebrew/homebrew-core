class M68kElfBinutils < Formula
  desc "GNU Binutils for m68k-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "d8c521f9b163c851ce24fed27e057e3b87489a1e6e9b5e7d06252dc7ec3c00f9"
    sha256 arm64_sequoia: "a44a0a9b22a21f9245f7c6b77f572f2acacb64cb60b0b51cb1e13fb0fa51993f"
    sha256 arm64_sonoma:  "31c124f384abd84d2b9576c8c6c4da0e935e9c40f773d16db6e9b707b06e03ea"
    sha256 arm64_ventura: "2c6ec090541e2ae3d89ebd3f10cd6b2c4232057c1f50749a653fc5726b083bfc"
    sha256 sonoma:        "d0bf07bde52d2dd73202315b0225265bac3af4b2d7893cee9afb48e7fa5c20a8"
    sha256 ventura:       "15bd95f6dae94d64e62f3910ecfa2169eb5a127ddf97fe00232897363bb0589a"
    sha256 arm64_linux:   "ee2bd2132672e2693882422d6f1fba0cddf72604fea29c993a07f256ed946b3e"
    sha256 x86_64_linux:  "fbf720c52d35e9be65305acc2fbc5a5b47e7871d12bffb3463179736a69fd07d"
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
