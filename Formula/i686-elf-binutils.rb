class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.37.tar.xz"
  sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "35e3c75705fb0cd0e024b77fb80a95ec7fbec0f0a5e7b7b8fdd6892d60a15b77"
    sha256 arm64_big_sur:  "04659e65f3d10dc3881947446255bc02f946783669a26daaf79386e99e00039c"
    sha256 monterey:       "50718679c5eba15d5f981fde99b68ea04a39f96253573275a8b1b3f1a8d17998"
    sha256 big_sur:        "5fff1dc8e6b6b0859f21ade50d38937bc04c03b7a36e0c48f3e6848efacf8b46"
    sha256 catalina:       "e67e663a6462dbd85b644a4428c96e7e9ae711b6d70f994383e553b778244541"
    sha256 mojave:         "e7d88b4c27231de4e75cd4568a37c6ad17261ed3857dafc199f130d0bb92d9c9"
    sha256 x86_64_linux:   "adc65062f3bb607eab945a84dee5031394abc3bb9c0f8751bf111c27003c4a02"
  end

  def install
    target = "i686-elf"
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
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS
    system "#{bin}/i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end
