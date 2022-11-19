class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "65a12a7a0fda3fa76164498228ca38199a684e587aeb7191027f062e2c9dcd15"
    sha256 arm64_monterey: "b165b5ea4d9c0f6c48ae911424b947d0b5fbefe7326a4b08264bcab238adc311"
    sha256 arm64_big_sur:  "e6fd77d3044070196bcc97994e30103314c202cafbb8d388297b016fe743906a"
    sha256 ventura:        "d4d611501501328f9de1ca66dc1d9467dc8c5fea3005a8c9ae7f8b60f323439c"
    sha256 monterey:       "9f98933cb5be01be6656c48b0a6af873d052c0a8d2035764aabacb0aa30f7609"
    sha256 big_sur:        "770b6be941d02848584d1cde5563ccd28c858016818283ac74e57e5c88026f3b"
    sha256 catalina:       "de959fa65f1b4ecbf25f0684f652fab3b65fd1112e17a4b92d1295a49dea7c08"
    sha256 x86_64_linux:   "02f56bd4afbcefb52a060a677150939ccbdb13c19cfa6fc3e99796564c1cb864"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
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
