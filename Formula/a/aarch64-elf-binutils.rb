class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "a24365324be5d8859b33565c16883284547d7672fb69c6a1c8ac92de83fe3b7a"
    sha256 arm64_sequoia: "a3fa459b1396c8d55ef91fabe9aeed5f900256d16f3b82c9ad112e40877691cc"
    sha256 arm64_sonoma:  "ff07bd6a91ec477ab9035dbefa970ad35e12083404cc837f613f3b2d572d692f"
    sha256 sonoma:        "696371215f41c5b8890c8f9d665ac75319f3f34825fa98485608909d672e596c"
    sha256 arm64_linux:   "af744ca0e81b74ffdf76ba73bf2d11da9acd96e3f370db0a20f6a6362438d1f1"
    sha256 x86_64_linux:  "cbccecb603b3f0e296cdc5c343575b26b8a02aa72344f5293c23b678ffe2c7fb"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
