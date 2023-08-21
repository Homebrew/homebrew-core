class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "446d041fddffb999b73b38e49c9363c65a3fdc7ff708a0cc1ee4bb64298c9b31"
    sha256 arm64_monterey: "089ee6620bedb633fe986c50d9e540c7bc6099519e6652e537d04bb10334750f"
    sha256 arm64_big_sur:  "44e895834d33f67056570b7ca7de0ae6721d4bbf2dace5e27dccd20ae8afd820"
    sha256 ventura:        "e24a5d453a925f1240e7e753a098328ccaa8670a392e2d4898a0b805d8a24310"
    sha256 monterey:       "0339d54d096bd0cdd4c7592c5db57f2a6a39041225cfc9688bd7eb8581caa277"
    sha256 big_sur:        "cecf0afa0f8176b0342444e9c8f6236d6d35093ab28769833eb92cacf0cbd942"
    sha256 x86_64_linux:   "437e5bb688e90abf63efb2311b1685a77f701a2a3f17315d96e70e9c690df5fe"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
    system "./configure", "--target=#{target}",
           "--prefix=#{prefix}",
           "--libdir=#{lib}/#{target}",
           "--infodir=#{info}/#{target}",
           "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .text
      .globl _start
      _start:
          mov x0, #0
          mov x16, #1
          svc #0x80
    EOS
    system "#{bin}/aarch64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{bin}/aarch64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/aarch64-elf-c++filt _Z1fv")
  end
end
