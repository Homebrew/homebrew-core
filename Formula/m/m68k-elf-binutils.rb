class M68kElfBinutils < Formula
  desc "GNU Binutils for m68k-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "2d13019a91e96df4bec9d103b27bf8e762937caf8f06bd9b3a82593ffc411ee4"
    sha256 arm64_sonoma:  "0f60c3ff36204622b577350ce4031ce145d4c6c8284245f04de949816702284c"
    sha256 arm64_ventura: "a5ed324082026d635a02de4cc13bd7a4295be5d35206473dedbd7a551bff7254"
    sha256 sonoma:        "02e128023ae78f6353cf68d79e00e92e7bda8ca424f0f6e7dbf0d01e781979b9"
    sha256 ventura:       "b138ddd64a69bb9a42a5c5e76c3223365f3b23b3e282fba0df09feaa6b5fc5a4"
    sha256 arm64_linux:   "2ebde00a78fe1ae79422738253647d1142850bc58467376a99a971842460b4b5"
    sha256 x86_64_linux:  "8f2c362af5db10ad9e8aa38efbe0cb2440231d73747f54a2c3f48f49cff52277"
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
