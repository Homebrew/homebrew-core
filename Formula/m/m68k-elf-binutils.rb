class M68kElfBinutils < Formula
  desc "GNU Binutils for m68k-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "b6e009de7d9ac6019bded258de92fbf01c5315deb84296320b076c29d9643c57"
    sha256 arm64_sequoia: "c781c9dfaf1ed9e03bd196a5e31fa428212a06672ccf3804c52bc6b0c992c957"
    sha256 arm64_sonoma:  "cabae90789309cab540fb742a585cb66af035ce03e2569e469b61bcb37f2a5c3"
    sha256 sonoma:        "f3b5f988048d5ef87a4a4b45f90c738e1337ce9a7727d55f817cec74959a05d2"
    sha256 arm64_linux:   "f26b8058f421a7cc6b03d4a201bd4778924739b5283f66d4c012edf6a8a8c0bf"
    sha256 x86_64_linux:  "e1df8e469d22a893ddb98a989e732e1128d8bb5f9bbf967a3af885310e38b5fd"
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
