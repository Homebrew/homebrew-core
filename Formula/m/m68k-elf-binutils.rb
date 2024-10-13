class M68kElfBinutils < Formula
  desc "GNU Binutils for m68k-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "a639815d8c2a5c622987e5d0321d0340d65ffbe116d40516e37abc82a5060db5"
    sha256 arm64_sonoma:  "91ca55dad31c7914b101bdbf6e4977f9a5a556ddc7ce933f1eb5c460689d1f32"
    sha256 arm64_ventura: "8e8119e5fc1eef55a01bd4ad0525cdf44350c0b66a1f09d6067ff6684977523f"
    sha256 sonoma:        "94ed2bc055753fbfc6f91384185edf78ff76379a465240508df924951447f0e5"
    sha256 ventura:       "7e8e89c9ed43be2afc20492a78eb88ba1ac69e52e61e93c67f9c14e8089dc845"
    sha256 x86_64_linux:  "1bf1b448a1db6fd2784405902d6598d485bb713b1016d9ca68f56e5531ca158e"
  end

  depends_on "pkg-config" => :build
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
    (testpath/"test-s.s").write <<~EOS
      .section .text
      .globl _start
      _start:
          move.b #42, d0
          move.b #42, d1
    EOS

    system bin/"m68k-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-m68k",
                 shell_output("#{bin}/m68k-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/m68k-elf-c++filt _Z1fv")
  end
end
