class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "0969645b1766aa7280cb23392da79248549b302b90c3d983826746f6e8a44e35"
    sha256 arm64_monterey: "6c9636d966ea3d95e9147056ab2e14e1c203023fa11be042bbb1fabf183f085a"
    sha256 arm64_big_sur:  "11afb15debb99ef8a1475e90551be8baafd10e14a9507753d9fbcab378abea77"
    sha256 ventura:        "7f753b8c8264e707452a60793fbee38b4e11d93630b2637f2fc49364e1b08fe9"
    sha256 monterey:       "aac1095204267bd257b9d90219dcfd278fbc438f9cbc7418b1d137f6e8701f2d"
    sha256 big_sur:        "42629840da2048dd49447f356b4152ca8dd948a7f4b7ad8cc2e4ed527d241ca5"
    sha256 x86_64_linux:   "36f833ce6e67de8d5049e965e6e6e23e904f4f2c539c02636cf71b6c30eec3d8"
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
