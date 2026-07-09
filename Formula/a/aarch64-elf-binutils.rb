class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "e172e95b2e6eaec98ee8f6861538e74a3ca0576843c4002c128731e656b793d5"
    sha256 arm64_sequoia: "64ecaa860e6dd5741866dd91456fed9afb9caa86ef1f36de58ed311b26b79043"
    sha256 arm64_sonoma:  "1d9c06c6d78b28d4cab8a243bc7004fe77859e622094981e374e4992e9fa449a"
    sha256 sonoma:        "8f1d8511a6efabf7f74a4f640f5c13d094c2430e05fe56e0bb8604a08c887529"
    sha256 arm64_linux:   "ba8e591a5f6ba888cde383d66bcc72ab680993658fe60f55b7816d7609533460"
    sha256 x86_64_linux:  "63a322341403c8fe803382c2c6048803fbd1d2e2eb5c97dc9628cc851450420c"
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
