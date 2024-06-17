class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.42.tar.bz2"
  sha256 "aa54850ebda5064c72cd4ec2d9b056c294252991486350d9a97ab2a6dfdfaf12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "6163b3a3bbd5982e1014f3574ed346328021db1cbb17ad153e9637e3c119f4cc"
    sha256 arm64_ventura:  "00a9f5682c616800d01ee003e238c475c89049accdf91b59b758137a9042d192"
    sha256 arm64_monterey: "f6eeabd899b27317df2f8133b64f5b4c707524191f55dc55c42e5c7b212b8907"
    sha256 sonoma:         "9b541b078ca1c68964a415c7f48fb2aa0c66b4c593956df21c6b8d2ae71f9d70"
    sha256 ventura:        "7891227c9827f9a5ae10c89a9ea5ca92cb6e8aa49a4690cad063d9919dc47970"
    sha256 monterey:       "5b526e708d3e4c353f01eac594b26d99f57cb0485831abcc4114de5034901874"
    sha256 x86_64_linux:   "fd34d303cfc6c8c4135653aff5b8ffbe16d76c0e5036b7c3d29adf865b6acf6b"
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
