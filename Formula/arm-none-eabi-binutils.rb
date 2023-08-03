class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
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
          mov r1, #0
          mov r2, #1
          svc #0x80
    EOS
    system "#{bin}/arm-none-eabi-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-littlearm",
                 shell_output("#{bin}/arm-none-eabi-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/arm-none-eabi-c++filt _Z1fv")
  end
end
