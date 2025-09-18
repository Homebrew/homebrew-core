class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "700c2d2ce4189b280b2bafa0cfb373391e5e171a514dad37a2b2565a33fd3b9e"
    sha256 arm64_sequoia: "555d443f33c1fe479481a48d61bffb0be295b89e75c378d53a4052747030e18a"
    sha256 arm64_sonoma:  "4d77f3e9d17697880181ea56ed7d931dd3be1a3c9e4ed3c501cbeb7ac18b1769"
    sha256 arm64_ventura: "2c700e06335b4c282fc7605367a1da70f71daa9b52057c20ada64d2fac6cdce8"
    sha256 sonoma:        "be78db6eeaf1dccbd64555553078e278c4607eef88ef3a5289b3a5905b378856"
    sha256 ventura:       "895227b5d0ea3997bce325b5d5b25c847a3faf807b31b73298ae254ef0da711f"
    sha256 arm64_linux:   "ed34e104bc3f039f84e3f55cedde122b6a968141a614f4437dd720f9f08c5cce"
    sha256 x86_64_linux:  "c7d674b57892d51fbc3c5010609fa3fab69572d8efbc66403b936c94dab1da44"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
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
