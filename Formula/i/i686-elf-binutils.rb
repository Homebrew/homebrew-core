class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia:  "a982ec150ffe8a236c134e11da09031fb988b635b3dcde8dab900be7e2307327"
    sha256 arm64_sonoma:   "c666e0fa7eb192bd26a49bcb5e0f400b497e6a4afa6c972d90a53c1b7817407c"
    sha256 arm64_ventura:  "dbbe5217dbadd954e0bc166586e2b02a5da58369e53b7e7d0fe8d151e72457e2"
    sha256 arm64_monterey: "5c0a59163674c73d8ec51d7483d088b0d82b0226f7cdb50ae3f412c93430c25f"
    sha256 sonoma:         "411bc87f8ccab10165f7e1001471f0241b07d67610267cb707be8974aa1af508"
    sha256 ventura:        "3652d2d27a8efe6525e7b74b52c4c4c01bcf24e7f4a1d1d65f5bf77ae0bac8fc"
    sha256 monterey:       "ebc991155f41f233df8eaab15da8ff2755f9cc0e8ff00a4fb39412613711a957"
    sha256 x86_64_linux:   "261dda7591614a6c0ff80dff4f7b85b1b746c97dc5510a695fae6f894559e6f9"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i686-elf"
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
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    ASM

    system bin/"i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end
