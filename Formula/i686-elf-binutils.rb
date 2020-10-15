class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.35.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.35.1.tar.xz"
  sha256 "3ced91db9bf01182b7e420eab68039f2083aed0a214c0424e257eae3ddee8607"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "a71d3f952d1a1d9a59c3759dc7b87fdd4ec0036fb77d0156ff3f84627bbc1a1c" => :catalina
    sha256 "845a38bb82fdcd66d2b7464e21d228b8db5e34551671056079c488e6c714f818" => :mojave
    sha256 "f591e9b3514229690865b05a66d12e1418cbdd217d88a2bf4e7006375e594de0" => :high_sierra
  end

  def install
    system "./configure", "--target=i686-elf",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}/i686-elf-binutils",
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
