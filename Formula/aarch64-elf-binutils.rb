class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "8df73acaded40e59291ce9afdc17918f655a4ceb8884f04647b90eb94d59af13"
    sha256 arm64_big_sur:  "a86842be0ff1841bdc7666b2c6ff4143a83e18a6fc6de147e088055ef4da77a5"
    sha256 monterey:       "80f0787d5735fa015bebde54cd449f4ca7553163c8e869315dca9c89d077801f"
    sha256 big_sur:        "def04262f48a5bc1a5b3a9b1331c7eabde55b65c1ca4cf565bda1b075b656846"
    sha256 catalina:       "707c2aa4f1b263090f811dfa3aba67b890ad64cab3e932266d308ce12a6ba41d"
    sha256 x86_64_linux:   "adc92ac904443623aa1a2a27c03b5ed7f89dd07dede7f297cd4bdaa83c20850a"
  end

  uses_from_macos "texinfo"

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
