class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "4f3f3c2d79ef87cf5a38af1417ddd66d80d8df4ead19e1bcf66b81a5b169228a"
    sha256 arm64_ventura:  "bca2b0a9229c30435a5275559c2ddc323311f4423e4e73e7bf2e1924bb087f25"
    sha256 arm64_monterey: "ac6fff6622a52b2de718c279e5cdba37d53ae440d230546ef3602f30f144ae5b"
    sha256 sonoma:         "225f3236297b34ba5c66ab0c782e6a86005b23013535cd33ae81193474503367"
    sha256 ventura:        "21bccf5541e89a06490634df099ace243cf25d775d166af499755a23cc583d12"
    sha256 monterey:       "db1189c824be7ae6fbfd64027bc974ef92761c9bb775a677370c47cccef8cb2c"
    sha256 x86_64_linux:   "926d81ed3cc4cd9948e45d06279f278f6c6ae16128cd90d2d5e9ef253378879f"
  end

  depends_on "pkg-config" => :build
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
